LANG=ja_JP.UTF-8
export EDITOR=vim

#historyに関する設定
HISTFILE=$HOME/.zsh-history
HISTSIZE=1000000
SAVEHIST=1000000
## 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups
## ヒストリを共有
setopt share_history
## zsh の開始, 終了時刻をヒストリファイルに書き込む
setopt extended_history

#ls色付け
export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export ZLS_COLORS=$LS_COLORS
export CLICOLOR=true

# 補完結果の表示の色設定
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
## 補完機能の強化
autoload -U compinit
compinit
## 補完候補一覧でファイルの種別をマーク表示
setopt list_types
## 補完候補を一覧表示
setopt auto_list
## TAB で順に補完候補を切り替える
setopt auto_menu
## 補完候補のカーソル選択を有効に
zstyle ':completion:*:default' menu select=1
## 補完候補の色づけ
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
## カッコの対応などを自動的に補完
setopt auto_param_keys
## ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash
## --prefix=/usr などの = 以降も補完
setopt magic_equal_subst
# ディレクトリ移動履歴保存,"cd -[タブ]"で、これまでに移動したディレクトリ一覧が表示
setopt auto_pushd
#補完候補を詰めて表示する設定
setopt list_packed
# manの補完をセクション番号別に表示させる
zstyle ':completion:*:manuals' separate-sections true
# オブジェクトファイルとか中間ファイルとかはfileとして補完させない
zstyle ':completion:*:*files' ignored-patterns '*?.o' '*?~' '*\#' '*?.swp'

#先方予測機能を有効に設定
#autoload predict-on
#predict-on

### prompt
unsetopt promptcr
setopt prompt_subst
autoload -U colors; colors
autoload -Uz vcs_info

local HOSTNAME_COLOR=$'%{\e[38;5;190m%}'
local USERNAME_COLOR=$'%{\e[38;5;199m%}'
local PATH_COLOR=$'%{\e[38;5;61m%}'
local RUBY_COLOR=$'%{\e[38;5;31m%}'
local VCS_COLOR=$'%{\e[38;5;248m%}'

zstyle ':vcs_info:*' formats '[%b]'
zstyle ':vcs_info:*' actionformats '[%b] (%a)'

zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr '¹'  # display ¹ if there are unstaged changes
zstyle ':vcs_info:git:*' stagedstr '²'    # display ² if there are staged changes
zstyle ':vcs_info:git:*' formats '[%b]%c%u'
zstyle ':vcs_info:git:*' actionformats '[%b|%a]%c%u'

function ruby_prompt {
    if [ -f /usr/local/bin/rbenv ] 
    then
        result=`rbenv version | sed -e 's/ .*//'`
            if [ "$result" ] ; then
                echo "[$result]"
		    fi
    fi
    }

function git_stash_count {
	result=`git stash list 2>/dev/null | wc -l | tr -d ' '`
	if [ "$result" != 0 ] ; then
		echo " stash:$result"
	fi
}

