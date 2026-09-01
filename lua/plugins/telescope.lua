-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin
local telescope_ignore_patterns = {
    ".*lock",
    ".*lock.json",
    "node_modules/",
    ".next/",
    ".git/",
    "dist/",
    "build/",
    "%.png",
    "%.jpg",
    "%.jpeg",
    "%.webp",
    "%.o",
    "%.a",
    "%.so",
    "%.bin",
}

vim.g.telescope_ignore_enabled = true

return {
    { -- Fuzzy Finder (files, lsp, etc)
        "nvim-telescope/telescope.nvim",
        event = "VimEnter",
        branch = "master",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { -- If encountering errors, see telescope-fzf-native README for installation instructions
                "nvim-telescope/telescope-fzf-native.nvim",

                -- `build` is used to run some command when the plugin is installed/updated.
                -- This is only run then, not every time Neovim starts up.
                build = "make",

                -- `cond` is a condition used to determine whether this plugin should be
                -- installed and loaded.
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
            { "nvim-telescope/telescope-ui-select.nvim" },

            -- Useful for getting pretty icons, but requires a Nerd Font.
            { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
        },
        config = function()
            -- Telescope is a fuzzy finder that comes with a lot of different things that
            -- it can fuzzy find! It's more than just a "file finder", it can search
            -- many different aspects of Neovim, your workspace, LSP, and more!
            --
            -- The easiest way to use Telescope, is to start by doing something like:
            --  :Telescope help_tags
            --
            -- After running this command, a window will open up and you're able to
            -- type in the prompt window. You'll see a list of `help_tags` options and
            -- a corresponding preview of the help.
            --
            -- Two important keymaps to use while in Telescope are:
            --  - Insert mode: <c-/>
            --  - Normal mode: ?
            --
            -- This opens a window that shows you all of the keymaps for the current
            -- Telescope picker. This is really useful to discover what Telescope can
            -- do as well as how to actually do it!

            -- [[ Configure Telescope ]]
            -- See `:help telescope` and `:help telescope.setup()`
            local egrep_actions = require("telescope._extensions.egrepify.actions")
            require("telescope").setup({
                -- You can put your default mappings / updates / etc. in here
                --  All the info you're looking for is in `:help telescope.setup()`
                --
                -- defaults = {
                --   mappings = {
                --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
                --   },
                -- },
                -- pickers = {}
                -- pickers = {
                -- 	live_grep = {
                -- 		additional_args = function()
                -- 			return { "--hidden" }
                -- 		end,
                -- 	},
                -- },
                defaults = {
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                        "--hidden",
                        "--glob=!.git/",
                    },
                    -- Add debounce settings
                    prompt_prefix = "> ",
                    selection_caret = "> ",
                    entry_prefix = "  ",
                    initial_mode = "insert",
                    layout_strategy = "horizontal",
                    layout_config = {
                        horizontal = {
                            prompt_position = "bottom",
                            preview_width = 0.55,
                            results_width = 0.8,
                        },
                        vertical = {
                            mirror = false,
                        },
                        width = 0.87,
                        height = 0.99,
                        preview_cutoff = 120,
                    },
                    set_env = { ["COLORTERM"] = "truecolor" }, -- improve performance
                    -- path_display = { "smart" },
                    file_ignore_patterns = vim.g.telescope_ignore_enabled
                            and telescope_ignore_patterns
                        or {},

                    -- Custom display for grouped results
                    -- Shows filename once as header with matched rows below
                    -- Properly format grouped display headers
                    -- group_by_display = function(display_entry)
                    --     -- For grouped results, display the filename as a header
                    --     return display_entry.value
                    -- end,
                    extensions = {
                        ["ui-select"] = {
                            require("telescope.themes").get_dropdown(),
                        },
                        fzf = {
                            fuzzy = true,
                            override_generic_sorter = true,
                            override_file_sorter = true,
                            case_mode = "smart_case",
                        },
                    },
                },
                pickers = {
                    live_grep = {
                        grouped = true,
                        group_by = "filename",
                        result_formatter = function(entry)
                            -- Format just the matched text with line and column
                            return string.format("%s (%d:%d)", entry.text, entry.lnum, entry.col)
                        end,
                    },
                    grep_string = {
                        grouped = true,
                        group_by = "filename",
                        result_formatter = function(entry)
                            -- Format just the matched text with line and column
                            return string.format("%s (%d:%d)", entry.text, entry.lnum, entry.col)
                        end,
                    },
                },
                extensions = {
                    egrepify = {
                        -- intersect tokens in prompt ala "str1.*str2" that ONLY matches
                        -- if str1 and str2 are consecutively in line with anything in between (wildcard)
                        AND = true, -- default
                        permutations = false, -- opt-in to imply AND & match all permutations of prompt tokens
                        lnum = true, -- default, not required
                        lnum_hl = "EgrepifyLnum", -- default, not required, links to `Constant`
                        col = false, -- default, not required
                        col_hl = "EgrepifyCol", -- default, not required, links to `Constant`
                        title = true, -- default, not required, show filename as title rather than inline
                        filename_hl = "EgrepifyFile", -- default, not required, links to `Title`
                        results_ts_hl = true, -- set to false if you experience latency issues!
                        -- suffix = long line, see screenshot
                        -- EXAMPLE ON HOW TO ADD PREFIX!
                        prefixes = {
                            -- ADDED ! to invert matches
                            -- example prompt: ! sorter
                            -- matches all lines that do not comprise sorter
                            -- rg --invert-match -- sorter
                            ["!"] = {
                                flag = "invert-match",
                            },
                            -- HOW TO OPT OUT OF PREFIX
                            -- ^ is not a default prefix and safe example
                            ["^"] = false,
                        },
                    },
                },
            })

            vim.keymap.set("n", "<leader>ti", function()
                vim.g.telescope_ignore_enabled = not vim.g.telescope_ignore_enabled

                -- display the message on the screen on toggle
                if vim.g.telescope_ignore_enabled then
                    vim.notify("Telescope ignore patterns enabled")
                else
                    vim.notify("Telescope ignore patterns disabled")
                end

                require("telescope.config").set_defaults({
                    file_ignore_patterns = vim.g.telescope_ignore_enabled
                            and telescope_ignore_patterns
                        or {},
                })
            end, { noremap = true, desc = "Toggle telescope ignore patterns" })

            -- Enable Telescope extensions if they are installed
            pcall(require("telescope").load_extension, "fzf")
            pcall(require("telescope").load_extension, "ui-select")
            pcall(require("telescope").load_extension, "egrepify")
            require("telescope").load_extension("noice")

            -- See `:help telescope.builtin`
            local builtin = require("telescope.builtin")
            vim.keymap.set(
                "n",
                "<leader><leader>",
                builtin.find_files,
                { desc = "[S]earch [F]iles" }
            )
            vim.keymap.set("n", "<leader>/", function()
                require("telescope").extensions.egrepify.egrepify()
            end, { desc = "Egrep" })

            -- vim.keymap.set("n", "<leader>/", function()
            --
            --     builtin.egrepify({
            --         search = vim.fn.expand("<cword>"),
            --         -- search = vim.fn.input("Egrepify: ", vim.fn.expand("<cword>"), "customlist,egrepify"),
            --         -- search = vim.fn.input("Egrepify: ", "", "customlist,egrepify"),
            --     })
            --     -- builtin.live_grep({
            --     --     grouped = true,
            --     --     group_by = "filename",
            --     --     additional_args = { "--fixed-strings" },
            --     -- })
            -- end, { desc = "[S]earch by [G]rep" })
            vim.keymap.set(
                "n",
                "<leader><leader>/",
                builtin.live_grep,
                { desc = "[S]earch by [G]rep" }
            )
            vim.keymap.set(
                "n",
                "<leader>sw",
                builtin.grep_string,
                { desc = "[S]earch current [W]ord" }
            )
            vim.keymap.set(
                "n",
                "<leader>sd",
                builtin.diagnostics,
                { desc = "[S]earch [D]iagnostics" }
            )
            vim.keymap.set(
                "n",
                "<leader>b",
                builtin.buffers,
                { desc = "[ ] Find existing buffers" }
            )
            -- vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
            vim.keymap.set("n", "<leader>k", builtin.keymaps, { desc = "which_key_ignore" })
            -- vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
            vim.keymap.set("n", "<leader>r", builtin.resume, { desc = "[S]earch [R]esume" })
            -- vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })

            -- Slightly advanced example of overriding default behavior and theme
            -- vim.keymap.set("n", "<leader>/", function()
            -- 	-- You can pass additional configuration to Telescope to change the theme, layout, etc.
            -- 	builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
            -- 		winblend = 10,
            -- 		previewer = false,
            -- 	}))
            -- end, { desc = "[/] Fuzzily search in current buffer" })

            -- It's also possible to pass additional configuration options.
            --  See `:help telescope.builtin.live_grep()` for information about particular keys
            -- vim.keymap.set("n", "<leader>s/", function()
            -- 	builtin.live_grep({
            -- 		grep_open_files = true,
            -- 		prompt_title = "Live Grep in Open Files",
            -- 	})
            -- end, { desc = "[S]earch [/] in Open Files" })

            -- Shortcut for searching your Neovim configuration files
            -- vim.keymap.set("n", "<leader>sn", function()
            -- 	builtin.find_files({ cwd = vim.fn.stdpath("config") })
            -- end, { desc = "[S]earch [N]eovim files" })
        end,
    },
    {
        "fdschmidt93/telescope-egrepify.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    },
}
