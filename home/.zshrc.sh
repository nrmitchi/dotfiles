#!/usr/bin/env zsh

# Start and load zprezto options
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

autoload -U colors && colors

# Load and execute the prompt theming system.
fpath=("$pm/dotfiles/terminal" $fpath)
autoload -Uz promptinit && promptinit
prompt 'nrmitchi'

# ==================================================================
# = Aliases =
# ==================================================================

# Simple clear command.
alias cl='clear'

# Disable sertificate check for wget.
alias wget='wget --no-check-certificate'

# JSHint short-cut.
alias lint=jshint

# Faster NPM for europeans.
alias npme='npm --registry http://registry.npmjs.eu'

# Useful global aliases.
alias -g 'H'='| head'     # git log H
alias -g 'T'='| tail'     # git log T
alias -g 'F'='| head -n'  # git log F 15
alias -g 'L'='| tail -n'  # git log L 10
alias -g 'C'='| wc -l'    # git log C

# Some OS X-only stuff.
if [[ "$OSTYPE" == darwin* ]]; then

  plugins=(osx terminalapp)
  # Short-cuts for copy-paste.
  alias c='pbcopy'
  alias p='pbpaste'

  # Remove all items safely, to Trash (`brew install trash`).
  alias rm='trash'

  # Case-insensitive pgrep that outputs full path.
  alias pgrep='pgrep -fli'

  # Lock current session and proceed to the login screen.
  alias lock='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'

  # Sniff network info.
  alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"

  # Developer tools shortcuts.
  alias tower='gittower --status'
  alias t='tower'

  # Process grep should output full paths to binaries.
  alias pgrep='pgrep -fli'
else
  # Process grep should output full paths to binaries.
  alias pgrep='pgrep -fl'
fi

# Git short-cuts.
alias g='git'
alias ga='git add'
alias gb='git branch'
alias gr='git rm'

alias gf='git fetch'
alias gu='git pull'
alias gup='git pull && git push'

alias gs='git status --short'
alias gd='git diff'
alias gds='git diff --staged'
alias gdisc='git discard'

function gc() {
  args=$@
  git commit -m "$args"
}
function gca() {
  args=$@
  git commit --amend -m "$args"
}

alias gp='git push'

function gcp() {
  args=$@
  git commit -a -m "$args" && git push -u origin
}
alias gcl='git clone'
alias gch='git checkout'
alias gl='git log --graph'

# Terraform short-cuts
alias tf='terraform'
alias tfp='terraform plan'
alias tfa='terraform apply'

alias jk='jekyll serve --watch' # lol jk
alias serve='python -m SimpleHTTPServer'

# Lists the ten most used commands.
alias history-stat="history 0 | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"

# Kubernetes
alias k="kubectl"
alias mk="minikube"

alias kns="kubens"
alias kctx="kubectx"
alias ktx="kubectx"

# Docker aliases
alias d="docker"
alias dc="docker-compose"

