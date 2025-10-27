-- [[ Install `lazy.nvim` plugin manager ]]
--   See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system {
        'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo,
        lazypath
    }
    if vim.v.shell_error ~= 0 then
        -- error('Error cloning lazy.nvim:\n' .. out)
        -- error('Error cloning lazy.nvim:\n')
    end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require('lazy').setup({
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        config = function() require('nvim-surround').setup({}) end
    },
    {
        "echasnovski/mini.ai",
        config = function() require('mini.ai').setup({}) end
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {},
        -- stylua: ignore
        keys = {
            {
                "s",
                mode = { "n", "x", "o" },
                function() require("flash").jump() end,
                desc = "Flash"
            },
            {
                "SS",
                mode = { "n", "x", "o" },
                function() require("flash").treesitter() end,
                desc = "Flash Treesitter"
            },
            {
                "r",
                mode = "o",
                function() require("flash").remote() end,
                desc = "Remote Flash"
            },
            {
                "R",
                mode = { "o", "x" },
                function() require("flash").treesitter_search() end,
                desc = "Treesitter Search"
            },
            {
                "<c-s>",
                mode = { "c" },
                function() require("flash").toggle() end,
                desc = "Toggle Flash Search"
            }
        }
    },
    {
        "nvim-treesitter/nvim-treesitter",
        branch = 'master',
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "lua", "javascript", "go", "python", "tsx", "html", "css" }, -- parsers you want
                highlight = { enable = true },
                indent = { enable = true },
            })
        end
    },
    {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
        config = function()
            require("ufo").setup({
                -- treesitter not required
                -- ufo uses the same query files for folding (queries/<lang>/folds.scm)
                -- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`-
                provider_selector = function(_, _, _)
                    return { "treesitter", "indent" }
                end,
                open_fold_hl_timeout = 0 -- Disable highlight timeout after opening
            })

            vim.o.foldenable = true
            vim.o.foldcolumn = '0' -- '0' is not bad
            vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
            vim.o.foldlevelstart = 99

            -- za to fold at cursor location is already enabled
            vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
            vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
        end
    }
})

-- vim.o.foldmethod = "expr"
-- vim.o.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.opt.foldcolumn = "1"
-- vim.opt.foldenable = true
-- vim.opt.foldlevel = 99
-- vim.opt.foldlevelstart = 99

-- test with ufo fold
-- vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
-- vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

-- vim.keymap.set('n', 'n', 'nzzzv')
-- vim.keymap.set('n', 'N', 'Nzzzv')
local opts = { noremap = true, silent = true }

-- vim.cmd('nmap n nzz')
-- vim.cmd('nmap N Nzz')

-- vim.cmd([[nnoremap n :normal! nzz<CR>]])
-- vim.cmd([[nnoremap N :normal! Nzz<CR>]])

-- vim.cmd('nmap <C-d> <C-d>zz')
-- This is not working
-- vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
-- vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)

-- vim.keymap.set('n', '<C-d>', function()
--     vim.cmd('normal! <C-d>zz')
-- end, opts)

-- vim.keymap.set('n', '<C-u>', function()
--     -- vim.cmd('normal! <C-u>zz')
--     vim.cmd('normal! <C-u>')
--     vim.cmd('normal! zz')
--     -- vim.cmd('nmap <C-u>zz')
-- end, opts)
--
-- -- Scroll half-page down and recenter
-- vim.keymap.set('n', '<C-d>', '<cmd>normal! <C-d>zz<CR>', opts)

-- -- Scroll half-page up and recenter
-- vim.keymap.set('n', '<C-u>', '<cmd>normal! <C-u>zz<CR>', opts)

-- clear search highlighting
vim.keymap.set('n', '<Esc>', ':nohlsearch<cr>')

vim.keymap.set('n', 'x', '"_x', opts)
vim.keymap.set('v', 'p', '"_dP', opts) -- paste without replacing the default register

-- stay in indent mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- vim.keymap.set('n', 'H', '<Nop>', opts)
vim.keymap.set('n', 'J', '<Nop>', opts)
vim.keymap.set('n', 'K', '<Nop>', opts)
-- vim.keymap.set('n', 'L', '<Nop>', opts)

-- skip folds (down, up) uncomment
vim.cmd('nmap j gj')
vim.cmd('nmap k gk')

--[[ vim.keymap.set('v', 'j', function()
    print('visual mode')
    local cu_line = vim.fn.line('.')
     local fold_status = vim.fn.foldclosed(current_line)

    print(fold_status)

end) ]]

-- vim.keymap.set('n', 'j', 'gj', opts)
-- vim.keymap.set('n', 'k', 'gk', opts)
-- folding
-- vim.api.nvim_set_keymap("n", "za", "<Cmd>call VSCodeNotify('editor.toggleFold')<CR>", opts)
-- vim.api.nvim_set_keymap("n", "zR", "<Cmd>call VSCodeNotify('editor.unfoldAll')<CR>", opts)
-- vim.api.nvim_set_keymap("n", "zM", "<Cmd>call VSCodeNotify('editor.foldAll')<CR>", opts)

vim.filetype.add({ extension = { tsx = "typescriptreact" } })

vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
    end
})

-- <leader> key
vim.g.mapleader = ' '

-- sync system clipboard
vim.opt.clipboard = 'unnamedplus'

-- search ignoring case
vim.opt.ignorecase = true

-- disable "ignorecase" option if the search pattern contains upper case characters
vim.opt.smartcase = true

-- Remap j and k in visual mode to correctly handle folded lines
vim.keymap.set({ 'v' }, 'gj', function()
    require('vscode-neovim').action('cursorMove', {
        args = {
            {
                to = 'down',
                by = 'wrappedLine',
                value = vim.v.count1,
                select = true
            }
        }
    })
    return '<Ignore>'
end, { expr = true, noremap = true })

-- Remap 'k' in visual mode to call the VS Code API
vim.keymap.set({ 'v' }, 'gk', function()
    require('vscode-neovim').action('cursorMove', {
        args = {
            { to = 'up', by = 'wrappedLine', value = vim.v.count1, select = true }
        }
    })
    return '<Ignore>'
end, { expr = true, noremap = true })

-- Map movement to skip over folded lines
-- vim.keymap.set('v', 'j', 'gj', opts)
-- vim.keymap.set('v', 'k', 'gk', opts)
-- ----------------
-- Normal mode
-- vim.cmd('nnoremap j gj')
-- vim.cmd('nnoremap k gk')

-- -- Visual mode
-- vim.cmd('xnoremap j gj')
-- vim.cmd('xnoremap k gk')

-- -- Operator-pending mode (for things like `d`, `c`, `y`, etc.)
-- vim.cmd('onoremap j gj')
-- vim.cmd('onoremap k gk')

if vim.g.vscode then
    local opts = { noremap = true, silent = true }

    local mappings = { -- Word Navigation
        { 'n', 'w',          'cursorWordPartRight' }, { 'n', 'b', 'cursorWordPartLeft' },
        { 'v', 'w',          'cursorWordPartRightSelect' },
        { 'v', 'b',          'cursorWordPartLeftSelect' }, -- Code Navigation
        { 'n', '<leader>gy', 'editor.action.goToTypeDefinition' },
        { 'n', '<leader>gi', 'editor.action.goToImplementation' },
        { 'n', '<leader>gr', 'editor.action.goToReferences' },
        { 'n', '<leader>gs', 'workbench.action.gotoSymbol' },
        { 'n', '<leader>gl', 'workbench.action.gotoLine' }, -- { 'n', '<leader>nf', 'workbench.action.navigateForward' },
        -- { 'n', '<leader>nb', 'workbench.action.navigateBack' },
        -- { 'n', '<leader>je', 'workbench.action.navigateToLastEditLocation' },
        -- Quick Search & Peek Actions
        -- { 'n', '<leader>ss', 'workbench.action.showAllSymbols' },
        -- { 'n', '<leader>sa', 'workbench.action.showCommands' },
        -- { 'n', '<leader>sf', 'workbench.action.quickOpen' },
        { 'n', '<leader>vd', 'editor.action.peekDefinition' },
        { 'n', '<leader>vi', 'editor.action.peekImplementation' },
        { 'n', '<leader>vt', 'editor.action.peekTypeDefinition' }, -- { 'n', '<leader>vh', 'editor.action.showHover' },
        -- { 'n', '<leader>fr', 'references-view.findReferences' },
        -- { 'n', '<leader>sr', 'editor.action.referenceSearch.trigger' },
        -- Line Editing & Code Maintenance
        -- { 'n', '<leader>lu', 'editor.action.copyLinesUpAction' },
        -- { 'n', '<leader>ld', 'editor.action.copyLinesDownAction' },
        -- { 'n', '<leader>mu', 'editor.action.moveLinesUpAction' },
        -- { 'n', '<leader>md', 'editor.action.moveLinesDownAction' },
        -- { 'n', '<leader>fm', 'editor.action.formatDocument' },
        -- { 'n', '<leader>oi', 'editor.action.organizeImports' },
        -- { 'n', '<leader>en', 'editor.action.marker.next' },
        -- { 'n', '<leader>ep', 'editor.action.marker.prev' },
        -- File & Workspace Management
        { 'n', '<leader>cp', 'copyFilePath' },
        { 'n', '<leader>cr', 'copyRelativeFilePath' },
        { 'n', '<leader>rl', 'workbench.action.openRecent' },
        -- { 'n', '<leader>nf', 'workbench.action.files.newUntitledFile' },
        -- { 'n', '<leader>cf', 'workbench.action.closeActiveEditor' },
        -- { 'n', '<leader>fa', 'workbench.action.closeAllEditors' },
        -- { 'n', '<leader>of', 'workbench.action.files.openFile' },
        { 'n', '<leader>rw', 'workbench.action.reloadWindow' },
        { 'n', '<leader>os', 'workbench.action.openSettingsJson' },

        -- Jupyter Notebook handling
        { 'n', '<leader>ec', 'notebook.cell.execute' },
        { 'n', '<leader>cb', 'notebook.cell.insertCodeCellBelow' },
        { 'n', '<leader>ca', 'notebook.cell.insertCodeCellAbove' },
        { 'n', '<leader>co', 'notebook.cell.clearOutputs' },
        { 'n', 'zO',         'editor.unfoldRecursively' },
        { 'n', 'za',         'editor.toggleFold' }, { 'n', 'zR', 'editor.unfoldAll' },
        { 'n', 'zM', 'editor.foldAll' }
    }

    for _, mapping in ipairs(mappings) do
        local mode, key, command = mapping[1], mapping[2], mapping[3]

        vim.keymap.set(mode, key, function() vim.fn.VSCodeNotify(command) end,
            opts)
    end
end
-- ------------------
