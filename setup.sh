#!/bin/bash

DOT_FILES=(.bashrc .bash_aliases .vimrc .gitconfig .tmux.conf .editorconfig .clang-format .zshrc)

for file in ${DOT_FILES[@]}
do
	ln -s $HOME/dotfiles/$file $HOME/$file
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
	target_dirs=('/home/akiaki/.oh-my-zsh/plugins/git' '/home/akiaki/.oh-my-zsh/plugins' '/home/akiaki/.oh-my-zsh')
	for dir in ${target_dirs[@]}
	do
		chmod g-w,o-w $dir
	done
fi
