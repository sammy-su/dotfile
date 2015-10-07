call plug#begin('~/.vim/plugged')

Plug 'Valloric/YouCompleteMe'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'scrooloose/nerdcommenter'
Plug 'majutsushi/tagbar'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'jiangmiao/auto-pairs'
Plug 'bling/vim-airline'
Plug 'Lokaltog/vim-easymotion'
Plug 'kien/ctrlp.vim'
Plug 'YankRing.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'mkitt/tabline.vim'
Plug 'tpope/vim-surround'
Plug 'sjl/gundo.vim'

call plug#end()

nmap <F8> :TagbarToggle<CR>
nmap <F7> :NERDTreeToggle<CR>
nmap <F6> :GundoToggle<CR>

" Resolve conflict between ultisnips and ycp
let g:UltiSnipsExpandTrigger="<c-j>"
" Close definition preview of YCM
autocmd CompleteDone * pclose
let g:ycm_global_ycm_extra_conf = '~/.vim/plugged/YouCompleteMe/ycm_extra_conf.py'

" YankRing key mapping
let g:yankring_replace_n_pkey = '<s-p>'
let g:yankring_replace_n_nkey = '<s-n>'

" airline setting
let g:airline_section_y = ''
set laststatus=2
set showcmd

" Setting for vim-7.4
syntax on
set backspace=indent,eol,start

" Setting for pep
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent

" Customize
set incsearch
set cursorline
set nu
set ignorecase
set smartcase

set encoding=utf-8
set fileencoding=utf-8

filetype plugin on

let g:tex_flavor="latex"

