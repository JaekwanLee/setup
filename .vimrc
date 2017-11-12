" vundle {{{1

" needed to run vundle (but i want this anyways)
set nocompatible
set number

set smartindent
set tabstop=2
set shiftwidth=2
set expandtab

" Auto brakets "
inoremap {<cr> {<cr>}<c-o><s-o>
inoremap [<cr> {<cr>]<c-o><s-o>
inoremap (<cr> {<cr>)<c-o><s-o>

set hlsearch "Highlight search things
set incsearch "Make search act like search in modern browsers

vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>
" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSearch('gv')<CR>
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>

" From an idea by Michael Naumann
function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


" vundle needs filtype plugins off
" i turn it on later
filetype plugin indent off
syntax off

" set the runtime path for vundle
set rtp+=~/.vim/bundle/Vundle.vim

" start vundle environment
call vundle#begin()

" list of plugins {{{2
" let Vundle manage Vundle (this is required)
"old: Plugin 'gmarik/Vundle.vim'
Plugin 'VundleVim/Vundle.vim'

" to install a plugin add it here and run :PluginInstall.
" to update the plugins run :PluginInstall! or :PluginUpdate
" to delete a plugin remove it here and run :PluginClean
" 

" YOUR LIST OF PLUGINS GOES HERE LIKE THIS:
Plugin 'bling/vim-airline'
" .ts "
Plugin 'leafgarland/typescript-vim'
" .vue "
Plugin 'posva/vim-vue'
" colorscheme "
Plugin 'sjl/badwolf'
" git wrapper "
Plugin 'tpope/vim-fugitive'
" tree "
Plugin 'scrooloose/nerdtree'
" syntax checker "
Plugin 'scrooloose/syntastic'

" add plugins before this
call vundle#end()

" now (after vundle finished) it is save to turn filetype plugins on
filetype plugin indent on
syntax on
