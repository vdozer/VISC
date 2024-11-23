#
# ~/.bashrc
#

#If not running interactively, dont do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1="\[\e[31m\]\u\[\e[32m\]@\[\e[33m\]\h \[\e[34m\]\w \[\e[35m\]\\$\[\e[0m\] "
