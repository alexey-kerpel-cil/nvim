vim.api.nvim_create_user_command("DiffviewFileHistoryCurrent", function()
    local filepath = vim.fn.expand("%:p") -- Get the full path of the current buffer
    if filepath == "" then
        print("No file to show history for")
        return
    end
    vim.cmd("DiffviewFileHistory " .. filepath)
end, {})

return {
    "NeogitOrg/neogit",
    cmd = { "Neogit", "DiffviewOpen", "DiffviewClose", "DiffviewFileHistoryCurrent" },
    keys = {
        { "<leader>n", desc = "[N]eogit" },
        { "<leader>do", desc = "[D]iff [O]pen" },
        { "<leader>dc", desc = "[D]iff [C]lose" },
        { "<leader>df", desc = "[D]iff [F]iles" },
    },
    dependencies = {
        -- "nvim-lua/plenary.nvim", -- required
        "sindrets/diffview.nvim", -- optional - Diff integration

        -- Only one of these is needed.
        "nvim-telescope/telescope.nvim", -- optional
    },
    config = function()
        vim.keymap.set("n", "<leader>n", ":Neogit<CR>", { desc = "[N]eogit" })
        vim.keymap.set("n", "<leader>do", ":DiffviewOpen<CR>", { desc = "[D]iff [O]pen" })
        vim.keymap.set("n", "<leader>dc", ":DiffviewClose<CR>", { desc = "[D]iff [C]lose" })
        vim.keymap.set(
            "n",
            "<leader>df",
            ":DiffviewFileHistoryCurrent<CR>",
            { desc = "[D]iff [F]iles" }
        )
    end,
}
