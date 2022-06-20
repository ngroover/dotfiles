vim.api.nvim_set_keymap('n', ':', ';', {noremap = true})
vim.api.nvim_set_keymap('n', ';', ':', {noremap = true})
vim.api.nvim_command('set scrolloff=5')
vim.api.nvim_command('set nu')
vim.api.nvim_command('set rnu')
vim.api.nvim_command('set ts=4 sw=4 expandtab')
vim.api.nvim_command('nnoremap <Leader>e :e $MYVIMRC<CR>')
vim.api.nvim_command('nnoremap <Leader>r :so $MYVIMRC<CR>')
vim.api.nvim_command('nnoremap <Leader>t :tabnew<CR>')

-- Vimspector
vim.api.nvim_command('nmap <Leader>5 <Plug>VimspectorContinue')
vim.api.nvim_command('nmap <Leader>d <Plug>VimspectorLaunch')
vim.api.nvim_command('nmap <Leader>3 <Plug>VimspectorStop')
vim.api.nvim_command('nmap <Leader>4 <Plug>VimspectorRestart')
vim.api.nvim_command('nmap <Leader>6 <Plug>VimspectorPause')
vim.api.nvim_command('nmap <Leader>9 <Plug>VimspectorToggleBreakpoint')
--vim.api.nvim_command('nmap <leader><F9> <Plug>VimspectorToggleConditionalBreakpoint')
vim.api.nvim_command('nmap <Leader>8 <Plug>VimspectorAddFunctionBreakpoint')
vim.api.nvim_command('nmap <leader>c <Plug>VimspectorRunToCursor')
vim.api.nvim_command('nmap <Leader>0 <Plug>VimspectorStepOver')
vim.api.nvim_command('nmap <Leader>1 <Plug>VimspectorStepInto')
vim.api.nvim_command('nmap <Leader>2 <Plug>VimspectorStepOut')
vim.api.nvim_command('nmap <Leader>h <Plug>VimspectorBalloonEval')
vim.api.nvim_command('nmap <Leader>b <Plug>VimspectorBreakpoints')


--vim.api.nvim_command('colorscheme delek')
vim.api.nvim_command('set nobackup')
local opt = vim.opt
opt.wrap = false
vim.api.nvim_command('set noincsearch')
vim.api.nvim_command('set listchars=tab:>-,trail:-')
vim.api.nvim_command('set list')

-- Plugins
local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.config/nvim/plugged')
Plug 'neovim/nvim-lspconfig'
Plug 'puremourning/vimspector'
Plug 'ellisonleao/gruvbox.nvim'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
vim.call('plug#end')
vim.api.nvim_command('colorscheme gruvbox')

local on_attach = function(client,buffer)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(buffer, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(buffer, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
    buf_set_option('formatexpr', 'v:lua.vim.lsp.formatexpr()')
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', {noremap = true})
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true})
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', {noremap = true})
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true})
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', {noremap = true})
    buf_set_keymap('n', '<space>td', '<cmd>lua vim.lsp.buf.type_definition()<CR>', {noremap = true})
end
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
require'lspconfig'.pyright.setup{on_attach=on_attach,capabilities=capabilities}

-- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
snippet = {
  -- REQUIRED - you must specify a snippet engine
  expand = function(args)
    --vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
    -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
  end,
},
completion = {
    keyword_length=3
},
window = {
  -- completion = cmp.config.window.bordered(),
  -- documentation = cmp.config.window.bordered(),
},
mapping = cmp.mapping.preset.insert({
  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  ['<C-f>'] = cmp.mapping.scroll_docs(4),
  ['<C-Space>'] = cmp.mapping.complete(),
  ['<C-e>'] = cmp.mapping.abort(),
  ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
}),
experimental = {
    ghost_text = true
},
sources = cmp.config.sources({
  { name = 'nvim_lsp' },
  { name = 'path' },
  --{ name = 'vsnip' }, -- For vsnip users.
   { name = 'luasnip' }, -- For luasnip users.
  -- { name = 'ultisnips' }, -- For ultisnips users.
  -- { name = 'snippy' }, -- For snippy users.
}, {
  { name = 'buffer' },
})
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
sources = cmp.config.sources({
  { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
}, {
  { name = 'buffer' },
})
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
mapping = cmp.mapping.preset.cmdline(),
sources = {
  { name = 'buffer' }
}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
mapping = cmp.mapping.preset.cmdline(),
sources = cmp.config.sources({
  { name = 'path' }
}, {
  { name = 'cmdline' }
})
})

