"" @see http://stackoverflow.com/questions/18807349/a-reduce-function-in-vim-script
fun! s:Reduce(funcname, list, acc)
    let l:F = function(a:funcname)
    let l:acc = a:acc
    for l:value in a:list[:]
        let l:acc = l:F(l:acc, l:value)
    endfor
    return l:acc
endfun

fun! s:GetNodeModulesAbsPath ()
  let lcd_saved = fnameescape(getcwd())
  silent! exec "lcd" expand('%:p:h')
  let l:node_modules_path = finddir('node_modules', '.;')
  exec "lcd" lcd_saved

  " if the found path is relative
  if matchstr(l:node_modules_path, "^\/\\w") == ''
    return fnameescape(getcwd()) . "/" . l:node_modules_path
  else
    return l:node_modules_path
  endif
endfun

" syntastic_checker[]
" -> s:DescribeLocalChecker(acc_dict, checker)
" -> {'eslint': s:GetLocalBin('eslint'), 'flow': s:GetLocalBin('flow')}
" -> for checker in dict do SetChecker(checker, dict.checker)

let s:node_modules_path = s:GetNodeModulesAbsPath()

fun! s:GetLocalBin (checker)
  let l:checker_bin =  s:node_modules_path . '/.bin/' . a:checker
  return executable(l:checker_bin) ? l:checker_bin : ''
endfun

fun! s:DescribeLocalChecker (acc, checker)
  let l:acc = a:acc
  let l:checker_bin = s:GetLocalBin(a:checker)
  let l:acc[a:checker] = l:checker_bin
  return l:acc
endfun

fun! s:SetCheckers (checkers)
  for [l:name, l:bin] in items(a:checkers)
    if l:bin !=# ''
      exec 'let b:syntastic_javascript_' . l:name . '_exec = "' . l:bin . '"'
    else
      echoerr 'Javascript checkers: no local ' . l:name . ' found'
    endif
  endfor
endfun

fun! s:Main ()
  let checker_names = get(g:, 'syntastic_javascript_checkers', [])
  let checkers = s:Reduce('s:DescribeLocalChecker', checker_names, {})
  call s:SetCheckers(checkers)
endfun

call s:Main()