precmd () {
	psvar=()
	vcs_info
	[[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}

RUBY_INFO=$'%{$RUBY_COLOR%}$(ruby_prompt)%{${reset_color}%}'
RPROMPT="${RUBY_INFO}%{${reset_color}%}"
PROMPT=$'%{$fg[yellow]%}%n%{$fg[red]%}@$fg[green]%}%m %{$fg[cyan]%}%~ %1(v|%F{green}%1v%f|)$(git_stash_count)\n%{$fg[green]%}%#%{$reset_color%}'
# http://www.machu.jp/diary/20040329.html#p01
# プロンプトを’[user@hostname] $ ’の形式で表示　一般ユーザは $ でrootは # にする
# プロンプトに色を付ける
#local GREEN=$'%{\e[1;32m%}'
#local BLUE=$'%{\e[1;34m%}'
#local DEFAULT=$'%{\e[1;m%}'
#PROMPT=$BLUE'[${USER}@${HOSTNAME}] %(!.#.$) '$DEFAULT
#RPROMPT=$GREEN'[%~]'$DEFAULT
#setopt PROMPT_SUBST

## 補完機能の強化
autoload -U compinit
compinit

# 第1引数がディレクトリだと自動的に cd を補完
setopt auto_cd

## コアダンプサイズを制限
limit coredumpsize 102400

## 出力の文字列末尾に改行コードが無い場合でも表示
unsetopt promptcr

## 色を使う
setopt prompt_subst

## ビープを鳴らさない
setopt nobeep

## 内部コマンド jobs の出力をデフォルトで jobs -l にする
setopt long_list_jobs

## サスペンド中のプロセスと同じコマンド名を実行した場合はリジューム
setopt auto_resume

## cd 時に自動で push
setopt autopushd

## 同じディレクトリを pushd しない
setopt pushd_ignore_dups

## ファイル名で #, ~, ^ の 3 文字を正規表現として扱う
setopt extended_glob

## =command を command のパス名に展開する
setopt equals



## ヒストリを呼び出してから実行する間に一旦編集
setopt hist_verify

# ファイル名の展開で辞書順ではなく数値的にソート
setopt numeric_glob_sort

## 出力時8ビットを通す
setopt print_eight_bit

## スペルチェック
setopt correct

# alias
#source ~/.aliases
if [ -f ~/.aliases ]; then
	. ~/.aliases
fi

## ディレクトリ名だけでcurennt directory移動、移動後自動でlsalする
#(先に.aliasesファイルをロードする必要がある)
setopt auto_cd
function chpwd() { lsal }

# cdとmkdirを一緒にする
# <a href="http://d.hatena.ne.jp/yarb/20110126/p1" target="_blank" rel="noreferrer" style="cursor: wait;display:inline !important;">http://d.hatena.ne.jp/yarb/20110126/p1</a>
function mkcd() {
if [[ -d $1 ]]; then
echo "It already exsits! Cd to the directory."
cd $1
else
echo "Created the directory and cd to it."
mkdir -p $1 && cd $1
fi
}

## rbenv
export RBENV_ROOT="/usr/local/bin/rbenv"
if [ -d $RBENV_ROOT ]; then
    export PATH="$RBENV_ROOT/bin:$PATH"
    if which rbenv > /dev/null; then eval "$(rbenv init - zsh)"; fi
fi

## http://d.hatena.ne.jp/hiboma/20120315/1331821642
## Ctrl + X Crtl + Pでコマンドラインをクリップボードに登録
pbcopy-buffer(){
	print -rn $BUFFER | pbcopy
	zle -M "pbcopy: ${BUFFER}"
	}
		
zle -N pbcopy-buffer
bindkey '^x^p' pbcopy-buffer

# bindkey
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward
bindkey '^X^F' forward-word
bindkey '^X^B' backward-word
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward

# do brew install autojump
if [ -f /usr/local/bin/brew ] && [ -f `brew --prefix`/etc/autojump ]; then
 . `brew --prefix`/etc/autojump
fi

# 3秒以上かかった処理は詳細表示
REPORTTIME=3
 [[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator

#use vm to show less command
alias less='/usr/share/vim/vim73/macros/less.sh'
# less のステータス行にファイル名と行数、いま何%かを表示
export LESS='-X -i -P ?f%f:(stdin). ?lb%lb?L/%L.. [?eEOF:?pb%pb\%..]'

#git command it conflicts with the zsh globbing問題を解決するため　https://blog.afoolishmanifesto.com/posts/git-aliases-for-your-life/
alias git='noglob git'

# REGRESSION_NEXLINK
    export REGRESSION_NEXLINK_HOME=$HOME/projects/regression_nexlink
    export REGRESSION_NEXLINK_DOWNLOAD_DIR=$HOME/Downloads

#perlの設定
if which plenv > /dev/null; then
    export PLENV_ROOT="\${HOME}/.plenv"
    export PATH=\${PLENV_ROOT}/shims:\${PATH}
    eval "\$(plenv init - zsh)";
fi

#pythonの設定
if which pyenv > /dev/null; then
    export PYENV_ROOT="\${HOME}/.pyenv"
    export PATH=\${PYENV_ROOT}/shims:\${PATH}
    eval "\$(pyenv init - zsh)";
fi


#~で終わる一時ファイルを削除する関数
rm~() {
if [ -f /usr/local/bin/trash ]
then
    case "$1" in
        "--dry-run" | "-n")
        find . -name "*~" \( -type f -or -type l \) -maxdepth 1
        ;;
    "~" | "DS_Store" | "swp")
        find . -name "*$1" \( -type f -or -type l \) -maxdepth 1 -exec  /usr/local/bin/trash -fv -- {} +
        ;;
    *)
        echo "Unsupported option \`$1'.\nDid you mean --dry-run?(using command trash)"
        ;;
    esac
elif [ -f /usr/local/bin/rmtrash ]
then
    case "$1" in
    "--dry-run" | "-n")
        find . -name "*~" \( -type f -or -type l \) -maxdepth 1
        ;;
    "~" | "DS_Store" | "swp")
        find . -name "*$1" \( -type f -or -type l \) -maxdepth 1 -exec  /usr/local/bin/rmtrash -fv -- {} +
        ;;
    *)
        echo "Unsupported option \`$1'.\nDid you mean --dry-run? (using command rmtrash)"
        ;;
    esac
