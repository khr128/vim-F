# 'F' is for 'Find'

A vim plugin to find patterns in files.

## Usage

Patterns can be found in the current file only or recursively in all files in the current directory.

## Install

    cd ~/.vim/bundle
    git clone https://github.com/khr128/vim-F.git

## Prerequisites

- find
- gawk

##Commands

- `:Fg [vim-regex]` 
  - Without arguments, find all occurencies of the word under cursor in the current file.
  - With one argument, find all occurencies of `vim-regex` in the current file.
- `:Ff [find-filename-regex] [gawk-text-regex]` 
  - Without arguments, recursively find all occurencies of the word under cursor in
    all files with the same extension as the current file in the current directory and its subdirectories.
  - With one argument, recursively find all occurencies of the word under cursor in
    all files that match `find-filename-regex` in the current directory and its subdirectories.
  - With two arguments, recursively find all occurencies of the word that matches `gawk-text-regex` in
    all files that match `find-filename-regex` in the current directory and its subdirectories.

