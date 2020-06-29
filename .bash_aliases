alias opn='xdg-open'
alias mkmake='cp ~/Makefile.tmp Makefile; mkdir include src'
cdpwd ()
{
	\cd "$@" && ls && pwd
}
alias cd="cdpwd"
#TODO: move this alias to .gitconfig
alias git-delete-merged-branch="git checkout master && git branch --merged | grep -v '*' | xargs -I % git branch -d %"

alias fn='cd "$(find . -type d | grep -v "\/\." | peco)"'

peco-select-history() {
    declare l=$(HISTTIMEFORMAT= history | sort -k1,1nr | perl -ne 'BEGIN { my @lines = (); } s/^\s*\d+\s*//; $in=$_; if (!(grep {$in eq $_} @lines)) { push(@lines, $in); print $in; }' | peco --query "$READLINE_LINE")
    READLINE_LINE="$l"
    READLINE_POINT=${#l}
}
bind -x '"\C-h": peco-select-history'
bind -x '"\C-f": fn'
