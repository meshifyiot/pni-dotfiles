
# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
# export PATH="$PATH:$HOME/.rvm/bin"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

autoload -U +X bashcompinit && bashcompinit
fpath=($fpath "/Users/patrickjmcd/.zfunctions")

# Set Spaceship ZSH as a prompt
autoload -U promptinit; promptinit
prompt spaceship

eval $(thefuck --alias)

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fpath=($fpath "/Users/patrickjmcd/.zfunctions")

if [ -e ~/.env_variables ]; then
  source ~/.env_variables
fi

# source aliases
if [[ -f ~/.dotfiles/.aliases ]]; then
  source ~/.dotfiles/.aliases
fi

# source functions
if [[ -f ~/.dotfiles/.functions ]]; then
  source ~/.dotfiles/.functions
fi

# Find your Python User Base path (where Python --user will install packages/scripts)
USER_BASE_PATH=$(python -m site --user-base)
export PATH=$PATH:$USER_BASE_PATH/bin

PYTHON3_USER_BASE_PATH=$(python3 -m site --user-base)
export PATH=$PATH:$PYTHON3_USER_BASE_PATH/bin

# GO INITIALIZATION
export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin:$GOPATH

if [ -e ~/.dotfiles/motd/motd.sh ]; then
  ~/.dotfiles/motd/motd.sh
fi