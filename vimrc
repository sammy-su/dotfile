call plug#begin('~/.vim/plugged')

Plug 'Valloric/YouCompleteMe'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'majutsushi/tagbar'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'jiangmiao/auto-pairs'
Plug 'bling/vim-airline'
Plug 'Lokaltog/vim-easymotion'
Plug 'kien/ctrlp.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'YankRing.vim'
Plug 'terryma/vim-multiple-cursors'

call plug#end()

nmap <F8> :TagbarToggle<CR>
nmap <F7> :NERDTreeToggle<CR>

" for tab control
nmap <F6> :tab split<CR>
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>

" Resolve conflict between ultisnips and ycp
let g:UltiSnipsExpandTrigger="<c-j>"
" Close definition preview of YCM
autocmd CompleteDone * pclose

" Setting for vim-7.4
syntax on
set backspace=2

" Setting for pep
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent

" Customize
set cindent
" set hlsearch
set incsearch
set cursorline
set nu

set encoding=utf-8
set fileencoding=utf-8

set laststatus=2
set showcmd

