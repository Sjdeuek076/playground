set nocompatible
"set t_Co=16
set runtimepath=~/Vim-R-plugin,~/.vim,$VIMRUNTIME,~/.vim/after
execute pathogen#infect()
filetype plugin on
"filetype indent plugin on
syntax enable
set number
set showmatch "DoMatchParen  "highlight matching parenthesis
set splitbelow
set splitright
" set mouse=a

"""""""""""""indent setting"""""""""""""""""""""""
"filetype plugin indent on
filetype indent plugin on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

"""""""""""""map function keys for cpp"""""""""""""
map <F8> :!g++ -g  % && ./a.out <CR>  " compile and run
map <F5> :!g++ -g % <CR>	      " compile only
map <F2> :w <CR>   		      " write file	
map <F12> :!gdb ./a.out <CR>	      " gdb for debugging 	


""""""""""""cpp11 as default""""""""""""""""""""""
au BufNewFile,BufRead *.cpp set syntax=cpp11
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'

""""""""""""vim-go setting""""""""""""""""""""""""
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_fmt_command = "goimports"
let mapleader=","
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
au FileType go nmap <Leader>s <Plug>(go-implements)
au FileType go nmap <Leader>i <Plug>(go-info)
""""""""""""vim-go setting end""""""""""""""""""""""""
" Disable sounds
"set noeb vb t_vb=
"au GUIEnter * set vb t_vb=
set noerrorbells visualbell t_vb=
if has('autocmd')
     autocmd GUIEnter * set visualbell t_vb=
  endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" powerlines setting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set  rtp+=/home/adley/.local/lib/python2.7/site-packages/powerline/bindings/vim/
set laststatus=2
set t_Co=256

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" User interface setings -- GVIM
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
 set showmatch                        " Show matching braces when over one
 set ruler                            " Always show current position
 set number                           " Always show line-numbers
 set numberwidth=5                    " Line-number margin width
 set mousehide                        " Do not show mouse while typing
 set antialias                        " Pretty fonts
 set t_Co=256                         " 256-color palletes
 set background=dark                  " Dark background variation of theme
 set guifont=Inconsolata\ Medium\ 10  " Monospaced small font
 set guioptions-=T                    " TODO
 set guioptions+=c                    " TODO Console messages
 set linespace=0                      " Don't insert any extra pixel lines
 set lazyredraw                       " Don't redraw while running macros
 set wildmenu                         " Wild menu
 set wildmode=longest,list,full       " Wild menu options
 set fillchars+=vert:\                "
"
" " Display special characters and helpers
 set list
" " Show < or > when characters are not displayed on the left or right.
" " Also show tabs and trailing spaces.
 set list listchars=nbsp:¬,tab:>-,trail:.,precedes:<,extends:>
"
" " Autocompletion
 set ofu=syntaxcomplete#Complete
 set completeopt+=longest,menuone
 "highlight Pmenu guibg=brown gui=bold
  highlight Pmenu ctermfg=15 ctermbg=0 guifg=#ffffff guibg=#000000
 let g:SuperTabDefaultCompletionType = "<C-x><C-o>"

"
" " Statusline
 set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
" "              | | | | |  |   |      |  |     |    |
" "              | | | | |  |   |      |  |     |    + current
" "              | | | | |  |   |      |  |     |       column
" "              | | | | |  |   |      |  |     +-- current line
" "              | | | | |  |   |      |  +-- current % into file
" "              | | | | |  |   |      +-- current syntax in
" "              | | | | |  |   |          square brackets
" "              | | | | |  |   +-- current fileformat
" "              | | | | |  +-- number of lines
" "              | | | | +-- preview flag in square brackets
" "              | | | +-- help flag in square brackets
" "              | | +-- readonly flag in square brackets
" "              | +-- rodified flag in square brackets
" "              +-- full path to file in the buffer
"

" Highlight trailing whitespaces (+ keybindings below)
 highlight ExtraWhitespace ctermbg=red guibg=red
 highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
 ""au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
 ""au InsertLeave * match ExtraWhitespace /\s\+$/.

syntax on
 colorscheme kolor "relaxedgreen "vimbrant distinguished onedark greentheme distinguished  Tomorrow murphy 

""""""""""""""""Vundle configure""""""""""""""""""""""""""""
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
 set rtp+=~/.vim/bundle/Vundle.vim
 call vundle#begin()
" " alternatively, pass a path where Vundle should install plugins
" "call vundle#begin('~/some/path/here')
"
" " let Vundle manage Vundle, required
 Plugin 'gmarik/Vundle.vim'
"
" " The following are examples of different formats supported.
" " Keep Plugin commands between vundle#begin/end.
" " plugin on GitHub repo
 Plugin 'tpope/vim-fugitive'
" " plugin from http://vim-scripts.org/vim/scripts.html
" " Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" " git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" " The sparkup vim script is in a subdirectory of this repo called vim.
" " Pass the path to set the runtimepath properly.
 Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" " Avoid a name conflict with L9
 Plugin 'fatih/vim-go'
 Plugin 'Valloric/YouCompleteMe'
 Plugin 'scrooloose/nerdtree'
 Plugin 'https://github.com/orderthruchaos/tabmove.vim.git'
 Plugin 'christoomey/vim-tmux-navigator'
"
" " All of your Plugins must be added before the following line
 call vundle#end()            " required
 filetype plugin indent on    " required
" " To ignore plugin indent changes, instead use:
" "filetype plugin on
" "
" " Brief help
" " :PluginList          - list configured plugins
" " :PluginInstall(!)    - install (update) plugins
" " :PluginSearch(!) foo - search (or refresh cache first) for foo
" " :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
" "
" " see :h vundle for more details or wiki for FAQ
" " Put your non-Plugin stuff after this line

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"vim-tmux_navigator key bindings
let g:tmux_navigator_no_mappings = 1

nnoremap <silent> {Left-mapping} :TmuxNavigateLeft<cr>
nnoremap <silent> {Down-Mapping} :TmuxNavigateDown<cr>
nnoremap <silent> {Up-Mapping} :TmuxNavigateUp<cr>
nnoremap <silent> {Right-Mapping} :TmuxNavigateRight<cr>
nnoremap <silent> {Previoust-Mapping} :TmuxNavigatePrevious<cr>
