
function save_alias() {
  local name=$1
  local cmd=$2

  alias $name=$cmd
  echo "alias $name=\"$cmd\"" >> ~/.zsh_aliases
}

alias fixsound='sudo kextunload /System/Library/Extensions/AppleHDA.kext && sudo kextload /System/Library/Extensions/AppleHDA.kext'
