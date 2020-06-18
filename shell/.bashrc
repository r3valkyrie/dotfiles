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
    setopt rcexpandparam

    autoload -Uz vcs_info
	precmd() { vcs_info }


    if [ -f "$HOME/.antigen.zsh" ]; then
        source $HOME/.antigen.zsh
    fi
fi

# Environment variables
export EDITOR="nvim" # Use Neovim as our default editor.

# Prompt

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
	zstyle ':vcs_info:git:*' formats 'on branch %b'
	 
	setopt PROMPT_SUBST
	PROMPT='%n %F{yellow}${PWD/#$HOME/~}%F{red}${vcs_info_msg_0_/on branch / }%F{gray} $ %F{blue}'
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

# node_modules
# export PATH="./node_modules/.bin:$PATH"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# yarn bin
if [ -s "/usr/bin/yarn" ]; then
    export PATH="$PATH:$(yarn global bin)"
fi

# asdf stuff
if [ -d "$HOME/.asdf" ]; then
    . $HOME/.asdf/asdf.sh
    . $HOME/.asdf/completions/asdf.bash
    export PATH="$PATH:$HOME/.asdf/shims"
fi

# Apply pywal to ttys.
if [ -d "$HOME/.cache/wal" ]; then
    source ~/.cache/wal/colors-tty.sh
    cat $HOME/.config/wpg/sequences
fi


if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
    bash $HOME/.bin/init.sh;
    exec tmux;
fi

#
# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.xz)    tar xJf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# command task
