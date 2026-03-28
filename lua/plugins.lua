-- ~/.config/nvim/lua/plugins.lua
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  -- Packer itself
  use 'wbthomason/packer.nvim'

  -- FZF
  use {'junegunn/fzf', run = function() vim.fn['fzf#install']() end }
  use 'junegunn/fzf.vim'

  -- Airline
--  use 'vim-airline/vim-airline'
  use 'ryanoasis/vim-devicons'

  -- Colorschemes
--  use 'arcticicestudio/nord-vim'
  use 'folke/tokyonight.nvim'
	use 'ellisonleao/gruvbox.nvim'

  -- Pandoc
  use 'vim-pandoc/vim-pandoc'
  use 'vim-pandoc/vim-pandoc-syntax'

  -- Git & file navigation
  --use 'preservim/nerdtree'
  use 'tpope/vim-fugitive'
  use 'christoomey/vim-tmux-navigator'

  -- Coding helpers
  use 'jiangmiao/auto-pairs'
  use 'preservim/nerdcommenter'
  use 'embear/vim-localvimrc'
  -- use {'fatih/vim-go', run=':GoUpdateBinaries'}
	--use 'folke/which-key.nvim'

	-- trial
  use 'neovim/nvim-lspconfig'
  use 'mason-org/mason.nvim'
  use 'mason-org/mason-lspconfig.nvim'

  -- Completion
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'

  -- Snippets (optional)
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'


  -- Lua / Neovim ecosystem
  use 'nvim-lua/plenary.nvim'
  use {'nvim-telescope/telescope.nvim', tag='0.1.4'}
  use {'nvim-tree/nvim-web-devicons'}
  use {'nvim-treesitter/nvim-treesitter', run=':TSUpdate'}

	-- rust
	use 'simrat39/rust-tools.nvim'

  if packer_bootstrap then
    require('packer').sync()
  end
end)

