# vimfiles
My ~/.vim directory. All hail vim.

# Installation
Plugins incorporated with `git submodule`. Use the `--recursive` option when
cloning this repository.

```bash
git clone --recursive https://github.com/kwakwaversal/vimfiles.git ~/.vim
```

Set up a symbolic link to this repository's `vimrc` file if using an older
version of vim. (Newer versions pick up the existence of the `.vim` folder and
contained `vimrc` file.)

```bash
ln -s ~/.vim/vimrc ~/.vimrc
```

If a vim plugin has been added after you cloned this repository, you need to
reinitialise the git submodules and update them.

```bash
git submodule update --init
```

# Environment
My environment consists of [Terminator], using the
[Powerline font][Powerline fonts] `Liberation Mono for Powerline`.

# Vim plugins
[Pathogen] is used as the plugin manager of choice.

* [vim-tmux](https://github.com/junegunn/fzf.vim#commands)

# References
* [Faster and more natural splits](https://robots.thoughtbot.com/vim-splits-move-faster-and-more-naturally)
* [tmux and vim](https://blog.bugsnag.com/tmux-and-vim/) productivity gains
    shortcuts to move effortlessly between vim and tmux splits and panes, using
    the vimux plugin and more.
* [Using tab pages](http://vim.wikia.com/wiki/Using_tab_pages)
* [Vim tips and tricks](https://www.cs.swarthmore.edu/help/vim/home.html)
    contains useful tips on reformatting text.

[Pathogen]: https://github.com/tpope/vim-pathogen
[Powerline fonts]: https://github.com/powerline/fonts
[Terminator]: https://gnometerminator.blogspot.co.uk/p/introduction.html
