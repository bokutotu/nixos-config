-- Run from the repository root: nvim --headless -u NONE -l home/files/nvim/tests/pr_diff.lua
package.path = 'home/files/nvim/lua/?.lua;' .. package.path

local base = string.rep('a', 40)
local head = string.rep('b', 40)
local info = vim.json.encode({
  number = 42,
  baseRefOid = base,
  headRefOid = head,
  url = 'https://github.com/base-owner/repo/pull/42',
})
local original_system, original_notify, original_cmd = vim.system, vim.notify, vim.cmd
local count = 0

local function test(name, results, check, twice)
  package.loaded['rc.pr_diff'] = nil
  local calls, notices, opened = {}, {}, {}
  vim.system = function(args, opts, callback)
    calls[#calls + 1] = { args = args, cwd = opts.cwd }
    local result = results[#calls]
    assert(result, 'unexpected command: ' .. table.concat(args, ' '))
    callback(result)
  end
  vim.notify = function(message)
    notices[#notices + 1] = message
  end
  vim.cmd = function(command)
    opened[#opened + 1] = command
  end
  local module = require('rc.pr_diff')
  module.open()
  if twice then
    module.open()
  end
  assert(vim.wait(1000, function()
    return #opened > 0 or (#notices > 0 and not twice)
  end), name .. ': timed out')
  check(calls, notices, opened)
  count = count + 1
  print('PASS ' .. name)
end

local success = { code = 0, stdout = '', stderr = '' }
local gh_result = { code = 0, stdout = info, stderr = '' }
local function check_success(calls, notices, opened)
  assert(#calls == 3)
  assert(vim.deep_equal(calls[1].args,
    { 'gh', 'pr', 'view', '--json', 'number,baseRefOid,headRefOid,url' }))
  local fetch = calls[2].args
  -- The base repository provides both commits, including fork PR heads.
  assert(fetch[#fetch - 2] == 'https://github.com/base-owner/repo.git')
  assert(fetch[#fetch - 1] == base and fetch[#fetch] == head)
  assert(vim.tbl_contains(fetch, '--no-write-fetch-head'))
  assert(vim.tbl_contains(fetch, 'credential.helper=!gh auth git-credential'))
  assert(vim.deep_equal(calls[3].args, { 'git', 'merge-base', base, head }))
  for _, call in ipairs(calls) do
    assert(call.cwd == vim.fn.getcwd())
  end
  -- Never compare against HEAD or the working tree: use the PR snapshot.
  assert(opened[1] == 'DiffviewOpen ' .. base .. '...' .. head
    .. ' -C' .. vim.fn.fnameescape(vim.fn.getcwd()))
end

test('PR snapshot and fork fetch', { gh_result, success, success }, function(c, n, o)
  check_success(c, n, o)
  assert(#n == 0)
end)
test('duplicate invocation', { gh_result, success, success }, function(c, n, o)
  check_success(c, n, o)
  assert(#n == 1 and n[1]:find('already running', 1, true))
end, true)

for _, message in ipairs({ 'no pull requests found', 'authentication failed' }) do
  test(message, { { code = 1, stderr = message } }, function(c, n, o)
    assert(#c == 1 and #o == 0 and n[1]:find(message, 1, true))
  end)
end
test('fetch failure', { gh_result, { code = 1, stderr = 'fetch failed' } }, function(c, n, o)
  assert(#c == 2 and #o == 0 and n[1]:find('fetch failed', 1, true))
end)
test('missing common ancestor', { gh_result, success, { code = 1, stderr = '' } }, function(c, n, o)
  assert(#c == 3 and #o == 0 and n[1]:find('merge-base', 1, true))
end)
for _, stdout in ipairs({ 'not json', '{}' }) do
  test('invalid PR information: ' .. stdout, { { code = 0, stdout = stdout } }, function(c, n, o)
    assert(#c == 1 and #o == 0 and #n == 1)
  end)
end

vim.system, vim.notify, vim.cmd = original_system, original_notify, original_cmd
print(string.format('%d tests passed', count))
