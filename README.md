# vimfiles
My ~/.vim directory. All hail vim.

# Installation
Plugins incorporated with `git submodule`. Use the `--recursive` option when
cloning this repository.

```bash
git clone --recursive git@github.com:kwakwaversal/vimfiles.git ~/.vim
```

Set up a symbolic link to this repository's `vimrc` file.

```bash
ln -s ~/.vim/vimrc ~/.vimrc
```

If a vim plugin has been added after you cloned this repository, you need to
reinitialise the git submodules and update them.

```bash
git submodule init
git submodule update
```

# References
* [Faster and more natural splits](https://robots.thoughtbot.com/vim-splits-move-faster-and-more-naturally)
* [tmux and vim](https://blog.bugsnag.com/tmux-and-vim/) productivity gains
    shortcuts to move effortlessly between vim and tmux splits and panes, using
    the vimux plugin and more.
* [Using tab pages](http://vim.wikia.com/wiki/Using_tab_pages)
* [Vim tips and tricks](https://www.cs.swarthmore.edu/help/vim/home.html)
    contains useful tips on reformatting text.