# ==================================================================
# = Functions =
# ==================================================================
# Show man page in Preview.app.
# $ manp cd
function manp {
  local page
  if (( $# > 0 )); then
    for page in "$@"; do
      man -t "$page" | open -f -a Preview
    done
  else
    print 'What manual page do you want?' >&2
  fi
}

# Show current Finder directory.
function finder {
  osascript 2>/dev/null <<EOF
    tell application "Finder"
      return POSIX path of (target of window 1 as alias)
    end tell
EOF
}

# Gets password from OS X Keychain.
# $ get-pass github
function get-pass() {
  keychain="$HOME/Library/Keychains/login.keychain"
  security -q find-generic-password -g -l $@ $keychain 2>&1 |\
    awk -F\" '/password:/ {print $2}';
}

# Opens file in EDITOR.
function edit() {
  local dir=$1
  [[ -z "$dir" ]] && dir='.'
  $EDITOR $dir
}
alias e=edit

# Execute commands for each file in current directory.
function each() {
  for dir in *; do
    echo "${dir}:"
    cd $dir
    $@
    cd ..
  done
}

# Find files and exec commands at them.
# $ find-exec .coffee cat | wc -l
# # => 9762
function find-exec() {
  find . -type f -iname "*${1:-}*" -exec "${2:-file}" '{}' \;
}

# Count code lines in some directory.
# $ loc py js css
# # => Lines of code for .py: 3781
# # => Lines of code for .js: 3354
# # => Lines of code for .css: 2970
# # => Total lines of code: 10105
function loc() {
  local total
  local firstletter
  local ext
  local lines
  total=0
  for ext in $@; do
    firstletter=$(echo $ext | cut -c1-1)
    if [[ firstletter != "." ]]; then
      ext=".$ext"
    fi
    lines=`find-exec "*$ext" cat | wc -l`
    lines=${lines// /}
    total=$(($total + $lines))
    echo "Lines of code for ${fg[blue]}$ext${reset_color}: ${fg[green]}$lines${reset_color}"
  done
  echo "${fg[blue]}Total${reset_color} lines of code: ${fg[green]}$total${reset_color}"
}

# Show how much RAM application uses.
# $ ram safari
# # => safari uses 154.69 MBs of RAM.
function ram() {
  local sum
  local items
  local app="$1"
  if [ -z "$app" ]; then
    echo "First argument - pattern to grep from processes"
  else
    sum=0
    for i in `ps aux | grep -i "$app" | grep -v "grep" | awk '{print $6}'`; do
      sum=$(($i + $sum))
    done
    sum=$(echo "scale=2; $sum / 1024.0" | bc)
    if [[ $sum != "0" ]]; then
      echo "${fg[blue]}${app}${reset_color} uses ${fg[green]}${sum}${reset_color} MBs of RAM."
    else
      echo "There are no processes with pattern '${fg[blue]}${app}${reset_color}' are running."
    fi
  fi
}

function size() {
  du -sh "$@" 2>&1 | grep -v '^du:'
}

# $ git log --no-merges --pretty=format:"%ae" | stats
# 514 a@example.com
# 200 b@example.com
function stats() {
  sort | uniq -c | sort -r
}

# Shortcut for searching commands history.
function hist() {
  history 0 | grep $@
}

# aes-enc file.zip
function aes-enc() {
  openssl enc -aes-256-cbc -e -in $1 -out "$1.aes"
}

# aes-dec file.zip.aes
function aes-dec() {
  openssl enc -aes-256-cbc -d -in $1 -out "${1%.*}"
}

# Shortens GitHub URLs. By Sorin Ionescu <sorin.ionescu@gmail.com>
function gitio() {
  local url="$1"
  local code="$2"

  [[ -z "$url" ]] && print "usage: $0 url code" >&2 && exit
  [[ -z "$code" ]] && print "usage: $0 url code" >&2 && exit

  curl -s -i 'http://git.io' -F "url=$url" -F "code=$code"
}

# Monitor IO in real-time (open files etc).
function openfiles() {
  sudo dtrace -n 'syscall::open*:entry { printf("%s %s",execname,copyinstr(arg0)); }'
}

# 4 lulz.
function compute() {
  while true; do head -n 100 /dev/urandom; sleep 0.1; done \
    | hexdump -C | grep "ca fe"
}

# Set tab title to current directory
# Using "\e]1;%n@%m: %~\a" will include user@host
case $TERM in
    *xterm*|ansi)
        function settab { print -Pn "\e]1;%~\a" }
        function settitle { print -Pn "\e]2;%~\a" }
        function chpwd { settab;settitle }
        settab;settitle
        ;;
esac

GOPATH=~/go
PATH=$PATH:$GOPATH/bin
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# added by Anaconda3 4.3.1 installer
# export PATH="/Users/nrmitchi/anaconda3/bin:$PATH"

bindkey -v
bindkey '^R' history-incremental-search-backward

# Change directory display color to Green
export LSCOLORS=cxfxcxdxbxGxDxabagacad

# This is insanely slow currently due to: https://github.com/kubernetes/kubernetes/issues/59078
# Replace when the issue is solved.
# if type kubectl > /dev/null; then
#   source <(kubectl completion zsh)
# fi

function kubectl() {
    if ! type __start_kubectl >/dev/null 2>&1; then
        source <(command kubectl completion zsh)
    fi

    command kubectl "$@"
}

# ------ Stole fromn https://gist.github.com/QinMing/364774610afc0e06cc223b467abe83c0 ----
lazy_load() {
    # Act as a stub to another shell function/command. When first run, it will load the actual function/command then execute it.
    # E.g. This made my zsh load 0.8 seconds faster by loading `nvm` when "nvm", "npm" or "node" is used for the first time
    # $1: space separated list of alias to release after the first load
    # $2: file to source
    # $3: name of the command to run after it's loaded
    # $4+: argv to be passed to $3
    echo "Lazy loading $1 ..." > /dev/stderr

    # $1.split(' ') using the s flag. In bash, this can be simply ($1) #http://unix.stackexchange.com/questions/28854/list-elements-with-spaces-in-zsh
    # Single line won't work: local names=("${(@s: :)${1}}"). Due to http://stackoverflow.com/questions/14917501/local-arrays-in-zsh   (zsh 5.0.8 (x86_64-apple-darwin15.0))
    local -a names
    if [[ -n "$ZSH_VERSION" ]]; then
        names=("${(@s: :)${1}}")
    else
        names=($1)
    fi
    unalias "${names[@]}"
    . $2
    shift 2
    $*
}

group_lazy_load() {
    local script
    script=$1
    shift 1
    for cmd in "$@"; do
        alias $cmd="lazy_load \"$*\" $script $cmd"
    done
}
# ----------------------------------------------------------------------------------------


# RVM thing
# [[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
group_lazy_load $HOME/.rvm/scripts/rvm rvm irb rake rails
group_lazy_load /usr/local/opt/nvm/nvm.sh nvm

# NVM thing
# export NVM_DIR="$HOME/.nvm"
# source "/usr/local/opt/nvm/nvm.sh"

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

## Begin Fullstory setup.
# Todo: Limit this to only FS machine.
if [ $(hostname) = "nicholas" ]; then

    # The next line updates PATH for the Google Cloud SDK.
    if [ -f '/Users/nick/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/nick/Downloads/google-cloud-sdk/path.zsh.inc'; fi

    # The next line enables shell command completion for gcloud.
    if [ -f '/Users/nick/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/nick/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

    export SKIP_FS_PS1=true
    export FS_SKIP_CD=true
    source /Users/nicholas/.fsprofile 2> /dev/null
    eval "$(direnv hook zsh)"
    PATH=$PATH:/Users/nicholas/src/fsdev/tools/go/bin # Add FS go bin dir to path
fi
## End Fullstory setup.

