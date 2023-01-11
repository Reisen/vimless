set autoindent
set expandtab
set fillchars+=diff:╱
"set fillchars+=vert:\ 
set fillchars+=vert:▕
set nowrap
set shiftwidth=4
set signcolumn=yes:1
set smartindent
set softtabstop=4
set tabstop=4
set timeoutlen=1000
let mapleader=" "

" If `splitkeep` is available, set it.
if exists('*splitkeep')
    set splitkeep=screen
endif

" Fix Colours
if !has("gui_running")
    set t_Co=256
endif

" Lua Configuration
lua require('plugins')

" Theme Helper
function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

nnoremap <leader>. :call SynStack()<CR>
