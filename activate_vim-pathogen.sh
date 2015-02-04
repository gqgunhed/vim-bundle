#!/bin/sh
# simple install wrapper
# for vim-pathogen
# see: https://github.com/tpope/vim-pathogen

mkdir -p ~/.vim/autoload
#mkdir -p ~/.vim/bundle
#curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

cp ~/.vim/bundle/vim-pathogen/autoload/pathogen.vim ~/.vim/autoload/pathogen.vim
