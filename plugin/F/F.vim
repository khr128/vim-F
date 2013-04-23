" File:         F.vim
" Author:       Dmitri Khrebtukov (khr128@gmail.com)
" Version:      0.1
" Description:  F.vim is for 'Find'
" Last Modified: April 22, 2013

if exists("g:f_is_for_find_loaded")
    finish
endif
let g:f_is_for_find_loaded = 1

function! s:ShowInQuickFix(lines, format)
    " write quickfix errors to a temp file
    let l:quickfix_tmpfile_name = tempname()
    exe "redir! > " . l:quickfix_tmpfile_name
    silent echon a:lines
    redir END
    " read in the errors temp file
    let l:efm = &efm
    exe 'set efm='.a:format
    execute "silent! cfile " . l:quickfix_tmpfile_name
    let &efm = l:efm

    " open the quicfix window
    botright copen
    let s:qfix_win = bufnr("$")

    " delete the temp file
    call delete(l:quickfix_tmpfile_name)
endfunction

command! -nargs=* Ff call <SID>Ff(<f-args>)
function! s:Ff(...)
  if a:0 == 2
    let l:file_regex = a:1
    let l:content_match = a:2
  elseif a:0 == 1
    let l:file_regex = a:1
    let l:content_match = expand("<cword>")
  else
    let l:file_regex = '.*.' . expand('%:e')
    let l:content_match = expand("<cword>")
  endif
  let l:cmd_output = system('find -E . -type f -regex "'.l:file_regex.'" -exec gawk "BEGIN{c=0}; /'.l:content_match.'/ {printf \"%s %d %s\n\", FILENAME, FNR, \$0; c += 1}; END{print c}" {} +')
  if strlen(l:cmd_output) > 0
    call s:ShowInQuickFix(l:cmd_output, '%f\ %l\ %m')
  endif
endfunction

command! -nargs=? Fg call <SID>Fg(<f-args>)
function! s:Fg(...)
  redir => l:current_file_name
  silent echo expand('%:p')
  redir END

  if a:0 > 0
    let l:word_under_cursor = a:1
  else
    let l:word_under_cursor = expand("<cword>")
  endif

  redir => l:cmd_output
  exe 'silent g/'.l:word_under_cursor.'/nu'
  redir END

  let l:result_list = split(l:cmd_output, '\n')
  call map(l:result_list, 'substitute(v:val, "^\\s\\+", "", "")')
  call map(l:result_list, 'l:current_file_name . " " . v:val')
  let l:cmd_output = join(l:result_list, '\n')

  if strlen(l:cmd_output) > 0
    call s:ShowInQuickFix(l:cmd_output, '%f\ %l\ %m')
  endif
endfunction
