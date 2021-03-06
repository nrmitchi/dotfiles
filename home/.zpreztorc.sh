
# Sets Prezto options.


# Set the key mapping style to 'emacs' or 'vi'.
zstyle ':prezto:module:editor' keymap 'vi'

# Auto convert .... to ../..
# zstyle ':prezto:module:editor' dot-expansion 'no'

# Set case-sensitivity for completion, history lookup, etc.
zstyle ':prezto:*:*' case-sensitive 'no'

# Color output (auto set to 'no' on dumb terminals).
zstyle ':prezto:*:*' color 'yes'

# Auto set the tab and window titles.
zstyle ':prezto:module:terminal' auto-title 'yes'

# Set the Zsh modules to load (man zshmodules).
# zstyle ':prezto:load' zmodule 'attr' 'stat'

# Set the Zsh functions to load (man zshcontrib).
zstyle ':prezto:load' zfunction 'zargs' 'zmv'

# Set the Prezto modules to load (browse ~/.zprezto/modules).
# The order matters.
zstyle ':prezto:load' pmodule \
  'completion' \
  'directory' \
  'environment' \
  'history' \
  'spectrum' \
  'syntax-highlighting' \
  'terminal' \
  'utility'

# completion
# node  # This is for nodejs