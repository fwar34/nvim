"=========================================
"  Author: liang.feng
"  Version: 1
"  Date: 2018-03-27 15:53
"  Sections:
"=========================================

"--------------------------------------------------------------------------
"一些使用记录
":verbose nmap <C-i> 看是哪个插件映射的<C-i>
":reg
"--------------------------------------------------------------------------

"--------------------------------------------------------------------------
" 一些检测函数 
"--------------------------------------------------------------------------
function! s:read_total_memory()
    if isdirectory("/proc")
        let s:line = readfile("/proc/meminfo")
        let s:memory = split(s:line[0])
        let s:memory_enough = s:memory[1] > 1000000
    else
        let s:memory_enough = 1
    endif
endfunc

if has('win32')
    let s:memory_enough = 1
else
    call s:read_total_memory()
endif


"--------------------------------------------------------------------------
" 
"--------------------------------------------------------------------------
if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

if !has('nvim')
    set termwinsize=25*0
endif

" 启动全屏 win32 && vim
if has('win32') && !has('nvim')
    autocmd GUIEnter * simalt ~x

    "200~250
    if executable("vimtweak.dll") 
        autocmd guienter * call libcallnr("vimtweak", "SetAlpha", 250) 
    endif 

    let g:trans_num = 50
    function! Transparency()
        echo """"""
        call libcallnr("vimtweak", "SetAlpha", g:trans_num)
        if g:trans_num == 50
            let g:trans_num = 250
        elseif g:trans_num == 250
            let g:trans_num = 50
        endif
    endfunc

    nnoremap <Space>tt :call Transparency()<CR>

    "sets path for python3
    if isdirectory('C:\Users\feng\AppData\Local\Programs\Python\Python37-32')
        set pythonthreedll=C:\Users\feng\AppData\Local\Programs\Python\Python37-32\python37.dll
    elseif isdirectory('C:\Users\fwar3\AppData\Local\Programs\Python\Python36')
        set pythonthreedll=C:\Users\fwar3\AppData\Local\Programs\Python\Python36\python36.dll
    elseif isdirectory('C:\Users\liang.feng\AppData\Local\Programs\Python\Python36')
        set pythonthreedll=C:\Users\liang.feng\AppData\Local\Programs\Python\Python36\python36.dll
    elseif isdirectory('C:\Python37')
        set pythonthreedll=C:\Python37\python37.dll
    endif
endif

"if has("termguicolors")
    "fix bug for vim
    "set t_8f=[38;2;%lu;%lu;%lum
    "set t_8b=[48;2;%lu;%lu;%lum
    "enable true color
    "set termguicolors
"endif

" 可以在buffer的任何地方使用鼠标（类似office中在工作区双击鼠标定位）
if has('gui_running') || has('nvim')
    set mouse=a
else
    set mouse=
endif

set autochdir 
" vim 自身命令行模式智能补全
set wildmenu
set nocompatible


"--------------------------------------------------------------------------
" 
"--------------------------------------------------------------------------
noremap! ;g <C-c>
vnoremap ;g <Esc>
vnoremap <C-g> <Esc>
nnoremap <Space><Space> :
nnoremap <silent> <Space>qq :q<CR>
nnoremap <silent> <Space>qm <C-z>
let mapleader = ";"
let g:mapleader = ";"


"--------------------------------------------------------------------------
" Plugins begin
"--------------------------------------------------------------------------
" set the runtime path to include Vundle and initialize
"if has('nvim')
    "call plug#begin('~/.config/nvim/plugged')
"else
    "call plug#begin('~/.vim/plugged')
"endif
call plug#begin('~/.vim/plugged')


"--------------------------------------------------------------------------
" asyncrun 
"--------------------------------------------------------------------------
Plug 'skywind3000/asyncrun.vim'
 
" 自动打开 quickfix window ，高度为 6
let g:asyncrun_open = 6
" 任务结束时候响铃提醒
let g:asyncrun_bell = 1
let g:asyncrun_rootmarks = ['.svn', '.git', '.root', '_darcs', 'build.xml'] 

nnoremap <Leader>vv :AsyncRun 
nnoremap <Leader>vt :AsyncStop<CR>
"然后在 AsyncRun 命令行中，用 <root> 或者 $(VIM_ROOT) 
"来表示项目所在路径，于是我们可以定义按 F7 编译整个项目
nnoremap <silent> <F7> :AsyncRun -cwd=<root> make <cr>
" 设置 <leader>ww 打开/关闭 Quickfix 窗口
nnoremap <silent> <Leader>ww :call asyncrun#quickfix_toggle(6)<CR>


"--------------------------------------------------------------------------
" 
"--------------------------------------------------------------------------
Plug 'terryma/vim-expand-region'


"--------------------------------------------------------------------------
" 
"--------------------------------------------------------------------------
if !(s:memory_enough)
    Plug 'rkulla/pydiction'
    let g:pydiction_location = '~/.vim/plugged/pydiction/complete-dict'
endif


"--------------------------------------------------------------------------
" 翻译
"--------------------------------------------------------------------------
"Plug 'ianva/vim-youdao-translater'
"vnoremap <silent> <C-y> :<C-u>Ydv<CR>
"nnoremap <silent> <C-y> :<C-u>Ydc<CR>
"noremap <leader>yd :<C-u>Yde<CR>


"--------------------------------------------------------------------------
" 翻译
"--------------------------------------------------------------------------
Plug 'iamcco/dict.vim'
"--普通模式下，<Leader>d 即可翻译光标下的文本，并在命令行回显
nmap <silent> <C-y> <Plug>DictSearch
"--可视化模式下，<Leader>d 即可翻译选中的文本，并在命令行回显
vmap <silent> <C-y> <Plug>DictVSearch
"--普通模式下，<Leader>w 即可翻译光标下的文本，并且在Dict新窗口显示
nmap <silent> <Leader>yd <Plug>DictWSearch
"--可视化模式下，<Leader>w 即可翻译选中的文本，并且在Dict新窗口显示
vmap <silent> <Leader>yd <Plug>DictWVSearch
nnoremap <Leader>yi :Dict 
nnoremap <Leader>yw :DictW 


"--------------------------------------------------------------------------
" 括号匹配 
"--------------------------------------------------------------------------
if (s:memory_enough)
    Plug 'vim-scripts/matchit.zip'
endif


"--------------------------------------------------------------------------
" This is a Vim plugin that provides Rust file detection, 
" syntax highlighting, formatting, Syntastic integration, and more.
"--------------------------------------------------------------------------
Plug 'rust-lang/rust.vim'


"--------------------------------------------------------------------------
" Racer support for Vim 
"--------------------------------------------------------------------------
Plug 'racer-rust/vim-racer'


"--------------------------------------------------------------------------
" 使用过 Sublime Text 的人应该都对 Sublime Text 中多点编辑功能爱不释手，
" 这个功能对于代码重构非常实用，如何在 Nvim 中使用类似的功能呢？可以借助于 
" vim-multiple-cursors 插件。
" 命令模式下，首先把光标移动到要重命名的变量处，然后开始按 Ctrl + N，
" 可以看到变量被高亮，继续按 Ctrl + N，变量下一个出现的地方被高亮显示，
" 如果要跳过某个位置该变量的出现（例如，字符串中也可能包含与该变量名相同的子字符串），
" 在该处被高亮以后，再按 Ctrl + X 取消即可，不断选中变量的出现位置，
" 直到所有想要选中的位置均选中完毕。 此时，按下 c（c 在 Nvim 中代表 *change*）,
" 进入编辑模式，输入变量新的名称，保存即可。更多使用方法，请参考该插件的文档。
"--------------------------------------------------------------------------
Plug 'terryma/vim-multiple-cursors'


"--------------------------------------------------------------------------
"  Vim plugin for clang-format, a formatter for C, C++, Obj-C, Java,
"  JavaScript, TypeScript and ProtoBuf. 
"
"  If you install vim-operator-user in advance, you can also map
"  <Plug>(operator-clang-format) to your favorite key bind.)
"
"  https://www.cnblogs.com/xuxm2007/p/8570686.html
"--------------------------------------------------------------------------
"Plug 'rhysd/vim-clang-format'
"Plug 'kana/vim-operator-user'
"if has('win32')
    "Plug 'Shougo/vimproc.vim'
"endif


