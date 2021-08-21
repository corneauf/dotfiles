" Turn on syntax coloring
syntax on


set termguicolors
set colorcolumn=100
set background=dark
set scrolloff=999
set virtualedit=block
colorscheme azuki

" Number of spaces for one tab
set tabstop=4
set shiftwidth=4
"Use spaces for a tab
set expandtab

set autoindent
set nu
set rnu
set ruler


" Plugins
" Vundle stuff
set nocompatible              " be iMproved, required
filetype off                  " required
set rtp+=~/.config/nvim/bundle/Vundle.vim

call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'machakann/vim-sandwich'
Plugin 'Raimondi/delimitMate'
Plugin 'vim-airline/vim-airline'
Plugin 'preservim/nerdtree'
" Open Tagbar
nmap <F8> :TagbarToggle<CR>

call vundle#end()

filetype plugin indent on

" set Vim-specific sequences for RGB colors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" air-line settings
let g:airline_powerline_fonts=1

" NERDTree settings
let NERDTreeQuitOnOpen=1

" Keybindings
" Change tabs keymaps
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
nnoremap <silent> <A-Left> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> <A-Right> :execute 'silent! tabmove ' . (tabpagenr()+1)<CR>
nnoremap <silent> <A-q> :execute 'silent! tabclose'<CR>
nnoremap <silent> <A-g> :execute 'silent! tabnew'<CR>

" Open NERDTree Alt + e
map <A-e> :NERDTreeToggle<CR>

" Toggle relative line numbers when entering/leaving insert mode
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

" vim sandwhich recipes
nmap s <Nop>
xmap s <Nop>
let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)

" Indent uses of {}
let g:sandwich#recipes += [
      \   {
      \     'buns'        : ['{', '}'],
      \     'motionwise'  : ['line'],
      \     'kind'        : ['add'],
      \     'linewise'    : 1,
      \     'command'     : ["'[+1,']-1normal! >>"],
      \   },
      \   {
      \     'buns'        : ['{', '}'],
      \     'motionwise'  : ['line'],
      \     'kind'        : ['delete'],
      \     'linewise'    : 1,
      \     'command'     : ["'[,']normal! <<"],
      \   }
      \ ]

" Indent surrounded text when using HTML tags to surround it
let g:sandwich#recipes += [
      \   {
      \     'buns'        : 'HTMLTagInput()',
      \     'listexpr'    : 1,
      \     'filetype'    : ['html'],
      \     'action'      : ['add'],
      \     'input'       : ['t'],
      \     'command'     : ["'[+1,']-1normal! >>"],
      \   },
      \ ]

function! HTMLTagInput() abort
    let tagstring = input('Tag: ')
    if tagstring ==# ''
        throw 'OperatorSandwichCancel'
    endif
    let former = printf('<%s>', tagstring)
    let latter = printf('</%s>',
                        \ matchstr(tagstring, '^\a[^[:blank:]>/]*'))
    return [former, latter]
endfunction


" Start of autocommands
:autocmd BufWritePost *.py !black <afile>
:autocmd BufWritePost *.py edit
:autocmd BufWritePost *.py redraw!
