function! s:mytest()
lua << LUA

    for k, v in pairs(package.loaded) do
        print(k, v)
    end

    for s in package.path:gmatch("[^;]+") do
        print(s)
    end

    -- local ffi = require 'ffi'
    -- local C = ffi.C
    -- ffi.cdef[[ uint64_t mach_absolute_time(); ]]

    -- require('vim')
    oldpath = package.path
    package.path = vim.eval('expand("<sfile>:h")') .. '/?.lua'
    print("---------------------------")
    print(oldpath)
    print("---------------------------")
    print(package.path)

LUA
endfunc

call s:mytest()