"--------------------------------------------------------------------------
" 平滑滚动 
"--------------------------------------------------------------------------
Plug 'yuttie/comfortable-motion.vim'
""""""""""""""""yuttie/comfortable-motion.vim setting"""""""""""""""""""
let g:comfortable_motion_scroll_down_key = "j"
let g:comfortable_motion_scroll_up_key = "k"
let g:comfortable_motion_no_default_key_mappings = 1


"--------------------------------------------------------------------------
" ctrlp and ctrlp-funky 
"--------------------------------------------------------------------------
if (s:memory_enough)
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'tacahiroy/ctrlp-funky'
    nnoremap <Space>ii :CtrlPFunky<Cr>
    " narrow the list down with a word under cursor
    nnoremap <Space>iw :execute 'CtrlPFunky ' . expand('<cword>')<Cr>

    "Change the default mapping and the default command to invoke CtrlP:
    "let g:ctrlp_map = '<c-p>'
    "let g:ctrlp_cmd = 'CtrlP'

    "When invoked without an explicit starting directory, CtrlP will 
    "set its local working directory according to this variable:
    let g:ctrlp_working_path_mode = 'ra'
    let g:ctrlp_regexp = 1
    nnoremap <Space>ff :CtrlP<CR>
    nnoremap <Space>bs :CtrlPBuffer<CR>
    "在历史文件中模糊查找
    nnoremap <Space>rf :CtrlPMRU<CR>
    nnoremap <Space>rm :CtrlPMixed<CR>
    set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
    set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows
    let g:ctrlp_custom_ignore = {
                \ 'dir':  '\v[\/]\.(git|hg|svn|rvm)$',
                \ 'file': '\v\.(exe|so|dll|zip|tar|tar.gz)$',
                \ }

    let g:ctrlp_root_markers = ['.project', '.root', '.svn', '.git']
    let g:ctrlp_working_path = 0

    "调用ag进行搜索提升速度
    if executable('ag')
        set grepprg=ag\ --nogroup\ --nocolor
        let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
        "不使用缓存文件
        "let g:ctrlp_use_caching = 0
    else
        if has('unix')
            let g:ctrlp_user_command = 'find %s -type f'        " MacOSX/Linux
        elseif has('win32')
            let g:ctrlp_user_command = 'dir %s /-n /b /s /a-d'  " Windows
        endif
    endif
endif


"--------------------------------------------------------------------------
" fzf
"--------------------------------------------------------------------------
" NOTE: windows: choco install fzf
" PlugInstall and PlugUpdate will clone fzf in ~/.fzf and run install script
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'  }
"   " Both options are optional. You don't have to install fzf in ~/.fzf
"     " and you don't have to run install script if you use fzf only in Vim.
"

 "let g:fzf_colors =
     "\ { 'fg':      ['fg', 'Normal'],
       "\ 'bg':      ['bg', 'Normal'],
       "\ 'hl':      ['fg', 'Comment'],
       "\ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
       "\ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
       "\ 'hl+':     ['fg', 'Statement'],
       "\ 'info':    ['fg', 'PreProc'],
       "\ 'border':  ['fg', 'Ignore'],
       "\ 'prompt':  ['fg', 'Conditional'],
       "\ 'pointer': ['fg', 'Exception'],
       "\ 'marker':  ['fg', 'Keyword'],
       "\ 'spinner': ['fg', 'Label'],
       "\ 'header':  ['fg', 'Comment'] }

nnoremap <Leader>fi :FZF<CR>
nnoremap <Leader>fm :FZF!<CR>
nnoremap <Leader>fh :FZF! ~<CR>


"--------------------------------------------------------------------------
" ag.vim
"--------------------------------------------------------------------------
Plug 'rking/ag.vim'
" ag的忽略文件在~/.agignore
let g:ag_working_path_mode="r" "search from project root
let g:ag_highlight=1
nnoremap <Space>fa :Ag 
nnoremap <Space>fw :Ag <C-R>=expand("<cword>")<CR><CR>
nnoremap <Space>fb :AgBuffer <C-R>=expand("<cword>")<CR><CR>
nnoremap <Space>fc :AgFile 

"--------------------------------------------------------------------------
" An ack.vim alternative mimics Ctrl-Shift-F on Sublime Text 2  
"--------------------------------------------------------------------------
Plug 'dyng/ctrlsf.vim'
"Input :CtrlSF in command line for you, just a handy shortcut.
nmap <Leader>fa <Plug>CtrlSFPrompt
"Input :CtrlSF in command line for you, just a handy shortcut.
nmap <Leader>fv <Plug>CtrlSFVwordPath<CR>
"Like <Plug>CtrlSFVwordPath, but execute it immediately.
nmap <Leader>fe <Plug>CtrlSFVwordExec<CR>
"Input :CtrlSF foo in command line where foo is word under the cursor.
nmap <Leader>fw <Plug>CtrlSFCwordPath<CR>
"Like <Plug>CtrlSFCwordPath, but also add word boundary around searching word.
nmap <Leader>fc <Plug>CtrlSFCCwordPath<CR>
"Input :CtrlSF foo in command line where foo is the last search pattern of vim.
nmap <Leader>fp <Plug>CtrlSFPwordPath<CR>

nnoremap <Leader>ft :CtrlSFOpen<CR>
nnoremap <Leader>fn :CtrlSFToggle<CR>
inoremap <Leader>fn <Esc>:CtrlSFToggle<CR>
let g:ctrlsf_auto_focus = {
            \ "at" : "done",
            \ "duration_less_than": 1000
            \ }


"--------------------------------------------------------------------------
" 
"--------------------------------------------------------------------------
Plug 'Chun-Yang/vim-action-ag'
"Normal Mode:
"gagiw to search the word
"gagi' to search the words inside single quotes.
"Visual Mode:
"gag to search the selected text


"--------------------------------------------------------------------------
" Vim 界定符自动补齐（delimitMate）插件
"--------------------------------------------------------------------------
"Plug 'Raimondi/delimitMate'


"--------------------------------------------------------------------------
" Vim 界定符自动补齐auto-pairs
"--------------------------------------------------------------------------
Plug 'jiangmiao/auto-pairs'
let g:AutoPairsShortcutToggle = '<Leader>pp'


"--------------------------------------------------------------------------
" vim从其它地方赋值粘贴时自动换行添加缩进解决办法 
" https://blog.csdn.net/xiaoyilong2007101095/article/details/54836854
"--------------------------------------------------------------------------
set pastetoggle=<F9>


"--------------------------------------------------------------------------
" 快速移动
"--------------------------------------------------------------------------
Plug 'easymotion/vim-easymotion'
"map <Space><Space> <Plug>(easymotion-prefix)


"--------------------------------------------------------------------------
" Perform all your vim insert mode completions with Tab
"--------------------------------------------------------------------------
Plug 'ervandew/supertab'
let g:SuperTabDefaultCompletionType = "<c-n>"
let g:SuperTabContextDefaultCompletionType = "<c-n>"


"--------------------------------------------------------------------------
" status line 
"--------------------------------------------------------------------------
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'


"--------------------------------------------------------------------------
"全异步显示文件函数列表，不用的时候不会占用你任何屏幕空间，
"将 ALT+P 绑定到 `:LeaderfFunction!` 这个命令上，按 ALT+P 
"就弹出当前文件的函数列表，然后可以进行模糊匹配搜索，除了上下键移动选择外，
"各种vim的跳转和搜索命令都可以始用，回车跳转然后关闭函数列表，
"除此之外按 i 进入模糊匹配，按TAB切换回列表选择。
"--------------------------------------------------------------------------
if has('win32')
    Plug 'Yggdroot/LeaderF', { 'tag': 'v1.19', 'do': '.\install.bat' }
else
    Plug 'Yggdroot/LeaderF', { 'tag': 'v1.19', 'do': './install.sh' }
endif

let g:Lf_ShortcutF = '<Leader>ff'
let g:Lf_ShortcutB = '<Leader>bs'
nnoremap <Leader>db :bd<CR>
nnoremap <Leader>do :on<CR>
noremap <Leader>rm :LeaderfMru<cr>
noremap <Leader>ii :LeaderfFunction!<cr>
noremap <Leader>tb :LeaderfTag<cr>
"let g:Lf_StlSeparator = { 'left': '', 'right': '', 'font': '' }
let g:Lf_PreviewCode = 1
if executable('/usr/local/bin/ctags')
    let g:Lf_Ctags = "/usr/local/bin/ctags"
endif
let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git']
let g:Lf_WorkingDirectoryMode = 'Ac'
let g:Lf_WindowHeight = 0.30
let g:Lf_CacheDirectory = expand('~/.vim/cache')
let g:Lf_ShowRelativePath = 0
let g:Lf_HideHelp = 1
let g:Lf_StlColorscheme = 'lightline'
"let g:Lf_StlColorscheme = 'powerline'
let g:Lf_PreviewResult = {'Function':0, 'BufTag':0}

let g:Lf_WildIgnore = {
            \ 'dir': ['.svn','.git','.hg'],
            \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
			\ }

let g:Lf_MruFileExclude = ['*.so', '*.exe', '*.py[co]', '*.sw?', '~$*', '*.bak', '*.tmp', '*.dll']
let g:Lf_MruMaxFiles = 2048
let g:Lf_CommandMap = {'<Esc>': ['<C-g>']}
let g:Lf_NormalMap = {
            \ "File":   [["<ESC>", ':exec g:Lf_py "fileExplManager.quit()"<CR>'],
            \            ["<C-g>", ':exec g:Lf_py "fileExplManager.quit()"<CR>']
            \           ],
            \ "Buffer": [["<ESC>", ':exec g:Lf_py "bufExplManager.quit()"<CR>'],
            \            ["<C-g>", ':exec g:Lf_py "bufExplManager.quit()"<CR>']
            \           ],
            \ "Mru":    [["<Esc>", ':exec g:Lf_py "mruExplManager.quit()"<CR>'],
            \            ["<C-g>", ':exec g:Lf_py "mruExplManager.quit()"<CR>']
            \           ],
            \ "Tag":    [],
            \ "BufTag": [],
            \ "Function": [["<Esc>", ':exec g:Lf_py "functionExplManager.quit()"<CR>'],
            \              ["<C-g>", ':exec g:Lf_py "functionExplManager.quit()"<CR>']
            \           ],
            \ "Line":   [],
            \ "History":[],
            \ "Help":   [],
            \ "Self":   [],
            \ "Colorscheme": []
            \}


"--------------------------------------------------------------------------
"当前文档按“-”号就能不切窗口的情况下在当前窗口直接返回当前文档所在的目录，
"再按一次减号就返回上一级目录，按回车进入下一级目录或者再当前窗口打开光标下的文件。
"进一步映射 “<tab>7” , “<tab>8” 和 “<tab>9” 分别用于在新的 split, vsplit 
"和新标签打开当前文件所在目录，这样从一个文件如手，很容易找到和该文件相关的其他项目文件
"--------------------------------------------------------------------------
"Plug 'justinmk/vim-dirvish'
function! s:setup_dirvish()
	if &buftype != 'nofile' && &filetype != 'dirvish'
		return
	endif
	let text = getline('.')
	if ! get(g:, 'dirvish_hide_visible', 0)
		exec 'silent keeppatterns g@\v[\/]\.[^\/]+[\/]?$@d _'
	endif
	exec 'sort ,^.*[\/],'
	let name = '^' . escape(text, '.*[]~\') . '[/*|@=|\\*]\=\%($\|\s\+\)'
	" let name = '\V\^'.escape(text, '\').'\$'
	" echom "search: ".name
	call search(name, 'wc')
	noremap <silent><buffer> ~ :Dirvish ~<cr>
	noremap <buffer> % :e %
endfunc

function! DirvishSetup()
	let text = getline('.')
	for item in split(&wildignore, ',')
		let xp = glob2regpat(item)
		exec 'silent keeppatterns g/'.xp.'/d'
	endfor
	if ! get(g:, 'dirvish_hide_visible', 0)
		exec 'silent keeppatterns g@\v[\/]\.[^\/]+[\/]?$@d _'
	endif
	exec 'sort ,^.*[\/],'
	let name = '^' . escape(text, '.*[]~\') . '[/*|@=]\=\%($\|\s\+\)'
	" let name = '\V\^'.escape(text, '\').'\$'
	call search(name, 'wc')
endfunc

" let g:dirvish_mode = 'call DirvishSetup()'


"----------------------------------------------------------------------
" augroup
"----------------------------------------------------------------------
augroup MyPluginSetup
	autocmd!
    autocmd FileType dirvish call s:setup_dirvish()
augroup END


"--------------------------------------------------------------------------
" Git support for dirvish.vim  
"--------------------------------------------------------------------------
if has('unix')
    Plug 'kristijanhusak/vim-dirvish-git'
    autocmd FileType dirvish nmap <silent><buffer><C-n> <Plug>(dirvish_git_next_file)
    autocmd FileType dirvish nmap <silent><buffer><C-p> <Plug>(dirvish_git_prev_file)
    "These are default indicators used that can be overridden in vimrc:
    "let g:dirvish_git_indicators = {
    "\ 'Modified'  : '✹',
    "\ 'Staged'    : '✚',
    "\ 'Untracked' : '✭',
    "\ 'Renamed'   : '➜',
    "\ 'Unmerged'  : '═',
    "\ 'Deleted'   : '✖',
    "\ 'Ignored'   : '☒',
    "\ 'Unknown'   : '?'
    "\ }
endif


"--------------------------------------------------------------------------
" Print documents in echo area. 
"--------------------------------------------------------------------------
Plug 'Shougo/echodoc.vim'


"--------------------------------------------------------------------------
" A (Neo)vim plugin for formatting code. 
"--------------------------------------------------------------------------
Plug 'sbdchd/neoformat'

"--------------------------------------------------------------------------
" 
"--------------------------------------------------------------------------
Plug 'itchyny/lightline.vim'
"let g:lightline = {
"      \ 'colorscheme': 'wombat',
"      \ 'component_function': {
"      \   'filename': 'LightlineFilename',
"      \ },
"      \ }
"
"function! LightlineFilename()
"    return &filetype ==# 'vimfiler' ? vimfiler#get_status_string() :
"                \ &filetype ==# 'unite' ? unite#get_status_string() :
"                \ &filetype ==# 'vimshell' ? vimshell#get_status_string() :
"                \ expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
"endfunction
"
"let g:unite_force_overwrite_statusline = 0
"let g:vimfiler_force_overwrite_statusline = 0
"let g:vimshell_force_overwrite_statusline = 0

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'component': {
      \   'filename': '%F%m%r%h%w'
      \ },
      \ }


"--------------------------------------------------------------------------
" syntax color  
"--------------------------------------------------------------------------
Plug 'https://github.com/fwar34/vim-color-wombat256.git'


"--------------------------------------------------------------------------
" vim themes 
"--------------------------------------------------------------------------
Plug 'tomasr/molokai'
Plug 'jnurmine/Zenburn'
Plug 'https://github.com/altercation/vim-colors-solarized.git'


"--------------------------------------------------------------------------
" switch c with cpp
"--------------------------------------------------------------------------
Plug 'derekwyatt/vim-fswitch'
nnoremap <Leader>fo :FSHere<CR>
augroup fswitch_grp
    autocmd!
    au! BufEnter *.cc let b:fswitchdst = 'hpp,h' | let b:fswitchlocs = 'reg:/src/include/,reg:|src|include/**|,ifrel:|/src/|../include|'
    au! BufEnter *.h let b:fswitchdst = 'c,cpp,m,cc' | let b:fswitchlocs = 'reg:/include/src/,reg:/include.*/src/,ifrel:|/include/|../src|'
    au! BufEnter *.hpp let b:fswitchdst = 'c,cpp,m,cc' | let b:fswitchlocs = 'reg:/include/src/,reg:/include.*/src/,ifrel:|/include/|../src|'
augroup END


"--------------------------------------------------------------------------
" Automatically opens popup menu for completions 
"--------------------------------------------------------------------------
Plug 'vim-scripts/AutoComplPop'


"--------------------------------------------------------------------------
" 以引号输入为例，说明如何使用这个插件。按下 "，会自动变成双引号""，此时光标位于双引号的中间，等待插入文本，
" 文本插入结束以后，通常我们希望把光标置于右边引号的后面，此时，再按一次 "，光标就会跳转到右边引号的后面，等待我们继续输入文本。
"如果想要删除包含文本的一对引号/括号，可以使用 ds<delimiter> 来删除（<delimiter> 代表具体要删除的符号）。
"--------------------------------------------------------------------------
Plug 'tpope/vim-surround'


"--------------------------------------------------------------------------
" 
"--------------------------------------------------------------------------
Plug 'tpope/vim-commentary'
nnoremap <Leader>cc :commentary<CR>


"--------------------------------------------------------------------------
" Omni
"--------------------------------------------------------------------------
if (s:memory_enough)
    Plug 'vim-scripts/OmniCppComplete'
endif
"set completeopt=menu,menuone " 关掉智能补全时的预览窗口
let OmniCpp_MayCompleteDot = 1 " autocomplete with .
let OmniCpp_MayCompleteArrow = 1 " autocomplete with ->
let OmniCpp_MayCompleteScope = 1 " autocomplete with ::
let OmniCpp_SelectFirstItem = 2 " select first item (but don't insert)
let OmniCpp_NamespaceSearch = 2 " search namespaces in this and included files
let OmniCpp_ShowPrototypeInAbbr = 1 " show function prototype in popup window
let OmniCpp_GlobalScopeSearch=1 " enable the global scope search
let OmniCpp_DisplayMode=1 " Class scope completion mode: always show all members
"let OmniCpp_DefaultNamespaces=["std"]
"let OmniCpp_DefaultNamespaces=["_GLIBCXX_STD"]
let OmniCpp_ShowScopeInAbbr=1 " show scope in abbreviation and remove the last column
let OmniCpp_ShowAccess=1

""setlocal omnifunc=tern#Complete
""call tern#Enable()


"--------------------------------------------------------------------------
" Powerline设置
"--------------------------------------------------------------------------
"Plug 'https://github.com/Lokaltog/vim-powerline.git'
" 设置状态栏主题风格
let g:Powerline_colorscheme='solarized256'


"--------------------------------------------------------------------------
" 
"--------------------------------------------------------------------------
"vimdoc中文
Plug 'https://github.com/yianwillis/vimcdoc.git'


"--------------------------------------------------------------------------
" 语法检查
"--------------------------------------------------------------------------
"Plug 'w0rp/ale'
"始终开启标志列
let g:ale_sign_column_always = 1
let g:ale_set_highlights = 0
let g:ale_linters_explicit = 1
let g:ale_completion_delay = 500
let g:ale_echo_delay = 20
let g:ale_lint_delay = 500
"显示Linter名称,出错或警告等相关信息
"let g:ale_echo_msg_error_str = 'E'
"let g:ale_echo_msg_warning_str = 'W'
"let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_echo_msg_format = '[%linter%] %code: %%s'
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:airline#extensions#ale#enabled = 1

let g:ale_c_gcc_options = '-Wall -O2 -std=c99'
let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++14'
let g:ale_c_cppcheck_options = ''
let g:ale_cpp_cppcheck_options = ''
"if s:windows == 0 && has('win32unix') == 0
	"let g:ale_command_wrapper = 'nice -n5'
"endif

"使用clang对c和c++进行语法检查，对python使用pylint进行语法检查
let g:ale_linters = { 'c++': ['clang'], 'c': ['clang'], 'python': ['pylint'] }

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
"nmap sp <Plug>(ale_previous_wrap)
"nmap sn <Plug>(ale_next_wrap)

"基本上就是定义了一下运行规则，信息显示格式以及几个 linter 的运行参数，其中 6，7 两行比较重要，
"它规定了如果 normal 模式下文字改变以及离开 insert 模式的时候运行 linter，这是相对保守的做法，
"如果没有的话，会导致 YouCompleteMe 的补全对话框频繁刷新。记得设置一下各个 linter 的参数，
"忽略一些你觉得没问题的规则，不然错误太多没法看。默认错误和警告的风格都太难看了，你需要修改一下，
"比如我使用 GVim，就重新定义了警告和错误的样式，去除默认难看的红色背景，代码正文使用干净的波浪下划线表示：
let g:ale_sign_error = "\ue009\ue009"
hi! clear SpellBad
hi! clear SpellCap
hi! clear SpellRare
hi! SpellBad gui=undercurl guisp=red
hi! SpellCap gui=undercurl guisp=blue
hi! SpellRare gui=undercurl guisp=magenta

"<Leader>d查看错误或警告的详细信息
"nmap <Leader>d :ALEDetail<CR>

"文件内容发生变化时不进行检查
"let g:ale_lint_on_text_changed = 'never'
"打开文件时不进行检查
"let g:ale_lint_on_enter = 0


"--------------------------------------------------------------------------
" 文本对象 
"i, 和 a, ：参数对象，写代码一半在修改，现在可以用 di, 或 ci, 一次性删除/改写当前参数
"ii 和 ai ：缩进对象，同一个缩进层次的代码，可以用 vii 选中，dii / cii 删除或改写
"if 和 af ：函数对象，可以用 vif / dif / cif 来选中/删除/改写函数的内容
"--------------------------------------------------------------------------
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-syntax'
Plug 'kana/vim-textobj-function', { 'for':['c', 'cpp', 'vim', 'java'] }
Plug 'sgur/vim-textobj-parameter'


"--------------------------------------------------------------------------
" 前面编译运行时需要频繁的操作 quickfix 窗口，ale查错时也需要快速再错误间跳转（location list），
" 就连文件比较也会用到快速跳转到上/下一个差异处，unimpaired 插件帮你定义了一系列方括号开头的快捷键，
" 被称为官方 Vim 中丢失的快捷键。
"--------------------------------------------------------------------------
Plug 'tpope/vim-unimpaired'
"Note we're not using the noremap family because we do want to recursively
"invoke unimpaired.vim's maps.
"See :help unimpaired-customization for more advanced options.
"let g:nremap = {"[": "<", "]": ">"}
"let g:xremap = {"[": "<", "]": ">"}
"let g:oremap = {"[": "<", "]": ">"}

"--------------------------------------------------------------------------
" 
"--------------------------------------------------------------------------
"上图中 STL 容器模板类 unordered\_multimap 并未高亮，对滴，vim 对 C++
"语法高亮支持不够好（特别是 C++11/14 新增元素），必须借由插件
"vim-cpp-enhanced-highlight
"Plug 'octol/vim-cpp-enhanced-highlight'
""Highlighting of class scope is disabled by default. To enable set
"let g:cpp_class_scope_highlight = 1
""Highlighting of member variables is disabled by default. To enable set
"let g:cpp_member_variable_highlight = 1
""Highlighting of class names in declarations is disabled by default. To enable set
"let g:cpp_class_decl_highlight = 1
""Highlighting of library concepts is enabled by
"let g:cpp_concepts_highlight = 1
"
""There are two ways to highlight template functions. Either
"let g:cpp_experimental_simple_template_highlight = 1
""which works in most cases, but can be a little slow on large files. Alternatively set
""let g:cpp_experimental_template_highlight = 1
""which is a faster implementation but has some corner cases where it doesn't work.


"--------------------------------------------------------------------------
" 
"--------------------------------------------------------------------------
Plug 'https://github.com/octol/vim-cpp-enhanced-highlight.git'
"Plug 'https://github.com/fwar34/vim-cpp-enhanced-highlight.git'
let g:cpp_class_scope_highlight = 1
"let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
"let g:cpp_experimental_simple_template_highlight = 1
"


"--------------------------------------------------------------------------
"对于很长的代码，折叠代码有助于理清代码整体结构。SimplyFold 是一款不错代码折叠插件
"zo： 打开光标处的 fold
"zO： 递归打开光标处所有 fold
"zc： 关闭光标处 fold
"zC： 关闭光标处所有 fold
"--------------------------------------------------------------------------
Plug 'tmhedberg/SimpylFold'


"--------------------------------------------------------------------------
"Nvim 中，使用 y 复制文本以后，不会提示复制了哪些文本，除非使用者非常熟悉 Nvim 按键，
"否则可能会复制错误。vim-highlightedyank 这款插件可以在复制（yank）文本以后高亮提示哪些文本被复制了，非常实用 
"
"通常情况下，安装插件以后不需要做任何设置即可使用，但是对于某些主题，高亮的颜色可能看不清楚，可以在 Nvim 设置中加入以下命令：
"hi HighlightedyankRegion cterm=reverse gui=reverse

"如果觉得高亮显示的时间太短，可以设置增加高亮显示的时间（单位为毫秒）：
"let g:highlightedyank_highlight_duration = 1000 " 高亮持续时间为 1000 毫秒
"--------------------------------------------------------------------------
Plug 'machakann/vim-highlightedyank'


"--------------------------------------------------------------------------
" 书签可视化
"--------------------------------------------------------------------------
Plug 'https://github.com/kshenoy/vim-signature.git' 
let g:SignatureMap = {
        \ 'Leader'             :  "m",
        \ 'PlaceNextMark'      :  "m,",
        \ 'ToggleMarkAtLine'   :  "m.",
        \ 'PurgeMarksAtLine'   :  "m-",
        \ 'DeleteMark'         :  "dm",
        \ 'PurgeMarks'         :  "mda",
        \ 'PurgeMarkers'       :  "m<BS>",
        \ 'GotoNextLineAlpha'  :  "']",
        \ 'GotoPrevLineAlpha'  :  "'[",
        \ 'GotoNextSpotAlpha'  :  "`]",
        \ 'GotoPrevSpotAlpha'  :  "`[",
        \ 'GotoNextLineByPos'  :  "]'",
        \ 'GotoPrevLineByPos'  :  "['",
        \ 'GotoNextSpotByPos'  :  "mn",
        \ 'GotoPrevSpotByPos'  :  "mp",
        \ 'GotoNextMarker'     :  "[+",
        \ 'GotoPrevMarker'     :  "[-",
        \ 'GotoNextMarkerAny'  :  "]=",
        \ 'GotoPrevMarkerAny'  :  "[=",
        \ 'ListLocalMarks'     :  "ms",
        \ 'ListLocalMarkers'   :  "m?"
        \ }


"--------------------------------------------------------------------------
" completor
"--------------------------------------------------------------------------
if has('win32')
    "Plug 'maralla/completor.vim'
    "Use Tab to trigger completion (disable auto trigger)
    "let g:completor_auto_trigger = 0
    "inoremap <expr> <Tab> pumvisible() ? "<C-N>" : "<C-R>=completor#do('complete')<CR>"
    "
    "C++
    "let g:completor_clang_binary = '/usr/bin/clang'
    "let g:completor_python_binary = 'python'
    "Plug 'davidhalter/jedi-vim'
    "map <tab> <Plug>CompletorCppJumpToPlaceholder
    "imap <tab> <Plug>CompletorCppJumpToPlaceholder
endif


"--------------------------------------------------------------------------
" deoplete
"--------------------------------------------------------------------------
"if has('unix') && s:memory_enough
if s:memory_enough
    if has('nvim')
        Plug 'Shougo/deoplete.nvim', { 'tag': '4.1', 'do': ':UpdateRemotePlugins' }

        "https://jdhao.github.io/2018/09/05/centos_nvim_install_use_guide/
        "函数方法 Preview 的窗口如何自动关闭？ 在自动补全给出的列表中移动的时候，
        "Nvim 的上半部分会出现一个很小的窗口，提示当前方法的参数，但是该窗口在自动补全完成后并不能自动消失，
        "参考 https://goo.gl/Bn5n39，可以使用下面的设置使得窗口自动消失
        autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

        "如何设定为使用 Tab 键在自动补全的列表跳转？ 在 Nvim 的配置中，加入如下设置即可：
        inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>" 
    else
        Plug 'Shougo/deoplete.nvim', { 'tag': '4.1' }
        Plug 'roxma/nvim-yarp'
        Plug 'roxma/vim-hug-neovim-rpc'
    endif
    let g:deoplete#enable_at_startup = 1

    Plug 'zchee/deoplete-jedi'
    "Plug 'Shougo/deoplete-clangx'
    "" Change clang binary path
    "call deoplete#custom#var('clangx', 'clang_binary', '/usr/local/bin/clang')

    "" Change clang options
    "call deoplete#custom#var('clangx', 'default_c_options', '')
    "call deoplete#custom#var('clangx', 'default_cpp_options', '')

    if has('unix')
        "Plug 'zchee/deoplete-clang'
        Plug 'deoplete-plugins/deoplete-clang'
        if isdirectory('/usr/lib/llvm-6.0/')
            let g:deoplete#sources#clang#libclang_path = '/usr/lib/llvm-6.0/lib/libclang.so.1'
            let g:deoplete#sources#clang#clang_header = '/usr/lib/llvm-6.0/lib/clang'
        elseif isdirectory('/usr/lib/llvm-3.8/')
            let g:deoplete#sources#clang#libclang_path = '/usr/lib/llvm-3.8/lib/libclang.so.1'
            let g:deoplete#sources#clang#clang_header = '/usr/lib/llvm-3.8/lib/clang'
        elseif findfile("libclang.so", "/usr/lib")
            let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
            let g:deoplete#sources#clang#clang_header = '/usr/lib/clang'
        endif
    endif

    Plug 'Shougo/neoinclude.vim'
    if has('win32')
        if isdirectory('C:\Users\feng\AppData\Local\Programs\Python\Python37-32')
            let g:python3_host_prog='C:\Users\feng\AppData\Local\Programs\Python\Python37-32\python.exe'
        elseif isdirectory('C:\Users\fwar3\AppData\Local\Programs\Python\Python36')
        elseif isdirectory('C:\Users\liang.feng\AppData\Local\Programs\Python\Python36')
            let g:python3_host_prog='C:\Users\liang.feng\AppData\Local\Programs\Python\Python36\python.exe'
        elseif isdirectory('C:\Python37')
            let g:python3_host_prog='C:\Python37\python.exe'
        endif
    endif
endif

"--------------------------------------------------------------------------
" This script is for generating a .clang_complete that could be 
" utilized by emacs irony-mode or company-clang mode.
"--------------------------------------------------------------------------
Plug 'WenxiJin/.clang_complete'


"--------------------------------------------------------------------------
" 彩虹括号 for vim
"--------------------------------------------------------------------------
if (s:memory_enough) "&& !has('nvim')
    Plug 'luochen1990/rainbow', { 'tag': 'v3.3.1' }

    let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
    let g:rainbow_conf = {
                \	'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
                \	'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
                \	'operators': '_,_',
                \	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
                \	'separately': {
                \		'*': {},
                \		'tex': {
                \			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
                \		},
                \		'lisp': {
                \			'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
                \		},
                \		'vim': {
                \			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
                \		},
                \		'html': {
                \			'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
                \		},
                \		'css': 0,
                \	}
                \}
endif


"--------------------------------------------------------------------------
" 调颜色插件 
"--------------------------------------------------------------------------
Plug 'guns/xterm-color-table.vim'


"--------------------------------------------------------------------------
" 草稿 normal模式gs
"--------------------------------------------------------------------------
Plug 'mtth/scratch.vim'
let g:scratch_autohide=1


"--------------------------------------------------------------------------
" nerdtree 
"--------------------------------------------------------------------------
Plug 'scrooloose/nerdtree'
nnoremap <Leader>tt :NERDTreeToggle<CR>
" 设置 NERDTree 子窗口宽度
let NERDTreeWinSize=35
" 设置 NERDTree 子窗口位置
let NERDTreeWinPos="right"
" 显示隐藏文件
let NERDTreeShowHidden=1
" NERDTree 子窗口中不显示冗余帮助信息
let NERDTreeMinimalUI=1
" 删除文件时自动删除文件对应 buffer
let NERDTreeAutoDeleteBuffer=1
"How can I close vim if the only window left open is a NERDTree?
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"How can I change default arrows?
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'

"Allow configuration for multiple highlighting based on file type
"https://github.com/scrooloose/nerdtree/issues/433#issuecomment-92590696
" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
    exec 'autocmd filetype nerdtree highlight ' . a:extension .' 
                \ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
    exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515')
call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')
call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')

let NERDTreeIgnore = ['\.o$', '\.lo$', '\.swp$', '\.pyc$', '\.la$'] 
let NERDTreeIgnore += ['cscope\..*', 'tags', 'GPATH', 'GTAGS', 'GRTAGS']


"--------------------------------------------------------------------------
" A plugin of NERDTree showing git status 
"--------------------------------------------------------------------------
Plug 'Xuyuanp/nerdtree-git-plugin'
"let g:NERDTreeIndicatorMapCustom = {
    "\ "Modified"  : "✹",
    "\ "Staged"    : "✚",
    "\ "Untracked" : "✭",
    "\ "Renamed"   : "➜",
    "\ "Unmerged"  : "═",
    "\ "Deleted"   : "✖",
    "\ "Dirty"     : "✗",
    "\ "Clean"     : "✔︎",
    "\ 'Ignored'   : '☒',
    "\ "Unknown"   : "?"
    "\ }


"--------------------------------------------------------------------------
" Async plugin for vim and neovim to ease the use of ctags/gtags
"--------------------------------------------------------------------------
" Plug 'jsfaint/gen_tags.vim'


"--------------------------------------------------------------------------
" 代码模板补全
"--------------------------------------------------------------------------
"Plug 'honza/vim-snippets'
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"


"--------------------------------------------------------------------------
" ultisnips 
"--------------------------------------------------------------------------
"Plug 'SirVer/ultisnips'
" UltiSnips 的 tab 键与 YCM 冲突，重新设定
let g:UltiSnipsExpandTrigger="<Leader><tab>"
let g:UltiSnipsJumpForwardTrigger="<Leader><tab>"
let g:UltiSnipsJumpBackwardTrigger="<Leader><s-tab>"
"let g:UltiSnipsSnippetDirectories=["mycppsnippets"]

if isdirectory("/home/liang.feng")
    let g:UltiSnipsSnippetDirectories=["/home/liang.feng/.vim/plugged/cppsnippets"]
    let g:UltiSnipsSnippetDirectories=[expand("~/.vim/plugged/cppsnippets")]
elseif isdirectory("/home/fwar3")
    let g:UltiSnipsSnippetDirectories=["/home/fwar3/.vim/plugged/cppsnippets"]
endif


"--------------------------------------------------------------------------
" Complete parameter after select the completion. Integration with YouCompleteMe(ycm), deoplete, neocomplete. 
" Install a complete engine have supported. Goto the completion item of the completion popup menu you want to select, 
" and then type ((minimal setting), the parameters will be inserted and select the the first parameter. <c-j>/<c-k>(minimal setting) 
" will jump to the next/previous parameter and select it.
"--------------------------------------------------------------------------
"NOTE: If you use ultinsips, you must load ultisnips before this plugin. In other 
"words, if you use plug to load plugins, Plug 'SirVer/ultisnips' must 
"before Plug 'tenfyzhong/CompleteParameter.vim' in your vimrc.

if (s:memory_enough)
    Plug 'tenfyzhong/CompleteParameter.vim'
    " Minimal setting
    inoremap <silent><expr> ( complete_parameter#pre_complete("()")
    smap <c-j> <Plug>(complete_parameter#goto_next_parameter)
    imap <c-j> <Plug>(complete_parameter#goto_next_parameter)
    smap <c-k> <Plug>(complete_parameter#goto_previous_parameter)
    imap <c-k> <Plug>(complete_parameter#goto_previous_parameter)
    " Goto next parameter and select it.
    nmap <c-j> <Plug>(complete_parameter#goto_next_parameter)
    imap <c-j> <Plug>(complete_parameter#goto_next_parameter)
    smap <c-j> <Plug>(complete_parameter#goto_next_parameter)
    " Goto previous parameter and select it.
    nmap <c-k> <Plug>(complete_parameter#goto_previous_parameter)
    imap <c-k> <Plug>(complete_parameter#goto_previous_parameter)
    smap <c-k> <Plug>(complete_parameter#goto_previous_parameter)
    " Select next overload function.
    nmap <m-d> <Plug>(complete_parameter#overload_down)
    imap <m-d> <Plug>(complete_parameter#overload_down)
    smap <m-d> <Plug>(complete_parameter#overload_down)
    " Select previous overload function.
    nmap <m-u> <Plug>(complete_parameter#overload_up)
    imap <m-u> <Plug>(complete_parameter#overload_up)
    smap <m-u> <Plug>(complete_parameter#overload_up)

    "Can't work with plugin auto-pairs use the default mapping (
    "https://github.com/tenfyzhong/CompleteParameter.vim
    let g:AutoPairs = {'[':']', '{':'}',"'":"'",'"':'"', '`':'`'}
    inoremap <buffer><silent> ) <C-R>=AutoPairsInsert(')')<CR>
endif


"--------------------------------------------------------------------------
" minibufexpl 
"--------------------------------------------------------------------------
"Plug 'fholgado/minibufexpl.vim'
 "显示/隐藏 MiniBufExplorer 窗口
"nnoremap <Leader>mb :MBEToggle<cr>
"nnoremap <Leader>mh :MBEbn<cr>
"nnoremap <Leader>mq :MBEbp<cr>
 "minibufexpl插件的一般设置
"let g:miniBufExplMapWindowNavVim = 1
"let g:miniBufExplMapWindowNavArrows = 1
"let g:miniBufExplMapCTabSwitchBufs = 1
"let g:miniBufExplModSelTarget = 1
"not auto start
"let g:miniBufExplorerAutoStart = 0


"--------------------------------------------------------------------------
" doxygen
"--------------------------------------------------------------------------
Plug 'https://github.com/scrooloose/nerdcommenter.git'


"--------------------------------------------------------------------------
" YouCompleteMe 
"--------------------------------------------------------------------------
"Plug 'Valloric/YouCompleteMe'
" 基于语义的代码导航
"nnoremap <Leader>jc :YcmCompleter GoToDeclaration<CR>
" 只能是 #include 或已打开的文件
"nnoremap <Leader>jd :YcmCompleter GoToDefinition<CR>
"nnoremap <Leader>jj :YcmCompleter GoToDefinitionElseDeclaration<CR>
"3条关闭语法检测
let g:ycm_enable_diagnostic_signs = 0
let g:ycm_enable_diagnostic_highlighting = 0
let g:ycm_echo_current_diagnostic = 0
"let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'       "配置全局路径
let g:ycm_confirm_extra_conf=0   "每次直接加载该文件，不提示是否要加载

"let g:ycm_server_python_interpreter='/usr/bin/python'
let g:ycm_server_python_interpreter='/usr/bin/python2'

"" 补全功能在注释中同样有效
let g:ycm_complete_in_comments=1
let g:ycm_min_num_of_chars_for_completion = 3 
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_key_list_select_completion = ['<c-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<c-p>', '<Up>']
" 开启 YCM 标签补全引擎
let g:ycm_collect_identifiers_from_tags_files=1
"YCM 集成 OmniCppComplete 补全引擎，设置其快捷键
inoremap <Leader><Tab> <C-x><C-o>
"
" 补全内容不以分割子窗口形式出现，只显示补全列表
set completeopt-=preview
" 从第一个键入字符就开始罗列匹配项
let g:ycm_min_num_of_chars_for_completion=1
" 禁止缓存匹配项，每次都重新生成匹配项
let g:ycm_cache_omnifunc=0
" 语法关键字补全
let g:ycm_seed_identifiers_with_syntax=1


"--------------------------------------------------------------------------
" YCM-Generator
" This is a script which generates a list of compiler flags from a project
" with an arbitrary build system
"--------------------------------------------------------------------------
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }
"Plug 'marijnh/tern_for_vim'


"{{{
"Plug 'Shougo/neosnippet-snippets'
"}}}

"{{{
"Plug 'maralla/completor-neosnippet'
"}}}


"--------------------------------------------------------------------------
" 
"--------------------------------------------------------------------------
"Plug 'https://github.com/fwar34/cppsnippets.git'
" The following are examples of different formats supported.
" Keep Plug commands between vundle#begin/end.


"--------------------------------------------------------------------------
" 
"--------------------------------------------------------------------------
Plug 'mhinz/vim-signify'
let g:signify_vcs_list = ['git', 'svn']
let g:signify_difftool = 'diff'
let g:signify_sign_add               = '+'
let g:signify_sign_delete            = '-'
let g:signify_sign_delete_first_line = '^'
let g:signify_sign_change            = '~'
let g:signify_sign_changedelete      = g:signify_sign_change
nnoremap <Leader>di :SignifyDiff<CR>

"Hunk jumping:~
    "]c   Jump to next hunk.
    "[c   Jump to previous hunk.

    "]C   Jump to last hunk.
    "[C   Jump to first hunk.

"If you don't like these mappings, you can map them yourself:
">
    "nmap <leader>gj <plug>(signify-next-hunk)
    "nmap <leader>gk <plug>(signify-prev-hunk)
    "nmap <leader>gJ 9999<leader>gj
    "nmap <leader>gK 9999<leader>gk
"<
"------------------------------------------------------------------------------
"Hunk text object:~
">
    "omap ic <plug>(signify-motion-inner-pending)
    "xmap ic <plug>(signify-motion-inner-visual)
    "omap ac <plug>(signify-motion-outer-pending)
    "xmap ac <plug>(signify-motion-outer-visual)
"<
"ic" operates on all lines of the current hunk. "ac" does the same, but also
"removes all trailing empty lines.


"--------------------------------------------------------------------------
" vim-gutentags 
"--------------------------------------------------------------------------
Plug 'ludovicchabant/vim-gutentags'
Plug 'skywind3000/gutentags_plus'

let g:gutentags_modules = ['ctags', 'gtags_cscope']
let g:gutentags_project_root = ['.root']
let g:gutentags_ctags_tagfile = '.tags'

let g:gutentags_cache_dir = expand('~/.cache/tags')
let g:gutentags_ctags_extra_args = []
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

"https://zhuanlan.zhihu.com/p/36279445
"let g:gutentags_auto_add_gtags_cscope = 0

" 错误排查：gutentags: gutentags: gtags-cscope job failed, returned: 1
"这是因为 gutentags 调用 gtags 时，gtags 返回了错误值 1，具体是什么情况，
"需要进一步打开日志，查看 gtags 的错误输出：
"let g:gutentags_define_advanced_commands = 1
"先在 vimrc 中添加上面这一句话，允许 gutentags 打开一些高级命令和选项。
"然后打开你出错的源文件，运行 “:GutentagsToggleTrace”命令打开日志，
"然后保存一下当前文件，触发 gtags 数据库更新，接下来你应该能看到一些讨厌的日志输出，
"这里不够的话，~/.cache/tags 目录下还有对应项目名字的 log 文件，
"打开看看 gtags 具体输出了什么，然后进行相应的处理。
let g:gutentags_define_advanced_commands = 1

"输出trace信息
"let g:gutentags_trace = 1

if has('win32')
    "let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']
endif

let g:gutentags_plus_nomap = 1
noremap <silent> <Leader>gs :GscopeFind s <C-R><C-W><cr>
noremap <silent> <Leader>gg :GscopeFind g <C-R><C-W><cr>
noremap <silent> <Leader>gc :GscopeFind c <C-R><C-W><cr>
noremap <silent> <Leader>gt :GscopeFind t <C-R><C-W><cr>
noremap <silent> <Leader>ge :GscopeFind e <C-R><C-W><cr>
noremap <silent> <Leader>gf :GscopeFind f <C-R>=expand("<cfile>")<cr><cr>
noremap <silent> <Leader>gi :GscopeFind i <C-R>=expand("<cfile>")<cr><cr>
noremap <silent> <Leader>gd :GscopeFind d <C-R><C-W><cr>
noremap <silent> <Leader>ga :GscopeFind a <C-R><C-W><cr>

"gutentags.txt
augroup MyGutentagsStatusLineRefresher
    autocmd!
    autocmd User GutentagsUpdating call lightline#update()
    autocmd User GutentagsUpdated call lightline#update()
augroup END


"--------------------------------------------------------------------------
" 使用 vim-preview 插件高效的在 quickfix 中先快速预览所有结果，再有针对性的打开必要文件
" This plugin solves a series of user experience problems in vim's preview window and 
" provide a handy way to preview tags, files and function signatures.
"--------------------------------------------------------------------------
Plug 'skywind3000/vim-preview'
noremap <C-k> :PreviewScroll -1<cr>
noremap <C-j> :PreviewScroll +1<cr>
inoremap <C-k> <c-\><c-o>:PreviewScroll -1<cr>
inoremap <C-j> <c-\><c-o>:PreviewScroll +1<cr>
autocmd FileType qf nnoremap <silent><buffer> p :PreviewQuickfix<cr>
autocmd FileType qf nnoremap <silent><buffer> q :PreviewClose<cr>
noremap <F4> :PreviewSignature!<cr>
inoremap <F4> <c-\><c-o>:PreviewSignature!<cr>


"--------------------------------------------------------------------------
" https://zhuanlan.zhihu.com/p/36279445 
"--------------------------------------------------------------------------
"let $GTAGSLABEL = 'native-pygments'
if !has('win32') && executable('/usr/local/bin/ctags')
    let $GTAGSLABEL = 'universal-ctags'
endif
"let $GTAGSCONF = '/path/to/share/gtags/gtags.conf'
"let $GTAGSCONF = '~/.globalrc'


"--------------------------------------------------------------------------
" incsearch 
"--------------------------------------------------------------------------
Plug 'haya14busa/incsearch.vim'
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)


"--------------------------------------------------------------------------
" Plugins end
"--------------------------------------------------------------------------
" All of your Plugs must be added before the following line
call plug#end()            " required


"--------------------------------------------------------------------------
" 营造专注气氛
"--------------------------------------------------------------------------
" 禁止光标闪烁
set gcr=a:block-blinkon0
" 禁止显示滚动条
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R
" 禁止显示菜单和工具条
set guioptions-=m
set guioptions-=T

" 正向遍历同名标签
nnoremap <Leader>tn :tnext<CR>
" 反向遍历同名标签
nnoremap <Leader>tp :tprevious<CR>


"--------------------------------------------------------------------------
" 显示相关  
"--------------------------------------------------------------------------
set shortmess=atI   " 启动的时候不显示那个援助乌干达儿童的提示  
set number              " 显示行号  
set go=             " 不要图形按钮  

"linux系统下gui模式下窗口大小
if system('uname') == "Linux\n" && has('gui_running')
    set lines=25
    set columns=110
endif

"字体设置 
"windows下空格为:而unix下要转译\,windows下字体的空格用下划线_
if has('gui_running')
    if has('win32')
        set guifontset=
        if hostname() == "A12839"
            set guifont=Courier\ New:h12:cANSI
            "设置中文为微软雅黑
            "set guifontwide=Microsoft\ YaHei:h12
            set guifontwide=幼圆:b:h11:cGB2312
        elseif hostname() == "FENG-PC"
            set guifont=Courier\ New:h12:cANSI
            "设置中文为微软雅黑
            "set guifontwide=Microsoft\ YaHei:h12
            set guifontwide=黑体:b:h11:cGB2312
            "set guifontwide=仿宋:b:h12:cGB2312
            "set guifontwide=新宋体:b:h12:cGB2312
            "set guifontwide=微软雅黑:h11:cGB2312
        else
            "set guifont=Courier_New:h12:cANSI
            "set guifont=Source_Code_Variable:h12:cANSI
            set guifont=Fira_Code_Light:h12:cANSI
            "启动时会弹出字体选择框，如果取消，则采用系统默认字体 
            "set guifont=* 
            "Windows默认使用的字体，字体较粗 
            "set guifont=Fixedsys 
            "中文显示变形，字体较粗 
            "set guifont=Monospace:h9 
            "中文显示变形，字体较细 
            "set guifont=Consolas:h9 
            "中文显示变形，字体较细 
            "set guifont=Lucida\ Console:h9 
            "中文显示变形，字体较细 
            "set guifont=Monaco:h9 
            "中文显示变形，字体较细 
            "set guifont=Andale\ Mono:h10 
            "中文显示变形，字体较细 
            "set guifont=Bitstream\ Vera\ Sans\ Mono:h9 
            "需要运行修改版的gvim才能识别 
            "set guifont=YaHei\ Consolas\ Hybrid:h9 
            "如果guifontwide采用中文字体，汉字将自动使用guifontwide，英文自动使用guifont 
            "set guifontwide=YaHei\ Consolas\ Hybrid:h9 
            "设置中文为微软雅黑
            "set guifontwide=Microsoft\ YaHei:h12
            "set guifontwide=幼圆:b:h11:cGB2312
        endif
    elseif has('unix')
        set guifont=Courier\ 14
    endif
endif

if has('nvim')
    if hostname() == "FENG-PC" || hostname() == "A12839"
        set guifont=Courier\ New:h12:cANSI
        "设置中文为微软雅黑
        "set guifontwide=Microsoft\ YaHei:h11
        "set guifontwide=:h10:cGB2312
    endif
endif

syntax on           " 语法高亮  
syntax enable
set showcmd         " 输入的命令显示出来，看的清楚些  
set novisualbell    " 不要闪烁(不明白)  
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}   "状态行显示的内容  
set laststatus=2    " 启动显示状态行(1),总是显示状态行(2)  
set nofoldenable    "不许折叠
"set foldenable      " 允许折叠  
"set foldmethod=manual   " 手动折叠  

"set fileencodings=ucs-bom,utf-8,cp936
set fileencodings=utf-8,ucs-bom,cp936
if has('win32')
    "vim提示信息乱码的解决
    let $LANG='ch'  "set message language  
    set langmenu=ch   "set menu's language of gvim. no spaces beside '='  
    "language message zh_CN.UTF-8
    set fileencoding=utf-8
    "vim的菜单乱码解决
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim
else
    let $LANG='en'  "set message language  
    set langmenu=en   "set menu's language of gvim. no spaces beside '='  
    set fileencoding=utf-8
endif

set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set helplang=en
set encoding=utf-8


"--------------------------------------------------------------------------
" 新文件标题
"--------------------------------------------------------------------------
"新建.c,.h,.sh,.java文件，自动插入文件头 
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.java exec ":call SetTitle()" 

""定义函数SetTitle，自动插入文件头 
func SetTitle() 
    "如果文件类型为.sh文件 
    if &filetype == 'sh'
        call setline(1,"\#########################################################################") 
        call append(line("."), "\# File Name: ".expand("%")) 
        call append(line(".")+1, "\# Author: Feng") 
        "原来的时间形式比较复杂，不喜欢，改变一下
        call append(line(".")+2, "\# Created Time: ".strftime("%Y-%m-%d %H:%M")) 
        "call append(line(".")+3, "\# Created Time: ".strftime("%Y-%m-%d",localtime()))
        call append(line(".")+3, "\# Content: ") 
        call append(line(".")+4, "\#########################################################################") 
        call append(line(".")+5, "\#!/bin/bash") 
        call append(line(".")+6, "") 
    else 
        call setline(1, "/*************************************************************************") 
        call append(line("."), "    > File Name: ".expand("%")) 
        call append(line(".")+1, "    > Author: Feng") 
        " 同样的 改变时间格式
        call append(line(".")+2, "    > Created Time: ".strftime("%Y-%m-%d %H:%M")) 
        "call append(line(".")+3, "    > Created Time: ".strftime("%Y-%m-%d",localtime()))
        call append(line(".")+3, "    > Content: ") 
        call append(line(".")+4, " ************************************************************************/") 
        call append(line(".")+5, "")
    endif
    if &filetype == 'cpp'
        call append(line(".")+6, "#include <iostream>")
        call append(line(".")+7, "")
        "call append(line(".")+8, "using namespace std;")
        call append(line(".")+8, "")
    endif
    if &filetype == 'c'
        call append(line(".")+6, "#include<stdio.h>")
        call append(line(".")+7, "")
    endif
    "新建文件后，自动定位到文件末尾
    autocmd BufNewFile * normal G

endfunc 

" Suzzz：  模仿上面，新建python文件时，添加文件头
autocmd BufNewFile *py exec ":call SetPythonTitle()"

func SetPythonTitle()
    if !has('win32')
        call setline(1,"#!/usr/bin/env python3")
        call append( line("."),"#-*- coding: utf-8 -*-" )
    endif
    call append(line(".")+1," ")
    call append(line(".")+2, "\# File Name: ".expand("%")) 
    call append(line(".")+3, "\# Author: Feng") 
	call append(line(".")+4, "\# Created Time: ".strftime("%Y-%m-%d %H:%M"))
    "call append(line(".")+5, "\# Created Time: ".strftime("%Y-%m-%d",localtime()))    
    call append(line(".")+5, "\# Content: ") 
    autocmd BufNewFile * normal G
endfunc

func InsertVimCommit()
    call append(line(".") - 1, "\"--------------------------------------------------------------------------")
    call append(line(".") - 1, "\" ")
    call append(line(".") - 1, "\"--------------------------------------------------------------------------")
endfunc
nnoremap <Leader>ic :call InsertVimCommit()<CR>

func InsertTitle()
    call append(line(".")-1, "/****************************************************************************************")
    call append(line(".")-1, " * Copyright (c) 2008~".strftime("%Y").join([" All Rights Resverved by"]))
    call append(line(".")-1, " * G-Net Integrated Service co. Ltd.")
    call append(line(".")-1, " ****************************************************************************************/")
    call append(line(".")-1, "/**")
    call append(line(".")-1, " * @file ".expand("%"))
    call append(line(".")-1, " * @brief ")
    call append(line(".")-1, " *")
    call append(line(".")-1, " * @author liang.feng")
    call append(line(".")-1, " *")
    call append(line(".")-1, " * @data ".strftime("%Y-%m-%d %H:%M"))
    call append(line(".")-1, " *")
    call append(line(".")-1, " * @version 1.0.0")
    call append(line(".")-1, " *")
    call append(line(".")-1, " * Revision History") 
    call append(line(".")-1, " * liang.feng ".strftime("%Y-%m-%d %H:%M").join([" create version 1.0.0"]))
    call append(line(".")-1, " *")
    call append(line(".")-1, " ****************************************************************************************/") 
endfunc
nnoremap <Leader>it :call InsertTitle()<CR>

"--------------------------------------------------------------------------
" 键盘命令 
"--------------------------------------------------------------------------
nnoremap <Leader>ht g<C-]>

"--------------------------------------------------------------------------
" Gtags
"--------------------------------------------------------------------------
"let Gtags_Auto_Map = 1          "use a suggested key-mapping
let Gtags_Auto_Update = 1       "keep tag files up-to-date automatically
let Gtags_No_Auto_Jump = 1      "don't jump to the first tag at the time of search
let Gtags_Close_When_Single = 1 "close quickfix windows in case of single tag
nnoremap <Leader>hg :GtagsCursor<CR>
"----查找函数、宏、枚举等定义的位置
"nnoremap <Leader>ga :Gtags -a <C-R>=expand("<cword>")<CR><CR>
"----查找调用本函数的函数
nnoremap <Leader>hc :Gtags -rxa <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>ha :Gtags -ga <C-R>=expand("<cword>")<CR><CR>
let GtagsCscope_Auto_Load = 1

"--------------------------------------------------------------------------
" 
"--------------------------------------------------------------------------
inoremap <expr> <Leader>k col('.') ==# col('$') ? "\<Delete>" : "\<C-o>D"
noremap! <Leader>u <C-u>

"a->begin
inoremap <Leader>a <Esc>I
noremap <Leader>a ^
cnoremap <Leader>a <Home>
cnoremap <C-g> <Esc>
"e->end
inoremap <Leader>e <End>
noremap <Leader>e $
cnoremap <Leader>e <End>
"move in insert mod or cmd mod
noremap! <C-b> <Left>
noremap! <C-f> <Right>
noremap! <Leader>n <Down>
noremap! <Leader>p <Up>

noremap! <Leader>f <S-Right>
noremap! <Leader>b <S-Left>

inoremap <Leader>o <C-o>O

"adjust in insert mod
"inoremap <Leader>t <C-t>
"inoremap <Leader>d <C-d>
"delete in insert mod
noremap! <C-d> <Delete>
noremap! <Leader>w <C-w>
nnoremap <silent> <Leader>xx :nohl<CR>
nnoremap ge G
nnoremap . ;
nnoremap <Leader>zz :w<CR>
inoremap <Leader>zz <Esc>:w<CR>a
nnoremap <Leader>yy mgy'a`g
nnoremap <Leader>dd d'a


"--------------------------------------------------------------------------
" 
"--------------------------------------------------------------------------
"can see :h registers
":di == :reg
cnoremap <Leader>rr <C-r><C-w>
cnoremap <Leader>rc <C-r>*
cnoremap <Leader>ry <C-r>"
"cnoremap <Leader>ry <C-r>0
"}}}
"

"--------------------------------------------------------------------------
" 
"--------------------------------------------------------------------------
nnoremap <Leader>ia mgA;<Esc>`gmg
nnoremap <Leader><TAB> <C-w><C-w>
nnoremap <Leader>bb <C-^>
nnoremap <Leader>mm %
nnoremap <Leader>dj :e .<CR>
nnoremap <Leader>df :Explore<CR>


"--------------------------------------------------------------------------
" F9 compile single file
"--------------------------------------------------------------------------
"nnoremap <silent> <F9> :AsyncRun g++ -Wall -O2 "$(VIM_FILEPATH)" -o "$(VIM_FILEDIR)/$(VIM_FILENOEXT)" <cr>

"--------------------------------------------------------------------------
" F5 run
"--------------------------------------------------------------------------
"nnoremap <silent> <F5> :AsyncRun -raw -cwd=$(VIM_FILEDIR) "$(VIM_FILEDIR)/$(VIM_FILENOEXT)" <cr>


"C，C++ 按F5编译运行
nnoremap <F5> :call CompileRunGcc()<CR>

func! CompileRunGcc()
    exec "w"
    if &filetype == 'c'
        "先删除上次编译的执行文件"
        if filereadable(expand("%<"))
            silent exec "!rm %<"
        endif
        "exec "!gcc % -o %<"
        exec "AsyncRun gcc -Wall -O2 $(VIM_FILEPATH) -o $(VIM_FILEDIR)/$(VIM_FILENOEXT)"
        "如果编译成功了有了可执行文件才运行"
        if filereadable(expand("%<"))
            "exec "! ./%<"
            exec "AsyncRun -raw -cwd=$(VIM_FILEDIR) $(VIM_FILEDIR)/$(VIM_FILENOEXT)"
        endif
    elseif &filetype == 'cpp'
        "先删除上次编译的执行文件"
        if filereadable(expand("%<"))
            silent exec "!rm %<"
        endif
        "exec "!g++ -std=c++11 % -o %<"
        exec "AsyncRun g++ -Wall -O2 -std=c++11 $(VIM_FILEPATH) -o $(VIM_FILEDIR)/$(VIM_FILENOEXT) -lpthread"
        "如果编译成功了有了可执行文件才运行"
        if filereadable(expand("%<"))
            "exec "! ./%<"
            exec "AsyncRun -raw -cwd=$(VIM_FILEDIR) $(VIM_FILEDIR)/$(VIM_FILENOEXT)"
        endif
    elseif &filetype == 'java'
        exec "!javac %" 
        exec "!java %<"
    elseif &filetype == 'sh'
        :!./%
    elseif &filetype == 'python'
        if has('win32')
            exec "!python %"
        else
            exec "!python3 %"
        endif
    endif
endfunc

"C,C++的调试
"map <F4> :call Rungdb()<CR>
func! Rungdb()
exec "w"
exec "!g++ -std=c++11 % -g -o %<"
"如果编译成功了有了可执行文件才调试"
if filereadable(expand("%<"))
    exec "!gdb ./%<"
endif
endfunc


"--------------------------------------------------------------------------
" 实用设置
"--------------------------------------------------------------------------
" 设置当文件被改动时自动载入
set autoread
" quickfix模式
"autocmd FileType c,cpp map <buffer> <leader><space> :w<cr>:make<cr>
"代码补全 
set completeopt=longest,preview,menu 
"共享剪贴板  
set clipboard+=unnamed 
"从不备份  
set nobackup
"make 运行
:set makeprg=g++\ -Wall\ \ -std=c++11\ %
set noshowmode       "状态栏不显示模式
"自动保存
set autowrite
set ruler                   " 打开状态栏标尺
set cursorline              " 突出显示当前行
set magic                   " 设置魔术
" 设置在状态行显示的信息
set foldcolumn=0
set foldmethod=indent 
set foldlevel=3 
" 去掉输入错误的提示声音
if has('win32')
    set vb t_vb=
    au GUIEnter * set t_vb= "GuiEnter这一行为关闭闪屏，因为关闭声音后，vim会用闪屏提示，多按一次esc也会闪
else
    set noeb
endif
" 在处理未保存或只读文件的时候，弹出确认
set confirm
" 自动缩进
set autoindent
set smartindent    "智能的选择对起方式；
" Tab键的宽度
set tabstop=4
" 统一缩进为4
set softtabstop=4
set shiftwidth=4
set cindent
"set cinoptions={0,1s,t0,n-2,p2s,(03s,=.5s,>1s,=1s,:1s
"set cinoptions+=g0,(1s,:0
"set cinoptions=g0,:0,(0,l1
"http://vimcdoc.sourceforge.net/doc/indent.html
set cinoptions=g0,(0,W4,l1,N-s,E-s,t0,j1,J1
"set cinoptions={0,1s,t0,n-2,p2s,(01s,=.5s,>1s,=1s,:1s

" 用空格代替制表符
set expandtab
" 在行和段开始处使用制表符
set smarttab
" 历史记录数
set history=1000
"禁止生成临时文件
set nobackup
set noswapfile
"搜索忽略大小写
"set ignorecase
"搜索逐字符高亮
set hlsearch
set incsearch
"行内替换
set gdefault
"编码设置
set enc=utf-8
set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936
" 我的状态行显示的内容（包括文件类型和解码）
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
"set statusline=[%F]%y%r%m%*%=[Line:%l/%L,Column:%c][%p%%]
" 命令行（在状态行下）的高度，默认为1，这里是2
set cmdheight=2
" 侦测文件类型
filetype on
" 载入文件类型插件
filetype plugin on
" 为特定文件类型载入相关缩进文件
filetype indent on
" 保存全局变量
set viminfo+=!
" 带有如下符号的单词不要被换行分割
set iskeyword+=_,$,@,%,#,-
" 字符间插入的像素行数目
set linespace=0
" 增强模式中的命令行自动完成操作
set wildmenu
" 使回格键（backspace）正常处理indent, eol, start等
set backspace=2
" 允许backspace和光标键跨越行边界
set whichwrap+=<,>,h,l
set selection=exclusive
set selectmode=mouse,key
" 通过使用: commands命令，告诉我们文件的哪一行被改变过
set report=0
" 在被分割的窗口间显示空白，便于阅读
set fillchars=vert:\ ,stl:\ ,stlnc:\
" 高亮显示匹配的括号
set showmatch
" 匹配括号高亮的时间（单位是十分之一秒）
set matchtime=1
" 光标移动到buffer的顶部和底部时保持3行距离
set scrolloff=3
" 高亮显示普通txt文件（需要txt.vim脚本）
au BufRead,BufNewFile *  setfiletype txt


"--------------------------------------------------------------------------
"  
"--------------------------------------------------------------------------
"vim中大小写转化的命令是gu或者gU
"只转化某个单词
"guw 、gue
"gUw、gUe
"将当前光标所在的单词转换成 大写格式
inoremap <M-u> <Esc>mgviwU`gli
inoremap <M-i> <Esc>mgviwu`gli
"将当前光标所在的单词转换成 小写格式
nnoremap <M-u> mgviwU`g
nnoremap <M-i> mgviwu`g

"打开文件类型检测, 加了这句才可以用智能补全
"set completeopt=longest,menu


"--------------------------------------------------------------------------
" 
"--------------------------------------------------------------------------
if &term =~ '256color'  
    " disable Background Color Erase (BCE) so that color schemes  
    "       " render properly when inside 256-color tmux and GNU
    "       screen.  
    "             " see also
    "             http://snk.tuxfamily.org/log/vim-256color-bce.html  
    "set t_ut=  
endif  
"
"if exists('$TMUX')
    "set term=screen-256color
"endif


" 设置配色方案
if !has('gui_running')
    set t_Co=256
endif

if !has('nvim')
    if has('win32')
        set term=win32
    else
        "set term=screen-256color
        "set term=xterm-256color
    endif
endif

"colorscheme codeschool
colorscheme wombat256


"-----------------------------------------------------
" netrw
"-----------------------------------------------------
let g:netrw_liststyle = 1
let g:netrw_winsize = 25
let g:netrw_list_hide = '\.swp\($\|\t\),\.py[co]\($\|\t\),\.o\($\|\t\),\.bak\($\|\t\),\(^\|\s\s\)\zs\.\S\+'
let g:netrw_sort_sequence = '[\/]$,*,\.bak$,\.o$,\.info$,\.swp$,\.obj$'
let g:netrw_preview = 0
"let g:netrw_special_syntax = 1
let g:netrw_sort_options = 'i'

if isdirectory(expand('~/.vim'))
	let g:netrw_home = expand('~/.vim')
endif

"let g:netrw_timefmt = "%Y-%m-%d %H:%M:%S"

"let g:netrw_banner=0 
"let g:netrw_browse_split=4   " open in prior window
"let g:netrw_altv=1           " open splits to the right
"let g:netrw_liststyle=3      " tree view
"let g:netrw_list_hide=netrw_gitignore#Hide()


"--------------------------------------------------------------------------
" 环境恢复
"--------------------------------------------------------------------------
" 设置环境保存项
set sessionoptions="blank,globals,localoptions,tabpages,sesdir,folds,help,options,resize,winpos,winsize"
" 保存 undo 历史。必须先行创建 .undo_history/
set undodir=~/.undo_history/
set undofile
" 保存快捷键
nnoremap <Leader>ss :mksession! ~/.my.vim<cr> :wviminfo! ~/.my.viminfo<cr>
"nnoremap <leader>sv :mksession! ~/.my.vim<cr>
" 恢复快捷键
nnoremap <leader>rs :source ~/.my.vim<cr> :rviminfo ~/.my.viminfo<cr>
"nnoremap <leader>rs :source ~/.my.vim<cr>


"--------------------------------------------------------------------------
" 
"--------------------------------------------------------------------------
nnoremap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nnoremap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>

nnoremap <Leader>se :e $MYVIMRC<CR>
"nnoremap <Leader>se :e ~/.vimrc<CR>
"nnoremap <Leader>ss :source $MYVIMRC<CR>

:iabbrev @@ liang.feng@quanshi.com
:iabbrev //// ///////////////////////////////////////////////////////////////////


"--------------------------------------------------------------------------
" 
"--------------------------------------------------------------------------
"在下一个括号内(inside next parentheses)
onoremap in( :<C-U>normal! f(vi(<CR>
onoremap in" :<C-U>normal! f"lvi"<CR>
onoremap in' :<C-U>normal! f'lvi'<CR>
onoremap in{ :<C-U>normal! f{vi{<CR>
onoremap in< :<C-U>normal! f<vi<<CR>
"在上一个括号内(inside last parentheses)
onoremap il( :<C-U>normal! F)vi)<CR>
onoremap il" :<C-U>normal! F"hvi"<CR>
onoremap il' :<C-U>normal! F'hvi'<CR>
onoremap il} :<C-U>normal! F}vi}<CR>
onoremap il> :<C-U>normal! F>vi><CR>


"--------------------------------------------------------------------------
" 
"--------------------------------------------------------------------------
"调整光标的形状
"在默认情况下，当通过 Tmux 运行 Vim 时，无论当前 Vim
"是处于插入模式、可视模式还是其他模式，光标的形状都是一样的。这样就很难判断当前的
"Vim 模式是什么。若要避免这个问题，就需要让 Tmux 通知 iTerm
"更新光标的形状。为此，需要将以下配置加入到文件 ~/.vimrc 中。
"if exists('$ITERM_PROFILE')
    "if exists('$TMUX') 
        "let &amp_SI = "<Esc>[3 q"
        "let &amp_EI = "<Esc>[0 q"
    "else
        "let &amp_SI = "<Esc>]50;CursorShape=1x7"
        "let &amp_EI = "<Esc>]50;CursorShape=0x7"
    "endif
"end


"--------------------------------------------------------------------------
" inside terminal 
"--------------------------------------------------------------------------
if has('terminal') || has('nvim')
    if has('unix')
        if has('nvim')
            nnoremap <silent> <Leader>tm :term zsh<CR> :startinsert<CR>
        else
            nnoremap <silent> <Leader>tm :term zsh<CR>
        endif
    else
        if has('nvim')
            nnoremap <silent> <Leader>tm :term powershell<CR> :startinsert<CR>
        else
            nnoremap <silent> <Leader>tm :term powershell<CR>
        endif
    endif

    if !has('nvim')
        tnoremap <silent> <Leader>g exit<CR><C-w>:q!<CR>
    else
        tnoremap <silent> <Leader>g exit<CR>
    endif

    tnoremap <Leader><Tab> <C-w><C-w>
endif


"--------------------------------------------------------------------------
" toggle quickfix 
"--------------------------------------------------------------------------
"func MyToggle_Quickfix()
"    function! s:WindowCheck(mode)
"        if getbufvar('%', '&buftype') == 'quickfix'
"            let s:quickfix_open = 1
"            return
"        endif
"        if a:mode == 0
"            let w:quickfix_save = winsaveview()
"        else
"            call winrestview(w:quickfix_save)
"        endif
"    endfunc
"    let s:quickfix_open = 0
"	windo call s:WindowCheck(0)
"	if s:quickfix_open == 0
"		"exec 'botright copen '.a:size
"        copen
"		"wincmd k
"	else
"		cclose
"	endif
"endfunc
"nnoremap <silent> <Leader>ww :call MyToggle_Quickfix()<CR>


"--------------------------------------------------------------------------
" auto close pair ( { [ ' "
"--------------------------------------------------------------------------
function! AutoClosePair()
    inoremap ( ()<Esc>i
    inoremap ) <c-r>=ClosePair(')')<CR>
    inoremap { {}<Esc>i
    inoremap } <c-r>=ClosePair('}')<CR>
    inoremap [ []<Esc>i
    inoremap ] <c-r>=ClosePair(']')<CR>
    inoremap " ""<Esc>i
    inoremap ' ''<Esc>i
endfunction

function! RestoreClosePair()
    inoremap ( (
    inoremap { {
    inoremap [ [
    inoremap " "
    inoremap ' '
endfunction

function! ClosePair(char)
    if getline('.')[col('.') - 1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endfunction

"call AutoClosePair()
"nnoremap <Leader>nau :call RestoreClosePair()<CR>
"nnoremap <Leader>hau :call AutoClosePair()<CR>

