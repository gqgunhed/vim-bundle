# vim-bundle
my personal vim bundle with wrapper scripts to use vim-pathogen and other modules

## Clone it
To get this complete package you need to run some commands. In this case we are installing into /home/YourName/github/vim-bundle

    # make subdir
    mkdir $HOME/github
    
    # clone repository
    git clone https://github.com/gqgunhed/vim-bundle
    
    # create backup of old .vimrc and .vim subdir
    mv $HOME/.vimrc $HOME/.vimrc_old
    mv $HOME/.vim $HOME/.vim_old
    
    # create symlinks
    ln -s $HOME/github/vim-bundle/vimrc $HOME/.vimrc
    ln -s $HOME/github/vim-bundle $HOME/.vim
    
## Activation
Now that we have the symlinks in place we can start to activate the content. First we pull down all submodules I use, or that defined in submodules.txt:

    cd $HOME/github/vim-bundle
    
    # show help message
    python vim_control.py -h
    
    # install all packages from submodules.txt as git submodules
    python vim_control.py -i all
    
    # place vim-pathogen into autoload folder
    sh activate_vim-pathogen.sh
    
## Run
Now is the time to run your newly created vim environment.


# Other resources
* https://github.com/amix/vimrc
* https://gist.github.com/cridenour/74e7635275331d5afa6b
