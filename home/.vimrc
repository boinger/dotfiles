if has("syntax")
  syntax on
endif

set nocompatible

set autoindent
"set autowrite
set background=dark
set backspace=indent,eol,start
"set backspace=2
set backup
set backupdir=~/.vim/backup
set backupext=old
set directory=~/.vim/tmp
" no c-style indents
set nocindent
set cmdheight=2
set comments=b:#,b:\",n:>
set formatoptions-=t
set hid
set history=1024
set hlsearch
set incsearch
set ignorecase
"set magic
set number
set relativenumber
set pastetoggle=<F9>
set ruler
set scrolloff=10 " guaranteed context lines
set showcmd
set showmatch
set showmode
set smartcase
set title
set undolevels=128
set viminfo=/10,'10,r/mnt/zip,r/mnt/floppy,f0,h,\"100
set whichwrap+=<,>,h,l
set wildmode=list:longest,full

"" Tab style:
set expandtab
set list
set listchars=tab:>-
set shiftround
set shiftwidth=2
set smarttab
set softtabstop=2
set tabstop=2

set t_Co=256

noremap <F4> <ESC>:set norelativenumber<CR>
noremap <F5> <ESC>:set relativenumber<CR>
noremap <F6> <ESC>:set nonumber<CR>
noremap <F7> <ESC>:set number<CR>

noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

" junk whitespace highlight
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" file type settings
filetype on
filetype plugin on
autocmd BufNewFile,BufRead,BufEnter Capfile set ft=ruby
autocmd FileType make set noet sts=8 sw=8
autocmd BufNewFile,BufRead,BufEnter *.json set ft=json
autocmd FileType json set sts=3 sw=3

" mappings
map ,r :set syntax=ruby<CR>
map ,m :noh<CR>
map ,n :noh<CR>
map ,p :set invpaste paste?<CR>
map ,2 :set et sts=2 sw=2<CR>
map ,4 :set et sts=4 sw=4<CR>
map ,t :set noet sts=8 sw=8 nolist<CR>

" more intelligent moving around between functions
:map [[ :let @z=@/<CR>?{<CR>w99[{:let @/=@z<CR>
:map ][ :let @z=@/<CR>/}<CR>b99]}:let @/=@z<CR>
:map ]] :let @z=@/<CR>j0[[%/{<CR>:let @/=@z<CR>
:map [] :let @z=@/<CR>k$][%?}<CR>:let @/=@z<CR>

" reformat current paragraph
:nmap Q gqap
" reformat current selection
:vmap Q gq

" substitute these typos for what I DWIM'd
cabbrev Wq wq

" add nifty macros
ab ubb #!/bin/bash
ab ubp #!/usr/bin/perl

" this puts our search term in the middle of the screen
nmap n nmzz.`z
nmap N Nmzz.`z
nmap * *mzz.`z
nmap # #mzz.`z
nmap g* g*mzz.`z
nmap g# g#mzz.`z

" Set title string and push it to xterm/screen window title
set titlestring=vim\ %<%F%(\ %)%m%h%w%=%l/%L-%P
set titlelen=40
if &term == "screen" || &term == "screen-256color"
  set t_ts=k
  set t_fs=\
endif
if &term == "screen" || &term == "xterm" || &term == "screen-256color"
  set title
endif
