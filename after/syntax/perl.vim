" Highlight trailing whitespace
syn match TrailingWhitespace /\s\+$/
highlight TrailingWhitespace ctermbg=red guibg=red

" Fix syntax highlighting in modules with inline POD
syntax sync fromstart
