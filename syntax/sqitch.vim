" :echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
syn match date / [0-9TZ:-]* /
syn match sqitchname /^[A-Za-z_\/.]*/
syn match tagchange /\[.*\]/
syn match commentline /#.*$/
syn match sqitchtagline /^@.*$/

hi def link date Constant
hi def link sqitchname Identifier
hi def link tagchange Type
hi def link commentline Comment
hi def link sqitchtagline Operator
