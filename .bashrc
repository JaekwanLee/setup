#
# custom bash
#

# Aliase
alias ll='ls -alh'
alias la='ls -A'
alias l='ls -CFlh'
alias woo='fortune'
alias lsd="ls -alF | grep /$"

# find out what is taking so much space
alias diskspace="du -S | sort -n -r | more"

# show size of only folders
alias folders="find . -maxdepth 1 -type d -print | xargs du -sk | sort -rn"

# setting up $PATH
alias PATH="$HOME/bin:$PATH"


#
#   Prompt
#
RESET="\[\017\]"
NORMAL="\[\033[0m\]"
RED="\[\033[31;1m\]"
YELLOW="\[\033[33;1m\]"
WHITE="\[\033[37;1m\]"
SMILEY="${WHITE}:)${NORMAL}"
FROWNY="${RED}:(${NORMAL}"
SELECT="if [ \$? = 0 ]; then echo \"${SMILEY}\"; else echo \"${FROWNY}\"; fi"

# Throw it all together 
PS1="${RESET}${YELLOW}\h${NORMAL} \`${SELECT}\` ${YELLOW}>${NORMAL} "

# man page setting
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'


# functions script

## move up 
up(){
    local d=""
    limit=$1
    for ((i=1 ; i <= limit ; i++))
    do
        d=$d/..
    done
    d=$(echo $d | sed 's/^\///')
    if [ -z "$d" ]; then
        d=..
    fi
    cd $d
}

## extract file
extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1    ;;
            *.tar.gz)    tar xvzf $1    ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar x $1       ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xvf $1     ;;
            *.tbz2)      tar xvjf $1    ;;
            *.tgz)       tar xvzf $1    ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "don't know how to extract '$1'..." ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

install_Vundle() {
	if [ -e ~/.vimrc ]; then mv ~/.vimrc ~/.vimrc_bak; fi
	if [ -e ~/.vim ]; then mv ~/.vim ~/.vim_bak; fi

	git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

	echo "set nocompatible" >> ~/.vimrc
	echo "filetype off" >> ~/.vimrc
	echo "set rtp+=~/.vim/bundle/vundle/" >> ~/.vimrc
	echo "call vundle#rc()" >> ~/.vimrc
	echo "Plugin 'gmarik/vundle'" >> ~/.vimrc
	echo "Plugin 'scrooloose/nerdtree.git'" >> ~/.vimrc
	echo "Plugin 'scrooloose/syntastic.git'" >> ~/.vimrc
	echo "Plugin 'Buffergator'" >> ~/.vimrc
	echo "filetype plugin indent on" >> ~/.vimrc
}

install_nerdtree() {
    # pathongen install
    mkdir -p ~/.vim/autoload ~/.vim/bundle
    curl -LSso ~/.vim/autoload/pathogen.vim https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim 

    #nerdtree install
    cd ~/.vim/bundle
    git clone https://github.com/scrooloose/nerdtree
    echo "type :Helptags or :help NERD_tree.txt"
}

export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'
