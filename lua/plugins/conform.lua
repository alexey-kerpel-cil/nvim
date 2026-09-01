-- local function debug_format(msg, level)
--     level = level or vim.log.levels.INFO
--     vim.notify("[Format Debug] " .. msg, level)
-- end

return { -- Autoformat
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
        debug = true,
        notify_on_error = false,
        format_on_save = function(bufnr)
            local filename = vim.api.nvim_buf_get_name(bufnr)
            -- debug_format("Attempting to format: " .. filename)
            --
            -- -- Log current buffer settings
            -- debug_format("Buffer settings:")
            -- debug_format("Filetype: " .. vim.bo[bufnr].filetype)
            -- debug_format("Encoding: " .. vim.bo[bufnr].fileencoding)
            -- debug_format("Format options: " .. vim.inspect(vim.bo[bufnr].formatoptions))

            -- Disable "format_on_save lsp_fallback" for languages that don't
            -- have a well standardized coding style. You can add additional
            -- languages here or re-enable it for the disabled ones.
            local disable_filetypes = { c = true, cpp = true }
            local lsp_format_opt
            if disable_filetypes[vim.bo[bufnr].filetype] then
                lsp_format_opt = "never"
            else
                lsp_format_opt = "fallback"
            end
            return {
                timeout_ms = 5000,
                lsp_format = lsp_format_opt,
                -- callback = function(err)
                --     if err then
                --         debug_format("Format error: " .. vim.inspect(err), vim.log.levels.ERROR)
                --     else
                --         debug_format("Format successful")
                --     end
                -- end,
            }
        end,
        formatters_by_ft = {
            lua = { "stylua" },
            -- javascript = { "prettier" },
            -- typescriptreact = { "prettier" },
            -- Conform can also run multiple formatters sequentially
            -- python = { "isort", "black" },
            --
            -- You can use 'stop_after_first' to run the first available formatter from the list
            javascript = { "prettierd", "prettier", stop_after_first = true },
            typescript = { "prettierd", "prettier", stop_after_first = true },
            typescriptreact = { "prettierd", "prettier", stop_after_first = true },
            scss = { "prettierd", "prettier", stop_after_first = true },
            json = { "prettierd", "prettier", stop_after_first = true },
            yaml = { "prettierd", "prettier", stop_after_first = true },
            yml = { "prettierd", "prettier", stop_after_first = true },
        },
    },
}
