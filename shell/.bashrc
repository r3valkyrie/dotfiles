#               ____              _
#  _   ______ _/ / /____  _______(_)__
# | | / / __ `/ / //_/ / / / ___/ / _ \
# | |/ / /_/ / / ,< / /_/ / /  / /  __/
# |___/\__,_/_/_/|_|\__, /_/  /_/\___/
#                  /____/


# Check what shell we're using (bash or zsh).
SHELL="$(basename $(readlink /proc/$$/exe))"

isBash=false
isZsh=false

if [ "${SHELL}" = "bash" ]; then
    isBash=true
elif [ "${SHELL}" = "zsh" ]; then
    isZsh=true
fi

# General settings

umask 022 # Set umask
stty -ixon # Disable flow control.
set -o emacs # Emacs keybindings

# Bash settings
if ${isBash}; then
    shopt -s checkwinsize # Update $LINES and $COLUMNS when terminal size changes.
    shopt -s extglob # Enable extended globbing functionality.

# Zsh settings
elif ${isZsh}; then
    setopt extendedglob # Enable extended globbing functionality.
    # setopt histignoredups # Ignore repeated lines in history.
    # setopt correct # Detect and prompt to correct typos in commands.
    setopt nobeep # Disable zsh's beeping.
    setopt nobgnice # Di not change the nice priority of bg'd commands.
    setopt nohup # Do not kill bg processes when closing the shell.
    setopt nocheckjobs # Do not warn about closing the shell with background jobs running.
    setopt interactivecomments # Allow comments on the command line.

    autoload -Uz compinit # Load completions
    compinit

    source $HOME/.antigen.zsh

    # Set prompt
    autoload -U promptinit; promptinit
fi

# Evironment variables
export EDITOR="vim" # Use Vim as our default editor.
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=2' # Color for zsh autosuggestions.

# Theme

if ${isBash}; then
    case "$TERM" in
        "dumb")
            export PS1="> "
            ;;
        xterm*|rxvt*|eterm*|screen*)
	    tty -s && export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "

            ;;
    esac

    [ -f ~/.fzf.bash ] && source ~/.fzf.bash # Source fzf

elif ${isZsh}; then
	prompt redhat

    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh # Source fzf
fi


# Load aliases
if [ -f $HOME/.aliases ]; then
    . $HOME/.aliases
fi

# Load my scripts
if [ -d "$HOME/.bin" ]; then
    export PATH="$PATH:$HOME/.bin"
fi

# Load .local/bin

if [ -d "$HOME/.local/bin" ]; then
    export PATH="$PATH:$HOME/.local/bin"
fi

# CUDA stuff
if [ -d "/usr/local/cuda/bin" ]; then
    export PATH="$PATH:/usr/local/cuda/bin"
fi

# Snap stuff
if [ -d "/snap/bin" ]; then
    export PATH="$PATH:/snap/bin"
fi

# RVM stuff
if [ -d "$HOME/.rvm/bin" ]; then
    export PATH="$PATH:$HOME/.rvm/bin"
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# asdf stuff
if [ -d "$HOME/.asdf" ]; then
    . $HOME/.asdf/asdf.sh
    . $HOME/.asdf/completions/asdf.bash
    export PATH="$PATH:$HOME/.asdf/shims"
fi

# Apply pywal to ttys.
source ~/.cache/wal/colors-tty.sh

cat $HOME/.config/wpg/sequences

if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
     . $HOME/.bin/init.sh;
     exec tmux;
fi

command task
