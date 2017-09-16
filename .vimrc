set nocompatible
set t_Co=16
set runtimepath=~/Vim-R-plugin,~/.vim,$VIMRUNTIME,~/.vim/after
execute pathogen#infect()
filetype plugin on
filetype indent plugin on
syntax enable
set number
set mouse=a
""""""""""""vim-go setting""""""""""""""""""""""""
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_fmt_command = "goimports"
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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" User interface setings
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
syntax on
 colorscheme greentheme  "murphy     "Tomorrow 


 set showmatch                        " Show matching braces when over one
 set ruler                            " Always show current position
 set number                           " Always show line-numbers
 set numberwidth=5                    " Line-number margin width
 set mousehide                        " Do not show mouse while typing
 set antialias                        " Pretty fonts
 set t_Co=256                         " 256-color palletes
 set background=dark                  " Dark background variation of theme
 set guifont=Andale\ Mono\ 11         " Monospaced small font
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
 au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
 au InsertLeave * match ExtraWhitespace /\s\+$/.

 """"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" sample settings for vim-r-plugin and screen.vim
" Installation 
"       - Place plugin file under ~/.vim/
"       - To activate help, type in vim :helptags ~/.vim/doc
"       - Place the following vim conf lines in .vimrc
" Usage
"       - Read intro/help in vim with :h vim-r-plugin or :h screen.txt
"       - To initialize vim/R session, start screen/tmux, open some *.R file in vim and then hit F2 key
"       - Object/omni completion command CTRL-X CTRL-O
"       - To update object list for omni completion, run :RUpdateObjList
" My favorite Vim/R window arrangement 
"	tmux attach
"	Open *.R file in Vim and hit F2 to open R
"	Go to R pane and create another pane with C-a %
"	Open second R session in new pane
"	Go to vim pane and open a new viewport with :split *.R
" Useful tmux commands
"       tmux new -s <myname>       start new session with a specific name
"	tmux ls (C-a-s)            list tmux session
"       tmux attach -t <id>        attach to specific session  
"       tmux kill-session -t <id>  kill specific session
" 	C-a-: kill-session         kill a session
" 	C-a %                      split pane vertically
"       C-a "                      split pane horizontally
" 	C-a-o                      jump cursor to next pane
"	C-a C-o                    swap panes
" 	C-a-: resize-pane -L 10    resizes pane by 10 to left (L R U D)
" Corresponding Vim commands
" 	:split or :vsplit      split viewport
" 	C-w-w                  jump cursor to next pane-
" 	C-w-r                  swap viewports
" 	C-w C-++               resize viewports to equal split
" 	C-w 10+                increase size of current pane by value

" To open R in terminal rather than RGui (only necessary on OS X)
" let vimrplugin_applescript = 0
" let vimrplugin_screenplugin = 0
" For tmux support
let g:ScreenImpl = 'Tmux'
let vimrplugin_screenvsplit = 1 " For vertical tmux split
let g:ScreenShellInitialFocus = 'shell' 
" instruct to use your own .screenrc file
let g:vimrplugin_noscreenrc = 1
" For integration of r-plugin with screen.vim
let g:vimrplugin_screenplugin = 1
" Don't use conque shell if installed
let vimrplugin_conqueplugin = 0
" map the letter 'r' to send visually selected lines to R 
let g:vimrplugin_map_r = 1
" see R documentation in a Vim buffer
let vimrplugin_vimpager = "no"
let vimrplugin_applescript =0
let vimrplugin_screenplugin =0 
"set expandtab
set shiftwidth=4
set tabstop=8
" start R with F2 key
map <F2> <Plug>RStart 
imap <F2> <Plug>RStart
vmap <F2> <Plug>RStart
" send selection to R with space bar
vmap <Space> <Plug>RDSendSelection 
" send line to R with space bar
nmap <Space> <Plug>RDSendLine

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-powerline setting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup
set laststatus=2 " Always display the statusline in all windows
set showtabline=2 " Always display the tabline, even if there is only one tab
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)
set t_Co=256


