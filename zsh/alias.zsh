# ============ Git ===============
alias gd="git diff @~..@"
alias grs="git reset HEAD~1"
alias gst="git status -s"
alias gsta="git add -A; git stash"
# alias gcl="git clone $(xclip -selection c -o)"    # Xclip required

# ============ Devevelopment ===============
alias dc="docker-compose"
alias bi="bundle install"
alias tmx="tmuxinator start project $1"
alias tsd="tmuxinator start django $1"
alias serve="python -m SimpleHTTPServer 8000"

# ============ System ===============
alias ss="source ~/.zshrc; echo 'Source zshrc complete';"
alias pls="sudo"
alias sdown="sudo shutdown -h now"
alias gno="gnome-open"
alias rr="rm -rf"
alias q="exit"
alias c="clear"
alias h="history | grep"
alias ps="ps aux | grep"
alias kill="sudo killall -9"

# File system tree
alias .='pwd'
alias ..='cd ..'
alias ...='cd ../..'
alias des="cd ~/Desktop"

# ls
alias ll="ls -lah"
alias la="ls -A"
alias l="ls"

# APT
alias update="sudo apt-get update"
alias install="sudo apt-get install"
alias add="sudo add-apt-repository"