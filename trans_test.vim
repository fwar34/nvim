if !exists(v:true) | echo join([1, 3], ';') | endif

" ((s*ss(123)))
" "xx*xx"123""

let s:curpos = getpos('.')
echo s:curpos
let s:curpos2 = getcurpos()
echo s:curpos2
