"=========================================
"  Author: liang.feng
"  Version: 1
"  Date: Fri Mar  8 12:55:27 CST 2019
"  Sections: neovim ginit.vim (It is always sourced after the |init.vim|)
"=========================================

"--------------------------------------------------------------------------
" Font settings
"--------------------------------------------------------------------------
if has('nvim')
    if has('win32')
        "set guifont=Courier\ New:h12:cANSI
        GuiFont! Courier\ New:h12:cANSI
        "GuiFont! Consolas:h12
    elseif has('unix')
        "set guifont=Fira\ Code:h14
        "Guifont Fira\ Code:h14
        "set guifont=DejaVu\ Sans\ Mono:h11
        "set linespace=4
    endif
endif

if has('nvim')
    "turn off the GUI tabline
    GuiTabline 0
    "reduce line space
    GuiLinespace 1
endif

" 全屏nvim
if has('nvim')
    call GuiWindowMaximized(1)
    "let g:GuiWindowFullScreen=1
    "if exists('g:Gui')
        "echom xxxxxx
    "endif
endif

