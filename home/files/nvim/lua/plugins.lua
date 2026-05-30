local plugin_specs = {
  { src = 'https://github.com/lanx-x/NeoSolarized' },
  { src = 'https://github.com/github/copilot.vim' },
  { src = 'https://github.com/nvim-lua/popup.nvim' },
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/MunifTanjim/nui.nvim' },
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  { src = 'https://github.com/rcarriga/nvim-notify' },
  { src = 'https://github.com/vim-denops/denops.vim' },
  { src = 'https://github.com/akinsho/bufferline.nvim' },
  { src = 'https://github.com/nvim-lualine/lualine.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope-frecency.nvim' },
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/hrsh7th/nvim-cmp' },
  { src = 'https://github.com/hrsh7th/cmp-buffer' },
  { src = 'https://github.com/hrsh7th/cmp-path' },
  { src = 'https://github.com/hrsh7th/cmp-cmdline' },
  { src = 'https://github.com/hrsh7th/cmp-emoji' },
  { src = 'https://github.com/onsails/lspkind-nvim' },
  { src = 'https://github.com/hrsh7th/cmp-nvim-lsp' },
  { src = 'https://github.com/hrsh7th/cmp-nvim-lsp-signature-help' },
  { src = 'https://github.com/hrsh7th/cmp-nvim-lsp-document-symbol' },
  { src = 'https://github.com/hrsh7th/cmp-nvim-lua' },
  { src = 'https://github.com/saadparwaiz1/cmp_luasnip' },
  { src = 'https://github.com/f3fora/cmp-spell' },
  { src = 'https://github.com/yutkat/cmp-mocword' },
  { src = 'https://github.com/uga-rosa/cmp-dictionary' },
  { src = 'https://github.com/ray-x/cmp-treesitter' },
  { src = 'https://github.com/lukas-reineke/cmp-under-comparator' },
  { src = 'https://github.com/folke/lsp-colors.nvim' },
  { src = 'https://github.com/folke/trouble.nvim' },
  { src = 'https://github.com/nvimdev/lspsaga.nvim', version = 'main' },
  { src = 'https://github.com/simrat39/rust-tools.nvim' },
  { src = 'https://github.com/mrcjkb/rustaceanvim', version = 'main' },
  { src = 'https://github.com/rust-lang/rust.vim' },
  { src = 'https://github.com/RRethy/vim-illuminate' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  { src = 'https://github.com/windwp/nvim-autopairs' },
  { src = 'https://github.com/L3MON4D3/LuaSnip' },
  { src = 'https://github.com/numToStr/Comment.nvim' },
  { src = 'https://github.com/iamcco/markdown-preview.nvim' },
  { src = 'https://github.com/SmiteshP/nvim-navic' },
  { src = 'https://github.com/lukas-reineke/indent-blankline.nvim' },
  { src = 'https://github.com/yuki-yano/fuzzy-motion.vim' },
  { src = 'https://github.com/nvim-tree/nvim-tree.lua' },
  { src = 'https://github.com/sindrets/diffview.nvim' },
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { src = 'https://github.com/udalov/kotlin-vim' },
  { src = 'https://github.com/sbdchd/neoformat' },
  { src = 'https://github.com/akinsho/flutter-tools.nvim' },
  { src = 'https://github.com/mrcjkb/haskell-tools.nvim', version = 'main' },
}

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(event)
    local spec = event.data.spec
    if spec.name ~= 'markdown-preview.nvim' then
      return
    end
    if event.data.kind ~= 'install' and event.data.kind ~= 'update' then
      return
    end
    vim.system({ 'npm', 'install' }, { cwd = event.data.path .. '/app' })
  end,
})

vim.pack.add(plugin_specs, { confirm = false, load = true })
