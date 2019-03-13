if !exists(v:true) | echo join([1, 3], ';') | endif

let s:curpos = getpos('.')
let s:row = s:curpos[1]
let s:col = s:curpos[2]
echo s:curpos
echo s:row s:col
"call setpos('.', [0,6,7,0])

"echo getline('.')[col('.') - 1]
"echo "--------------------"
"get char under cursor
"echo strcharpart(getline('.')[col('.') - 1:], 0, 1)
"echo "--------------------"
"echo col('.')
"echo getline('.')

" ((s23)))
" "xx*xx"123""
echo "--------------------"

function s:match(symbol)
    if a:symbol == "\"" || a:symbol == "\'" || a:symbol == "\`" || a:symbol == "<" || a:symbol == "[" || s:symbol == "("
            return 1
        else
            return 0
        endif
    endif
endfunc

for s:index in range(s:col, 0, -1)
    let s:symbol = strcharpart(getline('.')[s:index - 1:], 0, 1)
    echo s:symbol
    "if s:index == 3 | break | endif
    "if s:symbol == '\"' || s:symbol == '\'' || s:symbol = '<' || s:symbol = '(' || s:symbol = '['
    "if s:symbol != '-' | break | endif
    if s:symbol == "\"" || s:symbol == "\'" || s:symbol == "\`" || s:symbol == "<" 
        break
    endif
endfor

echo "--------------------"
echo s:index 
echo s:symbol
