vim.lsp.config('roslyn', {
	on_attach = function()
		print("This will run when the server attaches")
	end,
	settings = 
	{
		["csharp|inlay_hints"] = {
			csharp_enable_inlay_hints_for_implicit_object_creation = true,
			csharp_enable_inlay_hints_for_implicit_variable_types = true,
		},
		["csharp|code_lens"] = {
			dotnet_enable_references_code_lens = true,
		},
		["csharp|navigation"] = {
			dotnet_navigate_to_decompiled_sources = true,
		},
		["csharp|completion"] = {
			dotnet_show_completion_items_from_unimported_namespaces = true,
			dotnet_show_name_completion_suggestions = true,
		},
	}
})
vim.lsp.codelens.enable(true)
-- 1. Setup your native UI variables
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.complete = { ".", "w", "b", "u", "t", "o" }
vim.o.autocomplete = true

-- 2. Hook EVERYTHING into the unified LSP buffer attachment system
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        
        -- Safe check: Make sure the server actually loaded
        if not client then return end

        -- A. Activate Native Autocomplete 
        vim.lsp.completion.enable(true, client.id, ev.buf, {})

        -- B. Activate Native CodeLens securely for this buffer
        if client:supports_method("textDocument/codeLens") then
            vim.lsp.codelens.enable(true, { bufnr = ev.buf })
        end
		local opts = {buffer = bufnr, remap = false}
		vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
		vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
		vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
		vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
		vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
		vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
		vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
		vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
		vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
		vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
		vim.keymap.set("i", "<C-space>", function() vim.lsp.completion.get() end, opts)
    end,

})


vim.lsp.enable('roslyn')
