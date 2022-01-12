" setting
"文字コードをUFT-8に設定
set fenc=utf-8
" バックアップファイルを作らない
set nobackup
" スワップファイルを作らない
set noswapfile
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" バッファが編集中でもその他のファイルを開けるように
set hidden
" 入力中のコマンドをステータスに表示する
set showcmd

" paste modeの自動化
if &term =~ "xterm"
    let &t_ti .= "\e[?2004h"
    let &t_te .= "\e[?2004l"
    let &pastetoggle = "\e[201~"

    function XTermPasteBegin(ret)
        set paste
        return a:ret
    endfunction

    noremap <special> <expr> <Esc>[200~ XTermPasteBegin("0i")
    inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
    cnoremap <special> <Esc>[200~ <nop>
    cnoremap <special> <Esc>[201~ <nop>
endif

" 見た目系
" 行番号を表示
set number
" 現在の行を強調表示
set cursorline
" 現在の行を強調表示（縦）
"set cursorcolumn
" 行末の1文字先までカーソルを移動できるように
set virtualedit+=onemore
" 矩形選択をブロック状に
set virtualedit+=block
" インデントはスマートインデント
set smartindent
" ビープ音を可視化
set visualbell
" 括弧入力時の対応する括弧を表示
set showmatch
" ステータスラインを常に表示
set laststatus=2
" コマンドラインの補完
set wildmode=list:longest
" 折り返し時に表示行単位での移動できるようにする
nnoremap j gj
nnoremap k gk
" 行頭、行尾移動
nnoremap <S-h> ^
nnoremap <S-l> $l

"コメント色変更
hi Comment ctermfg=lightgreen

" タブ番号の表示
function! s:SID_PREFIX()
    return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

function! s:my_tabline()  "{{{
    let s = ''
        for i in range(1, tabpagenr('$'))
            let bufnrs = tabpagebuflist(i)
            let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
            let no = i  " display 0-origin tabpagenr.
            let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
            let title = fnamemodify(bufname(bufnr), ':t')
            let title = '[' . title . ']'
            let s .= '%'.i.'T'
            let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
            let s .= no . ':' . title
            let s .= mod
            let s .= '%#TabLineFill# '
        endfor
        let s .= '%#TabLineFill#%T%=%#TabLine#'
        return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'

" Tab系
" 不可視文字を可視化(タブが「▸-」と表示される)
set list listchars=tab:\▸\-
" Tab文字を半角スペースにする
set expandtab
" 行頭以外のTab文字の表示幅（スペースいくつ分）
set tabstop=2
" 行頭でのTab文字の表示幅
set shiftwidth=2


" 検索系
" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch
" 検索時に最後まで行ったら最初に戻る
set wrapscan
" 検索語をハイライト表示
set hlsearch
" ESC連打でハイライト解除
nmap <Esc><Esc> :nohlsearch<CR><Esc>


"エイリアス系
command Rt RefreshTwitter
command RiG ListTwitter RiG
command Nt NERDTree
command Nf NERDTreeFind
command Nc NERDTreeClose

" キーマップ系
noremap <Space>nn :NERDTreeToggle<CR>
noremap <Space>nt :NERDTree<CR>
noremap <Space>nf :NERDTreeFind<CR>
noremap <Space>nc :NERDTreeClone<CR>
noremap <Space>rt :RefreshTwitter<CR>
noremap <Space>tw :FriendsTwitter<CR><C-w>k<C-w>_
noremap <Space>tn :NextTwitter<CR>
noremap <Space>lt :ListTwitter<Space>
noremap <Space>l1 :ListTwitter<Space>list<CR>
noremap <Space>l2 :ListTwitter<Space>RiG<CR>
noremap <Space>l3 :ListTwitter<Space>人<CR>
noremap <Space>ut :UserTwitter<Space>
noremap <Space>rp :RepliesTwitter<CR>
noremap <Space>tt :tabnew<CR>
noremap <Space>tc :tabc<CR>
noremap <Space>to :tabo<CR>
noremap gn :tabn
noremap gl :ls<CR>:b<Space>
noremap <C-f> /
noremap <C-h> :%s/
inoremap <C-@> <C-p>
noremap <Space>c :colorscheme<Space>
noremap <Space>sh :term<CR>
noremap <Space>vs <C-w>v<C-w>l:terminal<Space>++curwin<CR>
noremap <Space><Tab> :set<Space>expandtab!<CR>
noremap <Space>bm :%!xxd<Space>-g1<CR>
noremap <Space>br :%!xxd<Space>-r<CR>
noremap <Space>ft :set filetype=
nnoremap s <Nop>
nnoremap sp :CtrlPCurWD<CR>

" clanf-formatの自動化
function! ClangFormat()
  let now_line = line(".")
  exec ":%! clang-format"
  exec ":" . now_line
endfunction

if executable('clang-format')
  augroup cpp_clang_format
    autocmd!
    autocmd BufWrite,FileWritePre,FileAppendPre *.cpp call ClangFormat()
    autocmd BufWrite,FileWritePre,FileAppendPre *.h call ClangFormat()
  augroup END
endif

" プラグイン系
" 以下を追記
set nocompatible
filetype plugin indent off

if has('vim_starting')
 set runtimepath+=~/.vim/bundle/neobundle.vim
 "call neobundle#rc(expand('~/.vim/bundle'))
 call neobundle#begin(expand('~/.vim/bundle/'))
 NeoBundleFetch 'Shougo/neobundle.vim'
 call neobundle#end()
endif

" 以下は必要に応じて追加
call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'nanotech/jellybeans.vim'
NeoBundle 'tomasr/molokai'
NeoBundle 'tomasiser/vim-code-dark'
NeoBundle 'TwitVim'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'basyura/TweetVim'
NeoBundle 'mattn/webapi-vim'
NeoBundle 'basyura/twibill.vim'
NeoBundle 'tyru/open-browser.vim'
NeoBundle 'h1mesuke/unite-outline'
NeoBundle 'basyura/bitly.vim'
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
call neobundle#end()

filetype plugin indent on

" colorscheme jellybeans
colorscheme codedark
" colorscheme molokai
let twitvim_browser_cmd = 'google-chrome'
let twitvim_count = 40

let NERDTreeShowHidden=1

" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
  endif

let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste'  ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified'  ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }

function! SetCustomHilight()
    hi Search ctermbg=DarkGreen
    hi IncSearch ctermbg=DarkGreen
endfunction

call SetCustomHilight()

" キャッシュを終了時に削除しない
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_max_files = 100000
let g:ctrlp_max_depth = 10

" gitgutterまわりの設定
set updatetime=250
highlight GitGutterAdd ctermfg=green
highlight GitGutterChange ctermfg=yellow
highlight GitGutterDelete ctermfg=red

" jsonファイルのダブルクォーテーションを表示する
set conceallevel=0
let g:vim_json_syntax_conceal = 0

" 入力中のコマンドをステータスに表示する
set showcmd
