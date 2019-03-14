if !exists(v:true) | echo join([1, 3], ';') | endif

"echo s:last_col_of_line

"call setpos('.', [0,6,7,0])

"echo getline('.')[col('.') - 1]
"echo "--------------------"
"get char under cursor
"echo strcharpart(getline('.')[col('.') - 1:], 0, 1)
"echo "--------------------"
"echo col('.')
"echo getline('.')

" "xx*xx"123""
echo "--------------------"

function! s:match_char(a:symbol)
    if a:symbol == "\""
        return "\""
    elseif a:symbol == "\'"
        return "\'"
    elseif a:symbol == "\`"
        return "\`"
    elseif a:symbol == "<"
        return "<"
    elseif a:symbol == "["
        return "["
    elseif s:symbol == "("
        return "("
    else
        return 1
    endif
endfunc

function! s:is_close(a:symbol)
    if s:match_return == "(" && a:symbol == ")"
        return 1
    elseif s:match_return == "<" && a:symbol == ">"
        return 1
    elseif s:match_return == "[" && a:symbol == "]"
        return 1
    else
        return 0
    endif
endfunc

function! s:find_left()
    for l:index in range(s:col, 1, -1)
        "get char under the cursor
        let s:symbol = strcharpart(getline('.')[l:index - 1:], 0, 1)
        let s:match_return = s:match_char(s:symbol)
        if s:match_return != 1
            break
        endif
    endfor
endfunc

function! s:find_right()
    echo "enter find_right"
    if s:match_return == "\"" || s:match_result == "\'" || s:match_result == "\`"
        for l:index in range(s:col, s:last_col_of_line, 1)
            let s:symbol_right = strcharpart(getline('.')[l:index - 1:], 0, 1)
            if s:symbol_right == s:match_return
                let l:delete_length = l:index - s:col
                execute "normal " . printf("%dx", l:delete_length)
                echo "findit"
                break
            endif
        endfor
    else
        let l:same_count = 0
        for l:index in range(s:col, s:last_col_of_line, 1)
            let s:symbol_right = strcharpart(getline('.')[l:index - 1:], 0, 1)
            if s:symbol_right == s:match_return
                let l:same_count += 1
            else
                " (333*(s23)))
                if s:is_close(s:symbol_right) == 1
        endfor
    endif
endfunc

function! s:my_delete()
    let s:curpos = getpos('.')
    let s:row = s:curpos[1]
    let s:col = s:curpos[2]
    "echo s:curpos
    "echo s:row s:col
    let s:last_col_of_line = len(getline('.'))
    call s:find_left()
    if s:match_return != 1
        echo "find_left return" . s:match_return
        call s:find_right()
    endif
endfunc

call s:my_delete()

echo "--------------------"
echo '--------------------'
"echo `--------------------`
echo s:symbol

