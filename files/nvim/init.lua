-- =============================================================================
-- Basic Settings
-- =============================================================================
vim.g.mapleader = " "          -- Space as leader key (you'll use this a LOT)
vim.g.maplocalleader = " "

vim.opt.number = true          -- Show line numbers
vim.opt.relativenumber = true  -- Relative line numbers (great for vim motions!)
vim.opt.tabstop = 4            -- Tab = 4 spaces
vim.opt.shiftwidth = 4         -- Indent = 4 spaces
vim.opt.expandtab = true       -- Use spaces, not tabs
vim.opt.smartindent = true     -- Auto-indent new lines

-- Go uses tabs (gofmt convention)
vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
        vim.opt_local.expandtab = false
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
    end,
})
vim.opt.wrap = false           -- Don't wrap long lines
vim.opt.ignorecase = true      -- Case-insensitive search...
vim.opt.smartcase = true       -- ...unless you type a Capital
vim.opt.termguicolors = true   -- True color support
vim.opt.signcolumn = "yes"     -- Always show sign column (prevents layout shift)
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
vim.opt.scrolloff = 8          -- Keep 8 lines above/below cursor
vim.opt.updatetime = 250       -- Faster updates
vim.opt.timeoutlen = 1000      -- Time to complete a key sequence (default)
vim.opt.splitright = true      -- New vertical splits go right
vim.opt.splitbelow = true      -- New horizontal splits go below
vim.opt.cursorline = true      -- Highlight current line
vim.opt.swapfile = false       -- Don't create swap files

-- =============================================================================
-- Bootstrap lazy.nvim (plugin manager)
-- =============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- =============================================================================
-- Plugins
-- =============================================================================
local leet_arg = "leetcode.nvim"

require("lazy").setup({
    -- Colorscheme
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("gruvbox")
        end,
    },

    -- Telescope (fuzzy finder + required by leetcode.nvim)
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
        },
    },

    -- LeetCode
    {
        "kawre/leetcode.nvim",
        lazy = leet_arg ~= vim.fn.argv(0, -1),
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-telescope/telescope.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            arg = leet_arg,
            lang = "golang",
        },
    },

    -- Treesitter (better syntax highlighting)
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "v",
                        node_incremental = "v",
                        node_decremental = "V",
                    },
                },
            })
            -- Install parsers for our languages
            vim.api.nvim_create_autocmd("VimEnter", {
                once = true,
                callback = function()
                    local parsers = { "go", "javascript", "typescript", "lua", "html" }
                    for _, lang in ipairs(parsers) do
                        pcall(vim.treesitter.language.add, lang)
                    end
                    vim.cmd("silent! TSUpdate")
                end,
            })
        end,
    },

    -- LSP
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "gopls", "ts_ls" },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Go
            vim.lsp.config("gopls", { capabilities = capabilities })
            vim.lsp.enable("gopls")

            -- TypeScript / JavaScript (ts_ls handles both)
            vim.lsp.config("ts_ls", { capabilities = capabilities })
            vim.lsp.enable("ts_ls")

            -- LSP keybindings (active when LSP attaches to a buffer)
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(event)
                    local map = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
                    end
                    map("gd", vim.lsp.buf.definition, "Go to definition")
                    map("gr", vim.lsp.buf.references, "Go to references")
                    map("K", vim.lsp.buf.hover, "Hover documentation")
                    map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
                    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
                    map("<leader>d", vim.diagnostic.open_float, "Show diagnostic")
                    map("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
                    map("]d", vim.diagnostic.goto_next, "Next diagnostic")
                end,
            })
        end,
    },

    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",    -- LSP completions
            "hrsh7th/cmp-buffer",       -- Buffer word completions
            "hrsh7th/cmp-path",         -- File path completions
            "L3MON4D3/LuaSnip",        -- Snippet engine (required by nvim-cmp)
            "saadparwaiz1/cmp_luasnip", -- Snippet completions
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            cmp.setup({
                enabled = false,
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                performance = {
                    debounce = 150,        -- Wait 150ms before triggering completion
                    throttle = 50,
                },
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                    { name = "buffer" },
                    { name = "path" },
                }),
            })
        end,
    },
})

-- =============================================================================
-- Useful Keybindings
-- =============================================================================
local map = vim.keymap.set

-- Window navigation (Ctrl + h/j/k/l to move between splits)
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Move selected lines up/down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centered when scrolling
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- LeetCode
map("n", "<leader>lr", "<cmd>Leet run<CR>", { desc = "Leet run" })
map("n", "<leader>ls", "<cmd>Leet submit<CR>", { desc = "Leet submit" })
map("n", "<leader>ll", "<cmd>Leet<CR>", { desc = "Leet menu" })
