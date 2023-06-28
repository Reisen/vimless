" Set some reasonable defaults for a clean UI.
" ------------------------------------------------------------------------------
set background=dark         " use light background
set shell=/bin/bash         " use bash as the shell
set autoindent              " copy indent from current line when starting a new line
set ignorecase              " ignore case when searching
set smartcase               " ignore case when lowercase, match case when uppercase
set expandtab               " use spaces instead of tabs
set nonumber                " don't show line numbers
set fillchars+=diff:╱       " use a different character for diff mode
set fillchars+=vert:\       " use a different character for vertical splits
set fillchars+=stl:\        " don't fill status lines with ^ chars
set fillchars+=stlnc:\      " don't fill status lines with ^ chars
set nowrap                  " don't wrap lines
set shiftwidth=4            " number of spaces to use for autoindent by default
set signcolumn=yes:1        " always show the sign column to avoid visual moving around
set smartindent             " smarter indentation for C-like languages
set softtabstop=4           " number of spaces to use for tab
set tabstop=4               " number of spaces that a <Tab> in the file counts for
set timeoutlen=1000         " time in milliseconds to wait for a mapped sequence to complete
set laststatus=2            " don't show status line in inactive windows
let mapleader=" "           " set the leader key to <Space>
set winbar=\ \ %3n\ %f      " set the winbar format (note navic appends to this)
set splitkeep=screen        " prevent vertical shifting when horizontal splitting

" Keep the status line but make it unobtrusive, show only the right aligned cursor position.
set statusline=%=%{line('.')}\:%{col('.')}

" Smarter Macros
"
" - Press Q to start recording into the q register.
" - Press q to stop recording.
" - Select lines with visual mode.
" - Press Q to apply the macro line-wise to the selected lines.
nnoremap Q @q
vnoremap Q :normal @q<CR>

" When in a terminal, we likely want the 256 color palette. The default theme
" used in this configuration is base16 which also tries to overwrite colours
" above 16 so this is important for any rich theming in a terminal. Note that
" we don't set `termguicolors` here because it causes themes to try and set
" colours instead of using the palette, so this should be opt-in by users on
" their own accord.
if !has("gui_running")
    set t_Co=256
    let base16colorspace=256
endif

" Finally, run our Lua based configuration for Neovim.
lua require('plugins')

" Helper function to discover the syntax groups for the element under the
" cursor. This is useful for debugging syntax highlighting.
function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

nnoremap <leader>. :call SynStack()<CR>

" Save current view settings on a per-window, per-buffer basis. This helps vim
" restore windows in the right position when jumping back and forth.
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

" Check if custom.vim exists in the same directory as this file. Note that we
" can't use ~/.vimrc.d, ~/.config/nvim, or ~/.config/nvim/init.vim because we
" do not know what their XDG settings are.
if filereadable(expand("<sfile>:p:h") . "/custom.vim")
    execute "source " . expand("<sfile>:p:h") . "/custom.vim"
endif