else
    case "$1" in
    "--dry-run" | "-n")
        find . -name "*~" \( -type f -or -type l \) -maxdepth 1
        ;;
    "~" | "DS_Store" | "swp")
        find . -name "*$1" \( -type f -or -type l \) -maxdepth 1 -exec /bin/rm  -fv -- {} +
        ;;
    *)
        echo "Unsupported option \`$1'.\nDid you mean --dry-run? (using OS default command rm)"
        ;;
    esac
fi
}

#子ディレクトリも削除しに行く。
rma~() {
if [ -f /usr/local/bin/trash ]
then
    case "$1" in
    "--dry-run" | "-n")
        find . -name "*~" \( -type f -or -type l \)
        ;;
    "~" | "DS_Store" | "swp")
        find . -name "*$1" \( -type f -or -type l \) -exec  /usr/local/bin/trash -fv -- {} +
        ;;
    *)
        echo "Unsupported option \`$1'.\nDid you mean --dry-run?(using command trash)"
        ;;
    esac
elif [ -f /usr/local/bin/rmtrash ]
then
    case "$1" in
    "--dry-run" | "-n")
        find . -name "*~" \( -type f -or -type l \)
        ;;
    "~" | "DS_Store" | "swp")
        find . -name "*$1" \( -type f -or -type l \) -exec  /usr/local/bin/rmtrash -fv -- {} +
        ;;
    *)
        echo "Unsupported option \`$1'.\nDid you mean --dry-run? (using command rmtrash)"
        ;;
    esac
else
    case "$1" in
    "--dry-run" | "-n")
        find . -name "*~" \( -type f -or -type l \)
        ;;
    "~" | "DS_Store" | "swp")
        find . -name "*$1" \( -type f -or -type l \) -exec /bin/rm  -fv -- {} +
        ;;
    *)
        echo "Unsupported option \`$1'.\nDid you mean --dry-run? (using OS default command rm)"
        ;;
    esac
fi
}

# Show/hide hidden files in Finder
 alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
 alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# iTerm2のタブ名を変更する関数を追加
function title {
    echo -ne "\033]0;"$*"\007"
}

#ログイン時に自動的にtmuxを起動、セッションがある場合はアタッチするようになります。
if [ -z "$PS1" ]; then return ; fi

if [ -z $TMUX ] ; then
    if [ -z `tmux ls` ] ; then
        tmux
    else
        tmux attach
    fi
fi

#auto-fu.zsh
# <a href="http://blog.glidenote.com/blog/2012/04/07/auto-fu.zsh/" target="_blank" rel="noreferrer" style="cursor: wait;display:inline !important;">http://blog.glidenote.com/blog/2012/04/07/auto-fu.zsh/</a>
if [ -f ~/dotfiles/auto-fu.zsh ]; then
source ~/dotfiles/auto-fu.zsh
function zle-line-init () {
auto-fu-init
}
zle -N zle-line-init
zstyle ':completion:*' completer _oldlist _complete
#auto-fu.zshを使っていると「-azhu-」と表示されるのだが，邪魔なので表示しないようにした。
zstyle ':auto-fu:var' postdisplay $''
fi
 
## ^PとかのHistory検索と相性が悪い
## auto-fu.zshのためオリジナルが変更
## URLをコピペしたときに自動でエスケープ
#autoload -Uz url-quote-magic
#zle -N self-insert url-quote-magic
