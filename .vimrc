" Plugin manager
call plug#begin()
Plug 'sheerun/vim-polyglot'
Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-commentary'
call plug#end()

" ===========================================================================
" SETTINGS
" ===========================================================================
let mapleader = " "

set number
set relativenumber
set expandtab
set shiftwidth=2
set tabstop=2
set smartindent
set autoread
set clipboard=unnamedplus
set scrolloff=16
set ignorecase
set smartcase
set foldmethod=indent
set foldlevel=99
set hidden
set incsearch
set hlsearch
set wildmenu
set wildmode=longest:full,full
set backspace=indent,eol,start

" Cursor shape: line in insert mode, block in normal mode (tmux-aware)
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" Enable true colors if supported
if has('termguicolors')
  set termguicolors
endif

" Faint grey line numbers
highlight LineNr ctermfg=grey guifg=#5c6370
highlight CursorLineNr ctermfg=grey guifg=#5c6370

" ===========================================================================
" PLUGIN SETTINGS
" ===========================================================================
" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

" NERDTree
let NERDTreeShowHidden = 1
let NERDTreeMinimalUI = 1
let NERDTreeQuitOnOpen = 0

" FZF
let g:fzf_layout = { 'down': '40%' }

" ===========================================================================
" KEYMAPS
" ===========================================================================
" Frequent typo when quitting, remap Q -> q
cnoreabbrev Q q
" Quick close for search highlight
nnoremap <Esc> :nohlsearch<CR>

" Buffer navigation
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>
nnoremap <leader>x :bp \| bd #<CR>
nnoremap <leader><leader> :Buffers<CR>

" FZF keymaps (matching telescope bindings)
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fg :Rg<CR>
nnoremap <leader>fw :Rg <C-R><C-W><CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fr :History<CR>
nnoremap <leader>fh :Helptags<CR>

" File explorer
nnoremap <leader>b :NERDTreeToggle<CR>
nnoremap <leader>o :NERDTreeFocus<CR>
nnoremap <leader>nf :NERDTreeFind<CR>

" Toggle centered cursor
nnoremap <leader>zz :let &scrolloff = &scrolloff == 16 ? 0 : 16<CR>

" ===========================================================================
" AUTO COMMANDS
" ===========================================================================
" Auto-reload files changed outside vim
autocmd FocusGained,BufEnter * checktime

" Auto-save on focus lost
autocmd FocusLost,BufLeave * silent! wall

" Close NERDTree if it's the last window
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
