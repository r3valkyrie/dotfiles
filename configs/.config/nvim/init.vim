" Prepare to load plugins
filetype off
set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin()
" Vundle plugins
Plugin 'VundleVim/Vundle.vim'								" Required
Plugin 'valloric/youcompleteme'								" Autocompletion
Plugin 'crucerucalin/peaksea.vim'							" Color scheme

" Vundle plugins end
call vundle#end()
filetype plugin indent on

" General configurations
set termguicolors
set exrc													" Allows project-based configuration.
set secure
set expandtab
set smarttab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab
set colorcolumn=110
set ignorecase
set smartcase
set magic
set foldcolumn=0
syntax enable
set nobackup
set nowb
set noswapfile
set number
colorscheme peaksea
highlight ColorColumn guibg=none

" Remaps
command! W execute 'w !sudo tee % > /dev/null' <bar> edit! " Sudo write

