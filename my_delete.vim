"if !exists(v:true) | echo join([1, 3], ';') | endif

"echo s:last_col_of_line

"call setpos('.', [0,6,7,0])

"echo getline('.')[col('.') - 1]
"echo "--------------------"
"get char under cursor
"echo strcharpart(getline('.')[col('.') - 1:], 0, 1)
"echo "--------------------"
"echo col('.')
"echo getline('.')

" xxx"
"<"
" "xx*xx"12""
"3"

function! s:IsClose(symbol_left, symbol)
    if a:symbol_left == "(" && a:symbol == ")"
        return 1
    elseif a:symbol_left == "<" && a:symbol == ">"
        return 1
    elseif a:symbol_left == "[" && a:symbol == "]"
        return 1
    else
        return 0
    endif
endfunc

function! s:MatchChar(symbol)
    if a:symbol =~ "\"" || a:symbol =~ "\'" || a:symbol =~ "\`"
        return [1, a:symbol]
    elseif a:symbol =~ "<" || a:symbol =~ "[" || a:symbol =~ "("
        return [2, a:symbol]
    elseif a:symbol =~ ">" || a:symbol =~ "]" || a:symbol =~ ")"
        return [3, a:symbol]
    else
        return [0]
    endif
endfunc
"echo s:MatchChar('(')

"se(t(setsetl<3[ccc]33>sl)xd*fs)d<sdfsf>33f"
function! s:FindLeft() "HHHHHHHHHHH
    "排除光标在第一个字符的情况
    if search("[\"`'(<[]", 'nb', line(".")) == 0 | return 1 | endif
    let l:same_count = 0
    for l:index in range(s:col - 1, 1, -1)
        let l:symbol = strcharpart(getline('.')[l:index - 1:], 0, 1)
        let l:match_return = s:MatchChar(l:symbol)

        "\"\'\`
        if l:match_return[0] == 1 | return l:match_return[1] | endif
        "<([
        if l:match_return[0] == 2
            if l:same_count == 0 
                return l:match_return[1]
            else
                let l:same_count -= 1
            endif
        ">)]
        elseif l:match_return[0] == 3
            let l:same_count += 1
        endif
    endfor
endfunc
"/////////////////////////////////
function! s:FindRight(symbol_left)
    "echo "enter find_right"
    if a:symbol_left == "\"" || a:symbol_left == "\'" || a:symbol_left == "\`"
        for l:index in range(s:col, s:last_col_of_line, 1)
            let s:symbol_right = strcharpart(getline('.')[l:index - 1:], 0, 1)
            if s:symbol_right == a:symbol_left
                let l:delete_length = l:index - s:col
                execute "normal " . printf("%dx", l:delete_length)
                break
            endif
        endfor
    else
        let l:same_count = 0
        for l:index in range(s:col, s:last_col_of_line, 1)
            let s:symbol_right = strcharpart(getline('.')[l:index - 1:], 0, 1)
            if s:symbol_right == a:symbol_left
                let l:same_count += 1
            else
                " ((333))
                " <<11<aaa<333>>>>
                " [11[aa[bb[cc]]]]
                if s:IsClose(a:symbol_left, s:symbol_right) == 1
                    if l:same_count == 0
                        let l:delete_length = l:index - s:col
                        "execute "normal " . printf("%dx", l:delete_length)
                        execute "normal " . l:delete_length . "x"
                        break
                    else
                        let l:same_count -= 1
                    endif
                endif
            endif
        endfor
    endif
endfunc

function! s:MyDelete()
    let s:curpos = getpos('.')
    let s:row = s:curpos[1]
    let s:col = s:curpos[2]
    "echo s:curpos
    "echo s:row s:col
    let s:last_col_of_line = len(getline('.'))
    let l:symbol_left = s:FindLeft()
    if l:symbol_left != 1
        "echo "find_left return" . l:symbol_left
        call s:FindRight(l:symbol_left)
    endif
endfunc


"command -nargs=1  MyDelete  :call s:MyDelete(<q-args>, 0)
"if !exists(":MyDelete")
  "command -nargs=0 MyDelete :call s:MyDelete()
"endif

nnoremap <Plug>Mydelete :call <SID>MyDelete()<CR>
if !hasmapto('<Plug>Mydelete')
  nmap <silent> <Leader>md <Plug>Mydelete
endif

"echo ("--------------------")
"echo '--------------------'
"echo `--------------------`
