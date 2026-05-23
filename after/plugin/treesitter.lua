require('nvim-treesitter').setup{

    ensure_installed = {"c", "help", "javascript", "typescript", "c_sharp", "lua"},
    
    -- Install parsers syncrhrounously (only applied to 'ensured_installed`)
    sync_install = false,

    --Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,


    highlight = {
        enable = true,
        addtional_vim_regex_highlighting = false,
    },
}
