# vimfiles
My ~/.vim directory. All hail vim.

# Installation
Plugins are managed using the [Pathogen] plugin manager and tracked using `git
submodule` . Use the `--recursive` option when cloning this repository to
automatically download and install them.

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

## [coc.vim](https://github.com/neoclide/coc.nvim)

The plugin coc.vim requires additional configuration. The below is entered
directly from within `vim` itself.

```
:call coc#util#install()
:CocInstall coc-tsserver coc-eslint coc-json coc-prettier
```

## [copilot](https://github.com/github/copilot)

Only works with neovim. Install the plugin using the following command:

```bash
git clone https://github.com/github/copilot.vim.git ~/.config/nvim/pack/github/start/copilot.vim
```

Then, run the following command in neovim:

```bash
:Copilot setup
```

# Updating vim

Update/install the latest version of vim (optionally with clipboard support).

```console
apt-get install libx11-dev libxt-dev libperl-dev ncurses-dev python python-dev
git clone --depth 1 https://github.com/vim/vim
# python3
./configure --disable-gui --enable-perlinterp --enable-python3interp=yes --with-features=huge --with-compiledby=inside --with-x
# python2
./configure --disable-gui --enable-perlinterp --enable-pythoninterp=yes --with-features=huge --with-compiledby=inside --with-x
make -j8
make install
```

Alternatively see https://github.com/jjangsangy/Dotfiles/wiki/Debian-Vim for
more complete instructions.

# Environment
My environment consists of [Terminator], using the [Powerline font][Powerline
fonts] `Liberation Mono for Powerline`.

# Vim plugins
[Pathogen] is used as the plugin manager of choice.

* [ack-vim](https://github.com/mileszs/ack.vim) searching files
* [solarized](https://github.com/altercation/vim-colors-solarized) colour scheme
* [vim-airline](https://github.com/vim-airline/vim-airline) status/tabline
* [vim-airline-themes](https://github.com/vim-airline/vim-airline-themes) airline themes
* [vim-commentary](https://github.com/tpope/vim-commentary) comment stuff out
* [vim-cucumber](https://github.com/tpope/vim-cucumber) cucumber indentation, highlighting etc.
* [vim-dockerfile](https://github.com/ekalinin/Dockerfile.vim) syntax highlighting for Dockerfiles
* [vim-expand-region](https://github.com/terryma/vim-expand-region) quickly expand visual selection
* [vim-fugitive-gitlab](https://github.com/shumphrey/fugitive-gitlab.vim) fugitive+gitlab integration
* [vim-fugitive](https://github.com/tpope/vim-fugitive) git wrapper
* [vim-fzf](https://github.com/junegunn/fzf.vim#commands) finding files
* [vim-javascript](https://github.com/pangloss/vim-javascript) Vastly improved Javascript indentation and syntax support in Vim
* [vim-gitgutter](https://github.com/airblade/vim-gitgutter) git line diffs in the "gutter"
* [vim-pgsql](https://github.com/exu/pgsql.vim) Vim Postgresql syntax file
* [vim-perl](https://github.com/vim-perl/vim-perl) perl 5 and 6 support
* [vim-projectionist](https://github.com/tpope/vim-projectionist.git) cycle between related files
* [vim-repeat](https://github.com/tpope/vim-repeat) add vim repeat feature to extra plugins (e.g., surround)
* [vim-surround](https://github.com/tpope/vim-surround) manipulate surroundings in pairs
* [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) navigate between vim and tmux splits
* [vim-typescript](https://github.com/leafgarland/typescript-vim) syntax files for typescript
* [vim-unimpaired](https://github.com/tpope/vim-unimpaired) helpful mappings
* [vimux](https://github.com/benmills/vimux) interact with tmux from vim

Removed

* [salt-vim](https://github.com/saltstack/salt-vim) working on [SaltStack] files

## Adding a new plugin
The Vim plugins are managed using `git submodule`.

```bash
git submodule add https://github.com/vim-perl/vim-perl.git bundle/vim-perl
```

## Initializing plugins
When using these `vimfiles` from multiple machines, git submodules might be
added in a commit from another machine so might need to be initialized.

```bash
git submodule init
git submodule update
```

## Updating plugins
In the master branch, recursively update all plugins to the latest version.

```bash
git submodule update --init --recursive
git submodule foreach --recursive git fetch
git submodule foreach git pull --ff-only origin master
```

## Resetting plugins
If you've updated some plugins and they're causing issues or you don't want to
commit the updated version you can reset them:

```bash
git submodule update --init
git submodule update --init vim-ultisnips
```

## Removing plugins

```bash
git submodule deinit -f -- bundle/vim-powerline
git rm --cached bundle/vim-powerline
```

See [https://stackoverflow.com/questions/10168449/git-update-submodule-recursive]
for more information.

# neovim

```
pip3 install --upgrade pip
pip3 install --user neovim
mkdir ~/.vim/tmp
```

Install `makedeb` and build `neovim` package.

```
# If you're running in a noninteractive environment (such as in CI or on a server), change `-ci` to `-c`.
bash -ci "$(wget -qO - 'https://shlink.makedeb.org/install')"

sudo apt install cmake
git clone https://mpr.makedeb.org/neovim
cd neovim/
makedeb -si
```

```
# ~/.config/nvim/init.vim
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vim/vimrc
set viminfo='10,\"100,:20,%,n~/.nviminfo
```

See: https://github.com/deoplete-plugins/deoplete-jedi/wiki/Setting-up-Python-for-Neovim#using-virtual-environments

# References
* [Faster and more natural splits](https://robots.thoughtbot.com/vim-splits-move-faster-and-more-naturally)
* [Guide to modern web development with neovim](https://medium.freecodecamp.org/a-guide-to-modern-web-development-with-neo-vim-333f7efbf8e2)
* [How to boost your vim productivity](https://github.com/sheerun/blog/blob/master/_posts/2014-03-21-how-to-boost-your-vim-productivity.markdown)
* [tmux and vim](https://blog.bugsnag.com/tmux-and-vim/) productivity gains
    shortcuts to move effortlessly between vim and tmux splits and panes, using
    the vimux plugin and more.
* [Using tab pages](http://vim.wikia.com/wiki/Using_tab_pages)
* [Vim foldding](https://medium.com/vim-drops/javascript-folding-on-vim-119c70d2e872)
* [Vim genius](http://www.vimgenius.com/) online flashcard-style vim game
* [Vim tips and tricks](https://www.cs.swarthmore.edu/help/vim/home.html)
    contains useful tips on reformatting text.

[Pathogen]: https://github.com/tpope/vim-pathogen
[Powerline fonts]: https://github.com/powerline/fonts
[SaltStack]: https://saltstack.com/
[Terminator]: https://gnometerminator.blogspot.co.uk/p/introduction.html
