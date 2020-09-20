let g:projectionist_heuristics = {
      \   "*": {
      \     "lib/*.js": {
      \       "alternate": [
      \         "tests/{}.test.js"
      \       ],
      \       "type": "source"
      \     },
      \     "tests/*.test.js": {
      \       "alternate": [
      \         "lib/{}.js"
      \       ],
      \       "type": "test"
      \     },
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
      \     },
      \     "test/*.sql": {
      \       "alternate": [
      \         "deploy/{}.sql"
      \       ],
      \       "type": "test",
      \       "template": [
      \         "BEGIN;",
      \         "",
      \         "/* SELECT plan(1); */",
      \         "SELECT * FROM no_plan();",
      \         "",
      \         "/*****************************************************************************/",
      \         "-- Basic test",
      \         "",
      \         "SELECT ok(true);",
      \         "",
      \         "/*****************************************************************************/",
      \         "-- Finish",
      \         "",
      \         "SELECT * FROM finish();",
      \         "",
      \         "ROLLBACK;",
      \       ]
      \     }
      \   }
      \ }
