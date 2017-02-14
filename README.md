# syntastic-local-eslint.vim
For each buffer use all the javascript checkers from node_modules of the project

1. Read `g:syntastic_javascript_checkers` (For example, `['eslint', 'flow']`)
2. For each checker find the executable in `node_modules` (If not found, show an error)
3. For each checker set `b:syntastic_javascript_(checkername)_exec` to the path found
