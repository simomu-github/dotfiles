# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

function cdpwd ()
{
	\cd "$@" && ls && pwd
}
alias cd="cdpwd"
alias git-delete-merged-branch="git checkout master && git branch --merged | grep -v '*' | xargs -I % git branch -d %"

alias ll="ls -la"

function peco-history-selection() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
        eval $tac | awk '!a[$0]++' | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}

zle -N peco-history-selection
bindkey '^H' peco-history-selection

type direnv > /dev/null 2>&1 && eval "$(direnv hook zsh)"
type kubectl > /dev/null 2>&1 && source <(kubectl completion zsh)

PATH="$HOME/.rbenv/bin:$PATH"
type rbenv > /dev/null 2>&1 && eval "$(rbenv init -)"

PATH="$HOME/.nodenv/bin:$PATH"
type rbenv > /dev/null 2>&1 && eval "$(nodenv init -)"

PATH="$HOME/.tfenv/bin:$PATH"

PATH="$HOME/bin:$HOME/.local/bin:$PATH"
PATH="$HOME/.local/go/bin:$PATH"

if [ -f "${HOME}/google-cloud-sdk/path.zsh.inc"  ]; then . "${HOME}/google-cloud-sdk/path.zsh.inc"; fi
if [ -f "${HOME}/google-cloud-sdk/completion.zsh.inc"  ]; then . "${HOME}/google-cloud-sdk/completion.zsh.inc"; fi

if [ $(uname -r | grep -i 'Microsoft') ]; then
    alias open="powershell.exe /c start"
fi

function start_tmux_automatic()
{
    if [ -z "$TMUX" ]; then
        if tmux has-session >/dev/null 2>&1 && tmux list-sessions | grep -qE '.*]$'; then
            # detached session exists
            tmux list-sessions
            echo -n "Tmux: attach? (y/N/num) "
            read
            if [[ "$REPLY" =~ ^[Yy]$ ]] || [[ "$REPLY" == '' ]]; then
                tmux attach-session
                if [ $? -eq 0 ]; then
                    return 0
                fi
            elif [[ "$REPLY" =~ ^[0-9]+$ ]]; then
                tmux attach -t "$REPLY"
                if [ $? -eq 0 ]; then
                    return 0
                fi
            fi
        fi

        tmux new-session && echo "tmux created new session"
    fi
}

start_tmux_automatic

cat $HOME/dotfiles/moai.ansi
