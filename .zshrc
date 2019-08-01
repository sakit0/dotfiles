# zplug
source ~/.zplug/init.zsh

# enhancd
source ~/.zplug/init.zsh
zplug "b4b4r07/enhancd", use:"init.sh"
 
if ! zplug check --verbose; then
    printf "インストールしますか？[y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
 
zplug load

# zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# nodebrew周り
NODEBREW_HOME=$HOME/.nodebrew/current
export PATH=$PATH:$NODEBREW_HOME/bin

# GO周り
export GOPATH=$HOME/go
export PATH=/usr/local/go/bin:$GOPATH/bin:~/.local/bin:$PATH

# yakumo
export PATH=$GOPATH/src/github.com/cybozu-private/yakumo/tools/yakumo:$PATH

# mysql
export PATH=/usr/local/opt/mysql@5.7/bin:$PATH


# Set pure ZSH as a prompt
autoload -U promptinit; promptinit
prompt pure

# java

TMPFILE=$(mktemp)

export JAVA_HOME=$(/usr/libexec/java_home)
export PATH="/usr/local/opt/maven@3.2/bin:$PATH"

# 履歴ファイルの保存先
export HISTFILE=${HOME}/.zsh_history

# メモリに保存される履歴の件数
export HISTSIZE=1000

# 履歴ファイルに保存される履歴の件数
export SAVEHIST=100000

# 重複を記録しない
setopt hist_ignore_dups

# 開始と終了を記録
setopt EXTENDED_HISTORY

# 履歴検索
function buffer-fzf-history() {
    local HISTORY=$(history -n -r 1 | fzf +m)
    BUFFER=$HISTORY
    if [ -n "$HISTORY" ]; then
        CURSOR=$#BUFFER
    else
        zle accept-line
    fi
}
zle -N buffer-fzf-history

# Gitブランチを切り替えする
function checkout-fzf-gitbranch() {
    local GIT_BRANCH=$(git branch --all | grep -v HEAD | fzf +m)
    if [ -n "$GIT_BRANCH" ]; then
        git checkout $(echo "$GIT_BRANCH" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
    fi
    zle accept-line
}
zle -N checkout-fzf-gitbranch


# alias集
alias reload='exec $SHELL -l'
alias repo='cd $(ghq list -p | peco)'
## git
alias g='git'
alias ga='git add'
alias gd='git diff'
alias gs='git status'
alias gp='git pull'
alias gpu='git push'
alias gb='git branch'
alias gst='git status'
alias gco='git checkout'
alias gf='git fetch'
alias gc='git commit'
alias -g LR='`git branch -a | peco --query "remotes/ " --prompt "GIT REMOTE BRANCH>" | head -n 1 | sed "s/^\*\s*//" | sed "s/remotes\/[^\/]*\/\(\S*\)/\1 \0/"`'

alias a='alias'
alias n='npm run'
alias u='cd ..' # up

alias -g B='`git branch -a | peco --prompt "GIT BRANCH>" | head -n 1 | sed -e "s/^\*\s*//g"`'
## bind
bindkey '^R' buffer-fzf-history
bindkey '^O' checkout-fzf-gitbranch
