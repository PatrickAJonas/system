call plug#begin('~/.local/share/nvim/plugged')

Plug 'altercation/Vim-colors-solarized'
"Plug 'valloric/YouCompleteMe'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"Plug 'rust-lang/rust.vim'
"Plug 'idris-hackers/idris-vim'
Plug 'vim-syntastic/syntastic'
"Plug 'vim-pandoc/vim-pandoc'
"Plug 'vim-pandoc/vim-pandoc-syntax'
"Plug 'sjl/gundo.vim'
Plug 'LnL7/vim-nix'
call plug#end()

set termguicolors
colorscheme solarized
set background=dark
set undofile

syntax enable
set number " Line numbers
set hidden
set textwidth=80
set smartindent
set noexpandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set clipboard=unnamed
set clipboard=unnamedplus

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0


" move vertically by visual line
nnoremap j gj
nnoremap k gk

nnoremap <S-j> :prev<CR>
nnoremap <S-k> :n<CR>


filetype plugin indent on

"let mapleader=" "
"nnoremap <leader>u :GundoToggle<CR>

"map <F4> :RustRun<CR>

"let g:racer_cmd = "$HOME/.cargo/bin/racer/target/release/racer"
"let $RUST_SRC_PATH="/usr/local/src/rust/src/"

imap jj <esc>

set wrap
set linebreak
set nolist
set wrapmargin=0
set textwidth=0
set wildmenu
set lazyredraw
set showmatch
set incsearch
set hlsearch
set foldenable
set foldlevelstart=10
set foldnestmax=10

