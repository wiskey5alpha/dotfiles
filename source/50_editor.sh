# Editing

export EDITOR=edit


if [[ ! "$SSH_TTY" ]]; then
  if [[ ! "$TMUX" ]]; then
    EDITOR=edit
  fi
  export LESSEDIT="$EDITOR ?lm+%lm -- %f"
  export GIT_EDITOR="$EDITOR"
fi

export VISUAL="$EDITOR"
