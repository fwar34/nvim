"=========================================
"  Author: liang.feng
"  Version: 1
"  Date: Fri Mar  8 12:55:27 CST 2019
"  Sections: neovim ginit.vim (It is always sourced after the |init.vim|)
"=========================================

"--------------------------------------------------------------------------
" Font settings
"--------------------------------------------------------------------------
if has('win32') && (hostname() == "A12839" || hostname() == "FENG")
    GuiFont! Courier\ New:h12:cANSI
else
    "Guifont Fira\ Code:h12
    GuiFont! Courier\ New:h12:cANSI
    "set guifont=DejaVu\ Sans\ Mono:h12
endif

"turn off the GUI tabline
GuiTabline 0
"reduce line space
GuiLinespace 1

" 全屏nvim
call GuiWindowMaximized(1)
