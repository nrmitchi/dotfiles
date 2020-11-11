
# Editors.
# --------
export EDITOR='/usr/bin/vim'
export VISUAL='/usr/bin/vim'
export PAGER='less'

# Language.
# ---------
if [[ -z "$LANG" ]]; then
  eval "$(locale)"
fi

# Less.
# -----
# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'

# # Set the Less input preprocessor.
# if (( $+commands[lesspipe.sh] )); then
#   export LESSOPEN='| /usr/bin/env lesspipe.sh %s 2>&-'
# fi

# Paths.
# ------
typeset -gU cdpath fpath mailpath manpath path
typeset -gUT INFOPATH infopath

# # Commonly used directories.
dev="$HOME/Developer"
pm="$dev/nrmitchi"
wk="$HOME/src/"

# Set the list of directories that info searches for manuals.
infopath=(
  /usr/local/share/info
  /usr/share/info
  $infopath
)

# Set the list of directories that man searches for manuals.
manpath=(
  /usr/local/share/man
  /usr/share/man
  $manpath
)

for path_file in /etc/manpaths.d/*(.N); do
  manpath+=($(<$path_file))
done
unset path_file

# Set the list of directories that Zsh searches for programs.
export PYTHONPATH=/usr/local/lib/python2.7/site-packages
path=(
  /usr/local/{bin,sbin}
  /usr/local/opt/ruby/bin
  /usr/local/lib/python2.7/site-packages
  /usr/local/share/npm/bin
  /usr/{bin,sbin}
  /{bin,sbin}
  $ANDROID_HOME/tools
  ~/.kube/plugins
  $path
)

for path_file in /etc/paths.d/*(.N); do
  path+=($(<$path_file))
done
unset path_file

# Temporary Files.
if [[ -d "$TMPDIR" ]]; then
  export TMPPREFIX="${TMPDIR%/}/zsh"
  if [[ ! -d "$TMPPREFIX" ]]; then
    mkdir -p "$TMPPREFIX"
  fi
fi

