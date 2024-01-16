" load plugins
source ~/dotfiles/vim_plugins.vim

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
set backspace=indent,eol,start

" F10 で paste モードをトグルする
set pastetoggle=<F10>

" 見た目系
" 行番号を表示
set number
" 現在の行を強調表示
set cursorline
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

" キーマップ系
" Tab 操作
noremap <Space>tt :tabnew<CR>
noremap <Space>tc :tabc<CR>
noremap <Space>to :tabo<CR>
noremap gn :tabn

" NERDTree 操作
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

" CtrlP 操作
nnoremap s <Nop>
nnoremap sp :CtrlPCurWD<CR>
nnoremap sb :CtrlPBuffer<CR>

noremap gl :ls<CR>:b<Space>

" 検索と置換
noremap <C-f> /
noremap <C-h> :%s/

" インデントやファイルタイプ操作
noremap <Space><Tab> :set<Space>expandtab!<CR>
noremap <Space>ft :set filetype=

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

augroup markdown_prettier
  autocmd!
  autocmd BufWrite,FileWritePre,FileAppendPre *.md Prettier
augroup END

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

" WSL 使用時のみ w レジスタの内容をクリップボードに送る
let s:clip = '/mnt/c/Windows/System32/clip.exe'
if executable(s:clip)
    augroup WSLYank
        autocmd!
        autocmd TextYankPost * if v:event.regname ==# 'w' | call system(s:clip, @w) | endif
    augroup END
endif

" colorscheme
colorscheme codedark

" colorscheme の Seach の設定をオーバーライド
function! SetCustomHilight()
    hi Search ctermbg=DarkGreen
    hi IncSearch ctermbg=DarkGreen
endfunction

call SetCustomHilight()

" TwitVim の設定
let twitvim_browser_cmd = 'google-chrome'
let twitvim_count = 40

" NERDTree の設定
let NERDTreeShowHidden=1

" lightline の設定
let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste'  ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified'  ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

" CtrlP の設定
" キャッシュを終了時に削除しない
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_max_files = 100000
let g:ctrlp_max_depth = 10

" gitgutterの設定
set updatetime=250
highlight GitGutterAdd ctermfg=green
highlight GitGutterChange ctermfg=yellow
highlight GitGutterDelete ctermfg=red
