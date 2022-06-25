set autoindent
set expandtab
set shiftwidth=4
set smartindent
set softtabstop=4
set tabstop=4
set nowrap
set timeoutlen=1000
set signcolumn=auto:4
set fillchars+=diff:╱
let mapleader=" "

" Fix Colours
if !has("gui_running")
    set t_Co=256
endif

" Lua Configuration
lua require('plugins')

