vim.pack.add({

	'https://github.com/nvim-lua/plenary.nvim',
	{
		src = 'https://github.com/nvim-telescope/telescope.nvim',
	},

	{
		src = 'https://github.com/rose-pine/neovim',
		as = 'rose-pine',
		config = function()
			vim.cmd('colorscheme rose-pine')
		end
	},
	{
		src = 'https://github.com/nvim-treesitter/nvim-treesitter',
		run = 'TSUpdate'
	},
	'https://github.com/theprimeagen/harpoon',
	'https://github.com/mbbill/undotree',
	'https://github.com/tpope/vim-fugitive',
})
vim.pack.add({'https://github.com/seblyng/roslyn.nvim'})
