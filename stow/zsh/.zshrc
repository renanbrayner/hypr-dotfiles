### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

HISTSIZE=50000 # Define o número de comandos a serem armazenados na memória
SAVEHIST=50000 # Define o número de comandos a serem salvos no arquivo
HISTFILE=~/.zshhist

setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS # Não salva comandos duplicados
setopt HIST_IGNORE_SPACE # Não salva comandos que começam com espaço
setopt HIST_REDUCE_BLANKS # Remove espaços em branco extras
setopt HIST_SAVE_NO_DUPS
setopt INC_APPEND_HISTORY # Adiciona comandos ao histórico imediatamente
setopt SHARE_HISTORY # Compartilha o histórico entre múltiplas instâncias do zsh
setopt EXTENDED_HISTORY # Salva comandos que começam com espaço
setopt HIST_IGNORE_DUPS
setopt AUTOCD
setopt NO_BEEP
bindkey -e

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
mkdir -p ~/.zsh/cache

autoload -Uz compinit
compinit -C

# Usa oh-my-posh fora do tty
if [[ -n $DISPLAY ]]; then
  eval "$(oh-my-posh init zsh --config '~/.config/oh-my-posh/themes/dracula.omp.json')"
fi

# customiza prompt no tty
if [[ "$TERM" = "linux" ]]; then
  PROMPT="%B%F{magenta}%n%f%b at %F{cyan}%~%f%F{green} > %f"
  RPS1="%B%F{magenta}--INSERT--"
  function zle-line-init zle-keymap-select {
      RPS1="%B%F{magenta}${${KEYMAP/vicmd/--NORMAL--}/(main|viins)/--INSERT--}"
      RPS2=$RPS1
      zle reset-prompt
  }
  zle -N zle-line-init
  zle -N zle-keymap-select
fi

# plugins gerais
zinit light "zsh-users/zsh-autosuggestions"
zinit light "zdharma-continuum/fast-syntax-highlighting"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
zinit light "zsh-users/zsh-completions"
zinit ice wait lucid atclone'./install --bin' atpull'%atclone'
zinit light junegunn/fzf

# plugins desativados no tty
if [[ -n $DISPLAY ]]; then
    zinit light "jeffreytse/zsh-vi-mode"
fi

# aliases gerais
alias e='exit'
alias vim='nvim'
alias learn='cd ~/code/learn/'
alias rm='rm -i'
alias mv='mv -i'
alias ..='cd ..'
alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'
alias neofetch='neofetch --config ~/.config/neofetch.conf'
# aliases fora do tty
if [[ -n $DISPLAY ]]; then
    alias ls="exa -a --group-directories-first --icons" || alias ls="exa -a --group-directories-first"
    alias tree='f(){exa -T -a --group-directories-first --icons "$@"; unset -f f; }; f' || alias tree='f(){exa -T -a --group-directories-first "$@"; unset -f f; }; f'
fi

eval "$(zoxide init zsh)"

# exports
fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
export PATH="$PATH:/home/renan/.dotnet/tools"
[ -f ~/.secrets ] && source ~/.secrets
