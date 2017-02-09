" TODO check if syntastic installed
let s:lcd = fnameescape(getcwd())
silent! exec "lcd" expand('%:p:h')

let s:local_eslint = finddir('node_modules', '.;') . '/.bin/eslint'

" if the found path is relative
if matchstr(s:local_eslint, "^\/\\w") == ''
  let s:local_eslint = fnameescape(getcwd()) . "/" . s:local_eslint
endif

if executable(s:local_eslint)
  let b:syntastic_javascript_eslint_exec = s:local_eslint
else
  echoerr 'no local eslint found'
endif

exec "lcd" s:lcd
