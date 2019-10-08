# Movement
Move around the file. TMTOWTDI!

See `:h word-motions`.

# File/buffer
* `<S-g>` bottom
* `1<S-g>`, `gg` top
* `100<S-g>`, `100gg`, `:100` go to 100th line
* `6<C-E>` down 6 lines
* `5<C-D>` down 5 lines - repeat <C-D> to keep moving 5 lines

# Lines
* `<Home>`, `0` move to the start of the line
* `_` move to first non-whitespace character of the line
* `<End>`, `$` move to the end of the line
* `f{char}` move cursor and place on `{char}`
* `t{char}` move cursor and place to left of `{char}`

# Marks
* `'<` & `'>` start/end of visual selection
* `'[` & `']` start/end of last change or yank
* `'.` position of where last change was made
* `'^' position of cursor when vim last left insert mode - this is how `gi`
  command works
* `''` position before last jump (super useful) see `:h ''`

# Match
* `%` { match } [ parenthesis ] < and brackets >
* `[{` jump to the beginning of a C code block (while, switch, if etc)
* `]}` jump to the end of a C code block (while, switch, if etc)
* `[(` jump to the beginning of a parenthesis
* `])` jump to the end of a parenthesis

# Misc
* `gd` will take you to the local variable declaration under cursor
* `gD` will take you to the global variable declaration undef cursor

# Paragraphs
* `{`, `1{` move to the first line of previous paragraph
* `}`, `1}` move to the first line after next paragraph

# Search
* `/searchterm` search forward
* `?searchterm` search backward
* `n` / `N` next, back
* `C-O` older positions
* `C-I` newer positions

# Splits
* `<C-#>` toggle cursor between last window splits

# Window (the part of the window you see)
* `H` top, `10H` 10 from top
* `M` middle,
* `L` bottom, `5L` 5 from bottom

# Words
* `w`, `W` move forward a word / long-connected-word
* `b`, `B` move backwards a word / long-connected-word
* `e`, `E` move forward to the end of a word / long-connected-word
* `ge`, `gE` move backwards to the end of a word / long-connected-word
