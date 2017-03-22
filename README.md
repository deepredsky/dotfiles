# Dot Files

These are config files to set up a system the way I like it.


## Installation

Run the following commands in your terminal. It will prompt you before it does anything destructive.

```terminal
git clone git://github.com/deepredsky/dotfiles ~/.dotfiles
cd ~/.dotfiles
rake install
```

After installing, open a new terminal window to see the effects.


## Uninstall

To remove the dotfile configs, run the following commands. Be certain to double check the contents of the files before removing so you don't lose custom settings.

```
unlink ~/.bin
unlink ~/.gitignore
unlink ~/.gemrc
unlink ~/.irbrc
unlink ~/.vim
unlink ~/.vimrc
rm ~/.gitconfig
rm -rf ~/.dotfiles
chsh -s /bin/bash # change back to Bash if you want
```

Then open a new terminal window to see the effects.

Based on https://github.com/ryanb/dotfiles
