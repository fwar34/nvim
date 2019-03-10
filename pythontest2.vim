"--------------------------------------------------------------------------
" http://candidtim.github.io/vim/2017/08/11/write-vim-plugin-in-python.html
"--------------------------------------------------------------------------
"let s:root_dir = expand('<sfile>:h')
let s:plugin_root_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')

python << PYTHON
import vim
import sys
import os.path
import normpath
import join

plugin_root_dir = vim.eval('s:plugin_root_dir')
python_root_dir = normpath(join(plugin_root_dir, '..', 'python'))
print(python_root_dir)
sys.path.insert(0, python_root_dir)
import sample
PYTHON
