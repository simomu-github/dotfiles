set nocompatible
filetype plugin indent off

if has('vim_starting')
 set runtimepath+=~/.vim/bundle/neobundle.vim
 "call neobundle#rc(expand('~/.vim/bundle'))
 call neobundle#begin(expand('~/.vim/bundle/'))
 NeoBundleFetch 'Shougo/neobundle.vim'
 call neobundle#end()
endif

call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'tomasiser/vim-code-dark'
NeoBundle 'TwitVim'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'h1mesuke/unite-outline'
NeoBundle 'editorconfig/editorconfig-vim'
NeoBundle "ctrlpvim/ctrlp.vim"
NeoBundle 'cohama/lexima.vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'fatih/vim-go'
NeoBundle 'jparise/vim-graphql'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'leafgarland/typescript-vim'
NeoBundle 'prabirshrestha/vim-lsp'
NeoBundle 'mattn/vim-lsp-settings'
call neobundle#end()

filetype plugin indent on
