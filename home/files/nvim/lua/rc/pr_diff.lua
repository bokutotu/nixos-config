local M = {}
local running = false

function M.open()
  if running then
    vim.notify('PRDiff: already running', vim.log.levels.WARN)
    return
  end
  running = true
  local cwd = vim.fn.getcwd()

  local function fail(message)
    running = false
    vim.notify('PRDiff: ' .. message, vim.log.levels.ERROR)
  end

  local function run(args, callback)
    local ok, err = pcall(vim.system, args, { cwd = cwd, text = true }, function(result)
      vim.schedule(function()
        callback(result)
      end)
    end)
    if not ok then
      fail(tostring(err))
    end
  end

  local function checked(args, callback)
    run(args, function(result)
      if result.code ~= 0 then
        fail(table.concat(args, ' ') .. '\n' .. (result.stderr or ''))
        return
      end
      callback(result.stdout)
    end)
  end

  local function open_pr_diff(pr)
    -- Verify that a common ancestor is available (notably in shallow clones).
    checked({ 'git', 'merge-base', pr.base_sha, pr.head_sha }, function()
      running = false
      local ok, err = pcall(vim.cmd, 'DiffviewOpen ' .. pr.base_sha .. '...' .. pr.head_sha
        .. ' -C' .. vim.fn.fnameescape(cwd))
      if not ok then
        fail(tostring(err))
      end
    end)
  end

  local function ensure_pr_commits(pr)
    -- Fetch from the PR's base repository, which also exposes fork PR heads.
    -- Exact OIDs preserve the snapshot returned by gh even if the PR moves.
    -- No local branches, index, or working-tree files are updated.
    checked({ 'git', '-c', 'credential.helper=',
      '-c', 'credential.helper=!gh auth git-credential',
      'fetch', '--no-tags', '--no-write-fetch-head',
      pr.repository_url, pr.base_sha, pr.head_sha }, function()
      open_pr_diff(pr)
    end)
  end

  checked({ 'gh', 'pr', 'view', '--json', 'number,baseRefOid,headRefOid,url' }, function(stdout)
    local ok, info = pcall(vim.json.decode, stdout)
    if not ok or type(info) ~= 'table' then
      fail('could not decode PR information')
      return
    end
    local function is_oid(value)
      return type(value) == 'string' and #value == 40 and value:match('^%x+$')
    end
    local repository_url = type(info.url) == 'string'
      and info.url:match('^(https://.+)/pull/%d+$')
    if not repository_url or type(info.number) ~= 'number'
      or not is_oid(info.baseRefOid) or not is_oid(info.headRefOid) then
      fail('incomplete PR information (number, URL, or commit OIDs)')
      return
    end
    ensure_pr_commits({
      number = info.number,
      base_sha = info.baseRefOid,
      head_sha = info.headRefOid,
      repository_url = repository_url .. '.git',
    })
  end)
end

return M
