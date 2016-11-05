" === plugin configuration variables === {{{
" name of the script with user commands
let g:vim_do_something_name = '.vimdo'
" command prefix
let g:vim_do_something_prefix = '/bin/sh '
" is command silent
let g:vim_do_something_silent = 1
" }}}

function! DoSomethingGetExe()
  if g:vim_do_something_name == expand('%')
    return
  endif
  let l:exe_path = expand('%:p:h')
  let l:exe_file = l:exe_path . '/' . g:vim_do_something_name
  let l:found_exe = ''
  if filereadable(l:exe_file)
    let l:found_exe = l:exe_file
  else
    while !filereadable(l:exe_file)
      let slashindex = strridx(l:exe_path, '/')
      if slashindex >= 0
        let l:exe_path = l:exe_path[0:slashindex]
        let l:exe_file = l:exe_path . g:vim_do_something_name
        let l:exe_path = l:exe_path[0:slashindex-1]
        if filereadable(l:exe_file)
          let l:found_exe = l:exe_file
          break
        endif
        if slashindex == 0 && !filereadable(l:exe_file)
          break
        endif
      else
        break
      endif
    endwhile
  endif
  return l:found_exe
endfunction

function! DoSomethingExe(...)
  let exe = DoSomethingGetExe()
  if !empty(exe)
    if len(a:000)
      let l:message = join(a:000, ' ')
    else
      let l:message = ''
    endif
    let l:cmd = printf("%s %s %s", g:vim_do_something_prefix, exe, l:message)
    "echoerr 'Command ' . l:cmd
    if g:vim_do_something_silent
      execute '!' . l:cmd
    else
      execute '!' . l:cmd
    endif
  else
    echoerr 'There is no ' . g:vim_do_something_name
  endif
endfunction

"
"nmap <leader>su :call DoSomethingExe('upload')<CR>
"nmap <leader>sd :call DoSomethingExe('download')<CR>
"