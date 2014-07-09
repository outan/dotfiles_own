" 文字コードとかの設定
set encoding=utf-8

"改行可視化(行末が$、TABが^Iで表示される)"
set list

"改行コード
set fileformats=unix,dos,mac

" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
  endif

"色設定
syntax on

"タブの設定
set softtabstop=4
set shiftwidth=4
set tabstop=4
set expandtab

"新しい行のインデントを現在行と同じにする
set autoindent

" ペーストするときにインデントさせない
imap <F5> <nop>
set pastetoggle=<F5>

"検索
set incsearch
set ignorecase
set smartcase
set nohlsearch

"行数表示
set number

"閉括弧が入力された時、対応する括弧を強調する
set showmatch

"他で編集されたら読み込み直す
set autoread

"新しい行を作った時に高度な自動インデントを行う
set smarttab

" grep検索を設定する
set grepformat=%f:%l:%m,%f:%l%m,%f\ \ %l%m,%f
set grepprg=grep\ -nh
 
 " 検索結果のハイライトをEsc連打でクリアする
 nnoremap <ESC><ESC> :nohlsearch<CR>

"補完
set complete=.,w,b,u,k
"set completeopt=menu,preview,longest
set pumheight=20

"検索時に最後まで行ったら最初に戻る"
set wrapscan

"ステータスラインを常に表示（編集中のファイル名が常に確認できるようになる)"
set laststatus=2

"入力中のコマンドをステータスに表示する"
set showcmd

"ステータスラインに文字コードと改行文字を表示する"
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P

"編集中の内容を保ったまま別の画面に切替えられるようにする(デフォルトだと一度保
"存しないと切り替えられない)"
set hid
