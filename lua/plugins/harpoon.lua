return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    keys = {
        "<leader>h",
        "<leader>H",
        "<leader>1",
        "<leader>2",
        "<leader>3",
        "<leader>4",
    },
    opts = {
        menu = {
            width = vim.api.nvim_win_get_width(0) - 4,
        },
        settings = {
            save_on_toggle = true,
        },
    },
    config = function()
        local harpoon = require("harpoon")

        harpoon:setup()

        vim.keymap.set("n", "<leader>h", function()
            harpoon:list():add()
        end, { desc = "which_key_ignore" })
        vim.keymap.set("n", "<leader>H", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, { desc = "which_key_ignore" })

        vim.keymap.set("n", "<leader>1", function()
            harpoon:list():select(1)
        end, { desc = "which_key_ignore" })
        vim.keymap.set("n", "<leader>2", function()
            harpoon:list():select(2)
        end, { desc = "which_key_ignore" })
        vim.keymap.set("n", "<leader>3", function()
            harpoon:list():select(3)
        end, { desc = "which_key_ignore" })
        vim.keymap.set("n", "<leader>4", function()
            harpoon:list():select(4)
        end, { desc = "which_key_ignore" })
    end,
}
