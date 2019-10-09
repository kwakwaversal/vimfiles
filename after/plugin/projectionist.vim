let g:projectionist_heuristics = {
      \   "*": {
      \     "deploy/*.sql": {
      \       "alternate": [
      \         "revert/{}.sql"
      \       ],
      \       "type": "deploy"
      \     },
      \     "revert/*.sql": {
      \       "alternate": [
      \         "verify/{}.sql"
      \       ],
      \       "type": "revert"
      \     },
      \     "verify/*.sql": {
      \       "alternate": [
      \         "deploy/{}.sql"
      \       ],
      \       "type": "verify"
      \     }
      \   }
      \ }
