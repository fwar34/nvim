"=========================================
"  Author: liang.feng
"  Version: 1
"  Date: Fri Mar  8 12:55:27 CST 2019
"  Sections: neovim ginit.vim (It is always sourced after the |init.vim|)
"=========================================

"--------------------------------------------------------------------------
" Font settings
"--------------------------------------------------------------------------
if hostname() == "A12839" || hostname() == "FENG"
    GuiFont! Courier\ New:h12:cANSI
else
    if has('win32')
        "Guifont Fira\ Code:h12
        "GuiFont! Courier\ New:h12:cANSI
        "set guifont=DejaVu\ Sans\ Mono:h12
        "GuiFont! Consolas:h12:cANSI
        GuiFont! Hack:h12:cANSI
    else
        "Guifont Fira Code:h14:cANSI
        "Guifont DejaVu Sans Mono:h12
        Guifont JetBrains Mono:h11:cANSI
    endif
endif

"turn off the GUI tabline
GuiTabline 0
"reduce line space
GuiLinespace 1

set mouse=a

" 全屏nvim
if hostname() == "DESKTOP-LL8PBC8"
    set lines=40 columns=130
else
    call GuiWindowMaximized(1)
endif
"call GuiWindowFullScreen(1) 
