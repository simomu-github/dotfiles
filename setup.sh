#!/bin/bash

set -eu

DOT_FILES=(.bashrc .bash_aliases .vimrc .gitconfig .tmux.conf .editorconfig .clang-format .zshrc)

for file in ${DOT_FILES[@]}
do
	if [ ! -e $HOME/$file ]; then
		ln -s $HOME/dotfiles/$file $HOME/$file
	fi
done

if [ ! -e ~/.vim/bundle ]; then
	mkdir -p ~/.vim/bundle
	git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
fi

vim -c NeoBundleInstall -c qa

if [ ! -e ~/.tmux/plugins/tpm ]; then
	mkdir -p ~/.tmux/
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [ ! -e ~/.gituser ]; then
	echo -e "#edit your git global user info\n[user]\n\tname = \n\temail = " > ~/.gituser
	vim ~/.gituser
fi

if [ ! -e ~/.oh-my-zsh ]; then
	git clone https://github.com/ohmyzsh/ohmyzsh.git $HOME/.oh-my-zsh
	target_dirs=("$(HOME)/.oh-my-zsh/plugins/git" "$(HOME)/.oh-my-zsh/plugins" "$(HOME)/.oh-my-zsh")
	for dir in ${target_dirs[@]}
	do
		chmod g-w,o-w $dir
	done
fi

if [ ! -e ~/.vscode ]; then
	mkdir -p ~/.vscode
fi

if [ ! -e ~/.vscode/settings.json ]; then
	ln -s ~/dotfiles/settings.json ~/.vscode/settings.json
fi

if $(uname -r | grep -ivq 'Microsoft'); then
	cat ~/dotfiles/vscode_extensions | while read line
	do
		type code > /dev/null 2>&1 && code --install-extension $line
	done
fi
