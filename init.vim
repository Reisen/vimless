set autoindent
set expandtab
set nonumber
set fillchars+=diff:╱
set fillchars+=vert:\ 
" set fillchars+=diff:⋅
" set fillchars+=vert:▕

set nowrap
set shiftwidth=4
set signcolumn=yes:1
set smartindent
set softtabstop=4
set tabstop=4
set timeoutlen=1000
set laststatus=0
let mapleader=" "

" Status Line as Buffer Number, Space, Filename. The Buffer Number is right
" aligned and assumed to be 3 digits. Center the whole thing.
set winbar=\ \ %3n\ %f
set winbar+=\ \ %{%v:lua.require'nvim-navic'.get_location()%}
set statusline=\ 

" Check if `splitkeep` option exists.
set splitkeep=screen

" Fix Colours
if !has("gui_running")
    set t_Co=256
    let base16colorspace=256
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

" Save current view settings on a per-window, per-buffer basis.
function! AutoSaveWinView()
    if !exists("w:SavedBufView")
        let w:SavedBufView = {}
    endif
    let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction

" Restore current view settings.
function! AutoRestoreWinView()
    let buf = bufnr("%")
    if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
        let v = winsaveview()
        let atStartOfFile = v.lnum == 1 && v.col == 0
        if atStartOfFile && !&diff
            call winrestview(w:SavedBufView[buf])
        endif
        unlet w:SavedBufView[buf]
    endif
endfunction

" When switching buffers, preserve window view.
if v:version >= 700
    autocmd BufLeave * call AutoSaveWinView()
    autocmd BufEnter * call AutoRestoreWinView()
endif
