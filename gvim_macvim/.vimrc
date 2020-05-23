" global nvim config dir "{{{
if has("unix")
	let g:vim_config_dir = fnameescape(expand("$HOME/.vim"))
elseif has("win32")
	let g:vim_config_dir = fnameescape(expand("$USERPROFILE/vimfiles"))
endif "}}}

func! RegEscape(str) "{{{
	return escape(a:str,'^$.*?/\[]')
endfunc "}}}

func! s:isfile(p)
	return findfile(a:p) != ""
endfunc

func! AddToPATH(dir,front) "{{{
	if ! isdirectory(a:dir)
		return
	endif
	if has('unix')
		let psep = ':'
		let nsep = '/'
	elseif has('win32')
		let psep = ';'
		let nsep = '\\'
	else
		return
	endif
	let newdir = substitute(fnamemodify(a:dir,':p'),nsep.'$','','')
	let pathList = split($PATH,psep)
	if match(pathList,'^'.RegEscape(newdir).'$') == -1
		if a:front
			let $PATH = newdir.psep.$PATH
		else
			let $PATH .= psep.newdir
		endif
	endif
endfunc "}}}

"{{{ general configuration
set fileformat=unix
set nocompatible
set nonumber
set laststatus=2
set undolevels=100 "less undo levels to save mem
set updatecount=500 "less writing swp to disk
set autoindent smartindent
set backspace=start,eol,indent
set shiftwidth=4 tabstop=4 softtabstop=4 "tab style
"set expandtab
set maxmempattern=10240 mm=204800 "enlarge cache
set hlsearch incsearch
set noruler "set it in statusline, don't need here.
set fileencodings=ucs-bom,utf8,gbk,eshift-jis,uc-kr encoding=utf-8 ff=unix
set cursorline             "highlight line under current cursor
set noshowmatch matchtime=3  "flash the other matching half of brackets
set timeoutlen=330         "time waited for mapped key sequence 
set lazyredraw
set redrawtime=2500
set foldmethod=marker foldnestmax=9 "fold text by specific pattern.
set noautowrite autoread modeline "auto detect file modified, # vim: ... : settings 
set wildmenu "enhanced command line completion
set wildignore=*.o,*~,*.pyc,*.pyo,._*,$~*,*.bak,*.swp,.DS_Store "enhanced cmd completion
set ignorecase "ignore case when searching
set smartcase "override ignorecase when search containing uppper cases
set wildmode=longest:full,full
set nohidden wrap  "wrap text
set whichwrap+=<,>  "left, right arrow move cursor to next/prev line when
					"at last/first char.
set noerrorbells
set nobackup nowritebackup noundofile
set cmdheight=1 "set to default
set scrolloff=1 "num of lines preserved when cursor moving out of current screen.
set ttyfast ttymouse=xterm2
set noshowcmd
set shortmess+=aOTI "compact messages
set background=light
set complete-=i
set showtabline=2 "0:never 1:when 2:always
set foldcolumn=0
set listchars=    "clean listchars for console
set nopaste
set viminfo='100,<100,:20,s500,h,%
" ':max number of previously edited files
" ":max number of lines saved for each register (deprecated)
" <:max number of lines saved for each register
" /:max number of search hist
" s:max size of an item in kb
" ::max number of items in cmd hist
" h:disable hlsearch when loading viminfo
" %:restore buffer list when started without file name argument
set browsedir=buffer
set previewheight=5
set splitbelow splitright
hi SpecialKey guifg=#B8B8F8

"}}}

" add local unix bin to PATH {{{
if has('unix')
	call AddToPATH(expand('~/bin'),0)
endif "}}}

if has('win64')
	let pythonhome=fnamemodify(expand('$VIM/../python-2.7.18.amd64'),':p')
	let pythondll=fnamemodify(expand('$VIM/../python-2.7.18.amd64/python27.dll'),':p')
	if isdirectory(pythonhome) && s:isfile(pythondll)
		let &pythonhome=pythonhome
		let &pythondll=pythondll
	endif
elseif has('win32')
	let pythonhome=fnamemodify(expand('$VIM/../python-2.7.18'),':p')
	let pythondll=fnamemodify(expand('$VIM/../python-2.7.18/python27.dll'),':p')
	if isdirectory(pythonhome) && s:isfile(pythondll)
		let &pythonhome=pythonhome
		let &pythondll=pythondll
	endif
" elseif has('macvim') && has('python3')
" 	let pythonthreehome=g:vim_config_dir . '/pypy3'
" 	let pythonthreedll=pythonthreehome . '/bin/libpypy3-c.dylib'
" 	if isdirectory(pythonthreehome) && s:isfile(pythonthreedll)
" 		let &pythonthreehome=pythonthreehome
" 		let &pythonthreedll=pythonthreedll
" 	endif
endif

"{{{ gui configuration
if has("gui_running")
	set nopaste
	set number
	set foldcolumn=2
	set guioptions+=mTg "m:show menu, T:toolbar, g:grey menu 
	set guioptions+=e "e:gui tab
	set guioptions-=t "t:tear off menu
	set guioptions-=c "c:console dialog instead of popup menu
	set mousehide "hide mouse when typing
	set list "show invisible chars
	set listchars+=tab:│┈
	if has("macunix")
		set guifont=Menlo:h14 "use set guifont=* to select
	endif
	if has("win32")
		set tabline=%!Tabline()
		set guioptions-=e "e:gui tab
		"set clipboard=unnamed
		if !exists('s:_gui_opened')|set lines=26|endif
		set guifont=Source_Code_Pro:h11,Courier\ New:h11
	else
		if !exists('s:_gui_opened')
			set lines=30
		endif
	endif
	hi TabLineFill guifg=#487898
	if !exists('s:_gui_opened')|set columns=88|endif
	let s:_gui_opened=1
endif
"}}}

syntax enable
filetype off
"{{{ vbundle 
let s:vundle=0
let s:vundledir = g:vim_config_dir."/bundle/Vundle.vim"
if finddir(s:vundledir) != ""
	exe "set rtp+=".s:vundledir
	let s:vundle=1
endif
" begin vundle {{{
if s:vundle==1
	call vundle#begin(g:vim_config_dir."/bundle")
	Plugin 'VundleVim/Vundle.vim'
	Plugin 'scrooloose/syntastic'
	Plugin 'c.vim'
	Plugin 'lfilho/cosco.vim' " VIM colon and semicolon insertion bliss 
	Plugin 'renamer.vim'
	if has('patch-8.0.1453')
		Plugin 'fatih/vim-go'
	endif
	Plugin 'tComment' "[v]gc [n]gcc
	Plugin 'bash-support.vim',{'pinned':1}
	Plugin 'perl-support.vim',{'pinned':1}
	Plugin 'terryma/vim-multiple-cursors' " <c-n> search and select multiple
	Plugin 'majutsushi/tagbar' " :Tagbar
	Plugin 'Lokaltog/vim-easymotion' " \\w \\f
"	Plugin 'Konfekt/FastFold'
	Plugin 'tpope/vim-characterize' " [n]ga
	Plugin 'ctrlpvim/ctrlp.vim' " [n]<c-p> browse files
	Plugin 'mattn/emmet-vim' "<c-y>,
	Plugin 'Valloric/MatchTagAlways'
"	Plugin 'junegunn/fzf.vim'
	Plugin 'tpope/vim-eunuch' " Delete Unlink Move Rename Chmod Mkdir Cfind Wall SudoWrite SudoEdit
	Plugin 'tpope/vim-surround' " cs ds 
	if $TERM!~"^vt"
		if has("lua") "&& has('win32')
			if v:version > 703 || (v:version == 703 && has("patch885"))
				Plugin 'Shougo/neocomplete'
			endif
		endif
	endif
	if has('win32')
		Plugin 'Shougo/vimproc.vim'
		Plugin 'Shougo/vimshell.vim'
		Plugin 'Shougo/unite.vim'
	endif
	Plugin 'arzg/vim-colors-xcode'
	call vundle#end()
endif "}}}
"}}}

filetype plugin on
filetype indent on


func! s:findplugin(pluginName) "{{{
	let rtplist = filter(map(split(&rtp,","),
				\'split(v:val,"[\\/]")'),
				\'v:val[-1] == a:pluginName')
	if len(rtplist)>0
		let plugindir = join((has('win32')?[]:['/'])+rtplist[0]+['plugin','*.vim'],"/")
		if glob(plugindir) != ""
			return 1
		endif
	endif
	return 0
endfunc "}}}

func! s:islinux() "{{{
	return isdirectory('/proc/'.getpid())
endfunc
"}}}

func! s:isarm() "{{{
	return glob('/lib/ld-linux-arm*.so.?')!=""
endfunc
"}}}

func! s:str2uninr(s) "{{{
	let l:slist = split(a:s,'.\@=')
	let l:outlist = []
	let l:curridx = 0
	let l:totalchrs = len(slist)
	while curridx < totalchrs
		let c = char2nr(slist[curridx])
		if c > 255
			call add(outlist, printf('\u%04X',c))
		elseif c == 92 && (totalchrs - curridx) > 5 " '\' is 92
			let uniseq = join(slist[curridx:(curridx+5)],'')
			if uniseq =~ '^\\u[[:xdigit:]]\{4\}$'
				call add(outlist,nr2char(str2nr(uniseq[2:5],16)))
				let curridx+=6
				continue
			endif
		else
			call add(outlist, slist[curridx])
		endif
		let curridx+=1
	endwhile
	return join(outlist,'')
endfunc

func! s:str2uninr_visual_replace()
	let l:temp = @x
	normal gv"xy
	let @x = <SID>str2uninr(@x)
	normal gv"xp
	let @x = l:temp
endfunc
"}}}

func! s:eatchar(pat) "{{{
   let c = nr2char(getchar(0))
   return (c =~ a:pat) ? '' : c
endfunc "}}}

func! Subfield(lnum,field,pat,sub,flag) "{{{
	line = getline(lnum)
	if empty(line)
		return ''
	endif
	fields = split(field,'\s\+')
	if field > len(fields)
		return line
	endif
	line = substitute(line,pat,sub,flag)
	return line
endfunc "}}}

func! s:rstrip() "{{{
	if col('.') > 1 && col('.') == col('$')
		let p = getpos('.')
		exec 's/\s*$//'
		let e = col('$')
		let p[2] = e
		call setpos('.',p)
	endif
	return ''
endfunc "}}}

"{{{ function Cut()
if has('python') " Cut() in Python
"{{{ prepare funcs for python cut

python <<_EOF_
import vim
def GetRange():
    buf = vim.current.buffer
    (lnum1, col1) = buf.mark('<')
    (lnum2, col2) = buf.mark('>')
    lines = vim.eval('getline({}, {})'.format(lnum1, lnum2))
    if len(lines) == 1:
        lines[0] = lines[0][col1:col2 + 1]
    else:
        lines[0] = lines[0][col1:]
        lines[-1] = lines[-1][:col2 + 1]
    return "\n".join(lines)
_EOF_

func! GetRange()
python <<_EOF_
print GetRange()
_EOF_
endfunc

"}}}
"{{{prepare class for python cut

python <<_EOF_
import vim
import re
class Cut(object):
	sglColPtn = re.compile(r'^-?\d+$')
	rngColPtn = re.compile(r'^-?\d+:-?\d+$')
	isep = None
	osep = '\t'
	collist = []

	def __init__(self, collist=[]):
		self.setcols(collist)
	def setcols(self, collist):
		if self.collist != collist:
			self.collist = collist
			self._setcols()
	def _setcols(self):
		self.colslices = []
		self.osep = '\t'
		for c in self.collist:
			if self.sglColPtn.match(c):
				self.colslices.append(slice(int(c),int(c)+1))
			elif self.rngColPtn.match(c):
				self.colslices.append(slice(*(int(i) for i in c.split(':'))))
			elif c == '-s':
				self.osep = ' '
			else:
				raise ValueError('Invalid column: {0}'.format(c))
	def cutcols(self, collist):
		self.setcols(collist)
		self.cutline()
	def cutline(self):
		fs = vim.current.line.split(self.isep)
		vim.current.line = self.osep.join(
			j for i in self.colslices for j in fs[i]
		)

pycut = Cut()
_EOF_

"}}}
func! Cut(...) "{{{ cut in python
"Usage :call Cut [-s] colnum|colstart:colend ... 

python <<_EOF_
args = vim.eval('a:000')
pycut.cutcols(args)

_EOF_
endfunc "}}}
else " Cut() in Vimscript
func! Cut(...) "{{{
	let line=getline('.')
	let linelist = split(line,'\s\+')
	let linelistlen = len(linelist)
	let outputlist = []
	for i in a:000
		if i =~ '\v^-?\d+$'
			try
				let field = linelist[i]
			catch
				continue
			endtry
			call add(outputlist,field)
		elseif i =~ '\v^(-?\d+)?:(-?\d+)?$'
			let outputlist += outputlist + linelist[i]
		elseif i[0]=='`'
			let field = i[1:]
			call add(outputlist,field)
		else
			continue
		endif
	endfor
	let outputline = join(outputlist,"\t")
	s/^.*$/\=outputline/
endfunc
"}}}
endif 
command! -range -nargs=+ Cut <line1>,<line2>call Cut(<f-args>)
"}}}

func! Tabline() "{{{
  let s = []
  let tpnr = tabpagenr('$')
  let tpnrc = tabpagenr()
  if tpnr > 1
	  let closeb = ' %999X✗'
  else
	  let closeb = ' '
  endif
  for i in range(tpnr)
    let tab = i + 1
    let bufna = bufname(tabpagebuflist(tab)[tabpagewinnr(tab) - 1])
	call add(s,printf(
				\"%%%dT%s %s",
				\tab,
				\tab==tpnrc?'%#TabLineSel#':'%#TabLine#',
				\bufna!=''?fnamemodify(bufna, ':t').closeb:'[No Name]'.closeb
				\)
				\)
    " let bufmodified = getbufvar(bufnr, "&mod")
  endfor

  call add(s, '%#TabLineFill#%X')
  return join(s,"")
endfunc
"}}}

function! SetBackgroundMode(...) "{{{
    let s:new_bg = "light"
    if has("macunix")
        let s:mode = systemlist("defaults read -g AppleInterfaceStyle")[0]
        if s:mode ==? "dark"
            let s:new_bg = "dark"
        else
            let s:new_bg = "light"
        endif
    endif
    if &background !=? s:new_bg
        let &background = s:new_bg
    endif
	if &background == 'dark'
		try
			colorscheme xcodedark
		endtry
	endif
endfunction "}}}

"{{{ input comma quote pair

func! s:inputPairCheck() "{{{
	let nextChar = getline('.')[col('.')-1]
	if nextChar =~ '^\%([[:space:][:punct:]]\|\)$'
		return 1
	endif
	return 0
endfunc "}}}
func! s:skipClosureCheck(right) "{{{
	let nextChar = getline('.')[col('.')-1]
	if nextChar == a:right
		return 1
	else
		return 0
	endif
endfunc "}}}
func! s:deletePairCheck() "{{{
	let roundChars = getline('.')[(col('.')-2):(col('.')-1)]
	if roundChars =~ '\%(()\|[]\|{}\|''''\|""\)'
		return 1
	else
		return 0
	endif
endfunc "}}}
func! s:inputQuote(quote) "{{{

	let cC = col('.')
	let li = getline('.')
	let nC = li[cC-1]

	if nC == a:quote
		call feedkeys("\<Right>",'n')
		return ''
	endif

	let pC = li[cC-2]
	if pC == a:quote
		return a:quote
	endif

	" let pCs = synIDattr(synID(line('.'),pC,0), 'name')
	" if pCs =~ '\(String\|Quotes?\)$'
	" 	return a:quote
	" endif

	" if next char is space or empty
	if nC =~ '^\([[:space:]]\|\)$'
		" if prev char is space, punct or empty
		if pC =~ '^\%([[:space:]]\|[[:punct:]]\|\)$' 
			call feedkeys(a:quote.a:quote."\<Left>",'n')
			return ''
		else
			return a:quote
		endif
	endif

	return a:quote

endfunc "}}}

inoremap <buffer> <expr> ( <SID>inputPairCheck()?"()\<Left>":"("
inoremap <buffer> <expr> { <SID>inputPairCheck()?"{}\<Left>":"{"
inoremap <buffer> <expr> [ <SID>inputPairCheck()?"[]\<Left>":"["
inoremap <buffer> <expr> ) <SID>skipClosureCheck(")")?"\<Right>":")"
inoremap <buffer> <expr> ] <SID>skipClosureCheck("]")?"\<Right>":"]"
inoremap <buffer> <expr> } <SID>skipClosureCheck("}")?"\<Right>":"}"
inoremap <buffer> <expr> <BS> <SID>deletePairCheck()?"\<Del>\<BS>":"\<BS>"
inoremap <buffer> " <C-r>=<SID>inputQuote('"')<CR>
inoremap <buffer> ' <C-r>=<SID>inputQuote('''')<CR>

"}}}

"{{{ Plugin Config: vim-go
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_disable_autoinstall=1
let s:goutils_osx  = g:vim_config_dir."/goutils_osx"
let s:goutils_linux = g:vim_config_dir."/goutils_linux"
let s:goutils_arm  = g:vim_config_dir."/goutils_arm"
let s:goutils_win  = g:vim_config_dir."\\goutils_win".(has("win64")?"64":"32")

if has("macunix")
	call AddToPATH(s:goutils_osx,0)
elseif has("unix") && s:islinux()
	if s:isarm()
		call AddToPATH(s:goutils_arm,0)
	else
		call AddToPATH(s:goutils_linux,0)
	endif
elseif has("win32")
	call AddToPATH(s:goutils_win,0)
endif
"}}}

"{{{ Plugin Config: syntastic
if has("macunix")
	call AddToPATH(g:vim_config_dir."/py2osx/bin",1)
elseif has("unix") && <SID>islinux()
	call AddToPATH(g:vim_config_dir."/py2linux/bin",1)
endif
let g:syntastic_enable_perl_checker=1
let g:syntastic_perl_checkers=['perl']
let g:syntastic_python_checkers=["flake8","pylint","python"]
let g:syntastic_go_checkers=["gofmt","go"]
let g:syntastic_python_pylint_args = '--indent-string=$''\t'' --ignore-docstrings=y'
let g:syntastic_python_python_exec = "python2.7" 
highlight SyntasticErrorLine guibg=#2f0000
if(v:version>=800)
	set signcolumn=yes
endif
"}}}

"{{{ Plugin Config: tagbar
let g:tagbar_width = 26
let g:tagbar_autofocus = 1
let g:tagbar_compact = 1
let g:tagbar_indent = 1

"{{{ setup ctags binary location for no-linux
if has('macunix')
	let s:ctags_bin = "/ctags_osx"
elseif has('win32')
	let s:ctags_bin = "/ctags".(has("win64")?"64":"32").".exe"
	let $CTAGS = g:vim_config_dir."/_ctags"
elseif has('unix') && s:islinux()
	if s:isarm()
		let s:ctags_bin = "/ctags_arm"
	else
		let s:ctags_bin = "/ctags_linux"
	endif
endif
if exists('s:ctags_bin')
	let s:ctags_bin = g:vim_config_dir.s:ctags_bin
	if findfile(s:ctags_bin) != ""
		let g:tagbar_ctags_bin = s:ctags_bin
	endif
endif
"}}}
"{{{ go
if has('unix')
	let g:tagbar_type_go = {
				\ 'ctagstype' : 'go',
				\ 'kinds'     : [
				\ 'p:package',
				\ 'i:imports:1',
				\ 'c:constants',
				\ 'v:variables',
				\ 't:types',
				\ 'n:interfaces',
				\ 'w:fields',
				\ 'e:embedded',
				\ 'm:methods',
				\ 'r:constructor',
				\ 'f:functions'
				\ ],
				\ 'sro' : '.',
				\ 'kind2scope' : {
				\ 't' : 'ctype',
				\ 'n' : 'ntype'
				\ },
				\ 'scope2kind' : {
				\ 'ctype' : 't',
				\ 'ntype' : 'n'
				\ },
				\ }
elseif has('win32')
	let g:tagbar_type_go = {
				\ 'ctagstype': 'go',
				\ 'kinds' : [
				\'p:package',
				\'f:function',
				\'v:variables',
				\'t:type',
				\'c:const'
				\]
				\}
	" if has('win64')
	" 	let g:tagbar_type_go['ctagsbin'] = expand('$VIM/ctags-go64.exe')
	" else
	" 	let g:tagbar_type_go['ctagsbin'] = expand('$VIM/ctags-go32.exe')
	" endif
endif "}}}
"{{{ obj-c
let g:tagbar_type_objc = {
    \ 'ctagstype' : 'ObjectiveC',
    \ 'kinds'     : [
        \ 'i:interface',
        \ 'I:implementation',
        \ 'p:Protocol',
        \ 'm:Object_method',
        \ 'c:Class_method',
        \ 'v:Global_variable',
        \ 'F:Object field',
        \ 'f:function',
        \ 'p:property',
        \ 't:type_alias',
        \ 's:type_structure',
        \ 'e:enumeration',
        \ 'M:preprocessor_macro',
    \ ],
    \ 'sro'        : ' ',
    \ 'kind2scope' : {
        \ 'i' : 'interface',
        \ 'I' : 'implementation',
        \ 'p' : 'Protocol',
        \ 's' : 'type_structure',
        \ 'e' : 'enumeration'
    \ },
    \ 'scope2kind' : {
        \ 'interface'      : 'i',
        \ 'implementation' : 'I',
        \ 'Protocol'       : 'p',
        \ 'type_structure' : 's',
        \ 'enumeration'    : 'e'
    \ }
\ }
"}}}
"{{{ css
let g:tagbar_type_css = {
			\ 'ctagstype' : 'Css',
			\ 'kinds'     : [
			\ 'c:classes',
			\ 's:selectors',
			\ 'i:identities'
			\ ]
			\ }
"}}}
"{{{ markdown
let g:tagbar_type_markdown = {
			\ 'ctagstype' : 'markdown',
			\ 'kinds' : [
			\ 'h:Heading_L1',
			\ 'i:Heading_L2',
			\ 'k:Heading_L3'
			\ ]
			\ }
"}}}
"{{{ ruby
let g:tagbar_type_ruby = {
			\ 'kinds' : [
			\ 'm:modules',
			\ 'c:classes',
			\ 'd:describes',
			\ 'C:contexts',
			\ 'f:methods',
			\ 'F:singleton methods'
			\ ]
			\ }
"}}}
"{{{ scala
let g:tagbar_type_scala = {
    \ 'ctagstype' : 'Scala',
    \ 'kinds'     : [
        \ 'p:packages:1',
        \ 'V:values',
        \ 'v:variables',
        \ 'T:types',
        \ 't:traits',
        \ 'o:objects',
        \ 'a:aclasses',
        \ 'c:classes',
        \ 'r:cclasses',
        \ 'm:methods'
    \ ]
\ }
"}}}
nnoremap <leader>t :silent! TagbarToggle<CR>
"}}}

"{{{ Plugin Config: neocomplete
let g:acp_enableAtStartup = 0 "auto popup
let g:neocomplete#enable_at_startup = 1 "enable by start
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
let g:neocomplete#sources#dictionary#dictionaries = {
	\ 'default' : '',
	\ 'vimshell' : $HOME.'/.vimshell_hist'
	\ } "dictionary
let g:neocomplete#keyword_patterns = {'default':'\h\w*'}
let g:neocomplete#enable_auto_select = 0
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {} |endif
if !exists('g:neocomplete#force_omni_input_patterns')
	let g:neocomplete#force_omni_input_patterns = {} |endif
let g:neocomplete#force_omni_input_patterns.php =  '\h\w*\|[^- \t]->\w*'
let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
func! s:_augroup_neocomplete()
augroup _neocomplete
au!
au FileType css setlocal omnifunc=csscomplete#CompleteCSS
au FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
au FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
au FileType python setlocal omnifunc=pythoncomplete#Complete
au FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
augroup END
func! s:closeOnVisible()
	if pumvisible()
		return neocomplete#close_popup()
	endif
	return ''
endfunc
inoremap <expr> <C-g> neocomplete#undo_completion()
inoremap <expr> <C-l> neocomplete#complete_common_string()
inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
inoremap <expr> <C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr> <BS> neocomplete#smart_close_popup()."\<C-h>"
"inoremap <expr> <CR> pumvisible()?neocomplete#close_popup()."\<CR>":"\<CR>"
if !exists('g:loaded_delimitMate')
inoremap <CR> <C-r>=<SID>closeOnVisible()<CR><C-r>=<SID>rstrip()<CR><CR>
else
imap <CR> <C-r>=<SID>closeOnVisible()<CR><C-r>=<SID>rstrip()<CR><Plug>delimitMateCR
endif
NeoCompleteEnable
endfunc
augroup _neocomplete
	au!
	au VimEnter * if exists('g:loaded_neocomplete')|
				\call s:_augroup_neocomplete()|
				\endif
augroup END "}}}

"{{{ Plugin Config: commentToggle
"if no tcomment installed
func! s:_augroup_commentToggle()
augroup commentToggle
	au!
	au FileType python,perl,sh nnoremap <buffer> <Leader>c I#<ESC>
	au FileType python,perl,sh nnoremap <buffer> <Leader>u :.s/^\v(\s*)#/\1/<CR>:nohlsearch<CR>
	au FileType python,perl,sh vnoremap <buffer> <Leader>c :s/^\v(\s*)/\1#/<CR>:nohlsearch<CR>
	au FileType python,perl,sh vnoremap <buffer> <Leader>u :s/^\v(\s*)#/\1/<CR>:nohlsearch<CR>
	au FileType vim nnoremap <buffer> \c I"<ESC>
	au FileType vim nnoremap <buffer> \u :.s/^\v(\s*)"/\1/<CR>:nohlsearch<CR>
	au FileType vim vnoremap <buffer> \c :s/^\v(\s*)/\1"/<CR>:nohlsearch<CR>
	au FileType vim vnoremap <buffer> \u :s/^\v(\s*)"/\1/<CR>:nohlsearch<CR>
	au FileType c,cpp,go nnoremap <buffer> <Leader>c I//<ESC>
	au FileType c,cpp,go nnoremap <buffer> <Leader>u :.s/^\v(\s*)\/\//\1/<CR>:nohlsearch<CR>
	au FileType c,cpp,go vnoremap <buffer> <Leader>c :s/^\v(\s*)/\1\/\//<CR>:nohlsearch<CR>
	au FileType c,cpp,go vnoremap <buffer> <Leader>u :s/^\v(\s*)\/\//\1/<CR>:nohlsearch<CR>
	au FileType dosbatch nnoremap <buffer> <Leader>c I::<ESC>
	au FileType dosbatch nnoremap <buffer> <Leader>u :.s/^\v(\s*)::/\1/<CR>:nohlsearch<CR>
	au FileType dosbatch vnoremap <buffer> <Leader>c :s/^\v(\s*)/\1::/<CR>:nohlsearch<CR>
	au FileType dosbatch vnoremap <buffer> <Leader>u :s/^\v(\s*)::/\1/<CR>:nohlsearch<CR>
augroup END
endfunc
augroup commentToggle
	au!
	au VimEnter * if !exists('g:loaded_tcomment')|
				\call s:_augroup_commentToggle()|
				\endif
augroup END
"}}}

"{{{ general remapping keys
if has("gui_running")
	inoremap <S-CR> <esc>A<CR>
	nnoremap <S-CR> O<esc>
	if !has('macunix')
		vnoremap <C-c> "+y
		vnoremap <C-v> "+p
		inoremap <C-b> <esc>"+pa
	endif
endif
inoremap jk <esc>
inoremap jl <esc>la
inoremap jh <esc>ha
nnoremap  o<esc>
nnoremap gs :echo synIDattr(synID(line("."), col("."), 1), "name")<CR>
"inoremap <leader>v "+pa
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <tab> :tabnext<CR>
nnoremap <S-tab> :tabprev<CR>
"nnoremap <expr><C-q> tabpagewinnr(2)?:tabclose<CR>
nnoremap <C-q> <C-w>q
nnoremap <M-j> mz:m+<CR>`z
nnoremap <M-k> mz:m-2<CR>`z
if has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
endif
nnoremap <leader>w :set wrap!<CR>
command! W w
command! Q q
vnoremap <silent> <leader>u :<C-u>call <SID>str2uninr_visual_replace()<CR>
" vnoremap <silent> <script> <leader>u <SID>str2uninr_visual_replace
" vnoremap <expr> <SID>setVisualStatuslineColor <SID>setVisualStatuslineColor()
" nnoremap <script> v v<SID>setVisualStatuslineColor
" nnoremap <script> V V<SID>setVisualStatuslineColor
" nnoremap <script> <c-v> <c-v><SID>setVisualStatuslineColor
inoremap ¥ \
cnoremap ¥ \
nnoremap ¥ \
"}}}

" Statusline {{{

" nr2char(22) -> ^V

"%F : full path to file     %m : modified indicator
"%r : read only indicator   %y : syntax highlighyting type
"%l : current line          %v : current column
"%n : buffer number

let s:previousMode = ''
let s:STLColor = {
			\'n':"%#NSTL#",
			\'i':"%#ISTL#",
			\'v':"%#VSTL#",
			\'V':"%#VVSTL#",
			\nr2char(22):"%#CVSTL#",
			\'R':"%#RSTL#", 
			\'c':"%#CSTL#"}
let s:MIColor = {
			\'n':"%#NMI#",
			\'i':"%#IMI#",
			\'v':"%#VMI#",
			\'V':"%#VVMI#",
			\nr2char(22):"%#CVMI#",
			\'R':"%#RMI#", 
			\'c':"%#CMI#"}
if has('macunix') && !has('gui_vimr')
	let s:STLColor = 
				\{'n':"hi StatusLine guibg=DarkSlateGray",
				\'i':"hi StatusLine guibg=OrangeRed4",
				\'v':"hi StatusLine guibg=#702863",
				\'V':"hi StatusLine guibg=#702863",
				\nr2char(22):"hi StatusLine guibg=#8E1652",
				\'R':"hi StatusLine guibg=#4578AB",
				\'c':"hi StatusLine guibg=#053061"}
endif

" highlight color for status line{{{
hi NSTL guibg=DarkSlateGray guifg=White " normal
hi ISTL guibg=OrangeRed4 guifg=White  " insert
hi VSTL guibg=#702863 guifg=White  " v select
hi VVSTL guibg=#702863 guifg=White " V select
hi CVSTL guibg=#D1740A guifg=White " C-V select
hi RSTL guibg=#4578AB guifg=White  " replace
hi CSTL guibg=DarkBlue guifg=White " command
hi NSTLi guibg=DarkSlateGray guifg=White gui=italic " normal
hi ISTLi guibg=OrangeRed4 guifg=White gui=italic  " insert
hi VSTLi guibg=#702863 guifg=White gui=italic  " v select
hi VVSTLi guibg=#702863 guifg=White gui=italic " V select
hi CVSTLi guibg=#D1740A guifg=White gui=italic " C-V select
hi RSTLi guibg=#4578AB guifg=White gui=italic  " replace
hi CSTLi guibg=DarkBlue guifg=White gui=italic " command
"}}}
" highlight color for modified indicator {{{
hi NMI guibg=DarkSlateGray guifg=LightBlue " normal
hi IMI guibg=OrangeRed4 guifg=LightBlue  " insert
hi VMI guibg=#702863 guifg=LightBlue  " v select
hi VVMI  guibg=#702863 guifg=LightBlue " V select
hi CVMI  guibg=#D1740A guifg=LightBlue " C-V select
hi RMI guibg=#4578AB guifg=LightBlue  " replace
hi CMI guibg=DarkBlue guifg=LightBlue " command
"}}}

func! Supnr(num) "{{{
	if !exists('s:snuv')
		let s:snuv = [0x2070,0xb9,0xb2,0xb3,0x2074,0x2075,0x2076,0x2077,0x2078,0x2079]
	endif
	return substitute(string(a:num),'\(\d\)',
				\'\=nr2char(s:snuv[str2nr(submatch(1))])','g')
endfunc "}}}
func! RedrawSTLColor(m) "{{{
	if s:previousMode != a:m
		let s:previousMode = a:m
		exe get(s:STLColor, a:m, "")
	endif
	return ''
endfunc "}}}
func! s:fixedSTL() "{{{
	if has('gui_running')
		let &l:stl = '%F%r'.Supnr(bufnr('%')).'%{(&mod==1)?"⁺":""}%=%{(&co>70)?strftime("┊%I:%M%p"):""}%{(&co>50)?"'.((&fenc!="")?"┊".&fenc:"│nil").'":""}┊'.toupper(&ff[0]).'┊'.((&ft!="")?&ft:"nil").'┊%l,%c┊%L%{RedrawSTLColor(mode())}'
	else
		set statusline=%F%m%r%=\|%n%{(&co>70)?strftime(\"\|%H:%M\"):''}%{(&co>50)?(&fenc!='')?'\|'.&fenc:'\|nil':''}\|%{toupper(&ff[0])}\|%{(&ft!='')?&ft:'nil'}\|%l,%c\|%L 
	endif
endfunc "}}}
function! s:bufnew_b_vars() "{{{
	if !exists('b:buffer_num') | let b:buffer_num = ""  | endif
	if !exists('b:buffer_enc') | let b:buffer_enc = "nil" | endif
	if !exists('b:buffer_ft')  | let b:buffer_ft = 'nil' | endif
	if has('win32') | let b:stlsep = '│' | else | let b:stlsep = '┊' | endif
endfunc "}}}
function! StatusLine() "{{{
	return s:STLColor[mode()]."%F%r%{b:buffer_num}".s:MIColor[mode()]."%{(&mod==1)?'⁺':''}%*".s:STLColor[mode()]."%=%{(&co>70)?b:stlsep.strftime('%H:%M'):''}%{b:stlsep}%{b:buffer_enc}%{b:stlsep}%{toupper(&ff[0])}%{b:stlsep}%2{b:buffer_ft}%{b:stlsep}%5(%l,%c%)%{b:stlsep}%L%*"
endfunc "}}}
function! StatusLineTerm() "{{{
	return "%F%r%{(&mod==1)?'+':''}%*%=|%n%{(&co>70)?strftime('|%H:%M'):''}|%{b:buffer_enc}|%{toupper(&ff[0])}|%2{b:buffer_ft}|%5(%l,%c%)|%L%*"
endfunc "}}}

"{{{ set statusline
augroup statusline
	if has('macunix') && !has('gui_vimr')
		au!
		au BufReadPost,BufWritePost,FileType,EncodingChanged * call <SID>fixedSTL()
		au FileType help,qf setlocal statusline=%f%=│%P│%L foldcolumn=0 number
	else
		setlocal statusline=%!StatusLine()
		au BufEnter * call s:bufnew_b_vars()
		au BufWinEnter,BufWritePost * let b:buffer_num = Supnr(bufnr())
		if has('gui_running')
			au BufWinEnter,BufWritePost * setlocal statusline=%!StatusLine()
		else
			au BufWinEnter,BufWritePost * setlocal statusline=%!StatusLineTerm()
		endif
		au BufReadPost,EncodingChanged * let b:buffer_enc = (&fenc!='')?toupper(&fenc):'nil'
		au FileType help,qf setlocal statusline=%h\ %f%=┊%n┊%P┊%L foldcolumn=0 number
		au FileType * let b:buffer_ft = (&ft!='')?&ft:'nil'
		au CmdlineEnter * redrawstatus
	endif
augroup END
"}}}

"}}}

augroup Commands "{{{
	command! -range -nargs=0 Trimdot :<line1>,<line2>s/\.\+\([^\.]\+\)\(\.\)\@=/ \1/ge|:nohl

func! s:vimrc() "{{{
	if has('unix')
		if findfile('~/.vimrc') != ''
			tabnew ~/.vimrc
		elseif findfile("$VIM/.vimrc") != ''
			tabnew $VIM/.vimrc
		endif
	elseif has('win32')
		if findfile('$VIM/../.vimrc') != ''
			tabnew $VIM/../.vimrc
		elseif findfile('~/_vimrc') != ''
			tabnew ~/_vimrc
		elseif findfile("$VIM/_vimrc") != ''
			tabnew $VIM/_vimrc
		endif
	endif
endfunc "}}}
	command! Vimrc call <SID>vimrc()
	command! -nargs=? NF echo len(split(getline('.'),<q-args>!=""?<q-args>:'\s\+'))
	command! -nargs=? NC echo len(split(getline('.')[0:col('.')-1],<q-args>!=""?<q-args>:'\s\+'))
	command! Bcd cd %:p:h
	command! Tdir tabedit =expand("%:p:h")
	nnoremap <leader>f :NF<cr>
	nnoremap <leader>c :NC<cr>
	command! -nargs=1 Enc e ++enc=<args>

	if has("macunix")
func! CDpf() "{{{
	let pfpath=system('osascript -e ''tell application id "com.cocoatech.PathFInder" to get POSIX path of target of the front finder window''')
	let pfpath=substitute(pfpath,"\n$","","")
	exe 'cd ' . fnameescape(pfpath)
endfunc "}}}
		command! CDpf call CDpf()
	endif

if has('unix')
command! -range=% -nargs=+ Cut <line1>,<line2>!sed 's/[[:space:]][[:space:]]*//g'|cut -d <args>|tr  '\t'
command! -range=% -nargs=+ Cut2 <line1>,<line2>!sed 's/[[:space:]][[:space:]]*//g'|cut -d <args>|column -s -t
command! -range=% -nargs=* Sort <line1>,<line2>!sed 's/[[:space:]][[:space:]]*//g'|sort -t <args>|tr  '\t'
command! -range=% -nargs=* Sort2 <line1>,<line2>!sed 's/[[:space:]][[:space:]]*//g'|sort -t <args>|column -s -t
endif
augroup END "}}}

augroup python_style "{{{

	au!

	au FileType python syn keyword pythonBuiltin self
	au FileType python setlocal tabstop=4 noexpandtab

func! s:checkPrevComma() "{{{
	" this function assumes itself 
	" to be called imediately after insert a comma
	" thus it must called in ',<C-r>=<SID>checkPrevComma()' fashion
	let l:col = col('.')
	if synIDattr(synID(line('.'), col('.')-1,0),'name') =~ '\%(String\|Comment\|Quotes\)$'
		return ''
	endif
	return ' '
endfunc "}}}
	au FileType python inoremap <buffer> , ,<C-r>=<SID>checkPrevComma()<CR>

	if has('gui_running')
	au FileType python highlight BadWhitespace guibg=#F2DAE8
	au FileType python match BadWhitespace /\s\+$/
	endif

augroup END "}}}

augroup go_style "{{{
	au!

func! SetGOPATH() "{{{
	if has('unix')
		let sep = '/'
		let root = '/'
	elseif has('win32')
		let sep = '\'
		let root = ''
	else
		return
	endif
	let currentPathList = split(expand('%:p:h'),sep)
	let srcPos = index(currentPathList,'src')
	if srcPos == -1| return| endif
	let gopath = root . join(currentPathList[0:srcPos-1],sep)
	if $GOPATH == ''
		let $GOPATH = gopath
	else
		let $GOPATH = join(add(filter(split($GOPATH,':'),'v:val!=gopath'),gopath),':')
	endif
endfunc "}}}
func! s:vimGoNMap() "{{{
nmap <buffer> <Leader>s <Plug>(go-implements)
nmap <buffer> <Leader>i <Plug>(go-info)
nmap <buffer> <Leader>d <Plug>(go-doc)
nmap <buffer> <Leader>f <Plug>(go-def-tab)
nmap <buffer> <Leader>r <Plug>(go-run)
nmap <buffer> <Leader>c <Plug>(go-coverage)
nmap <buffer> <Leader>t <Plug>(go-test)
nmap <buffer> <Leader>n <Plug>(go-rename)
endfunc "}}}

	au FileType go setlocal foldnestmax=2 foldmethod=syntax
	au FileType go call SetGOPATH()
	if !has('win32')
	au FileType go if exists('*go#path#Default')| call <SID>vimGoNMap()|endif
	else
	au FileType go if exists("g:go_loaded_install")| call <SID>vimGoNMap()||endif
	endif
augroup END "}}}

augroup LargeFile "{{{
	au!
	func! s:tooBigSmall() "{{{
		if !exists("s:LargeFile")
			let s:LargeFile = 1024 * 1024 * 50 "50m
			let s:TooLargeFile = s:LargeFile * 4 "200m
			let s:SmallFile = 1024 * 512 + 1 "512k
		endif
		let f = expand("%:p")
		let s = getfsize(f)
		if (s<s:SmallFile)
			setlocal noswapfile
			return
		endif
		if (s>s:LargeFile)
			setlocal eventignore+=FileType
		endif
		if (s>s:TooLargeFile)
			setlocal buftype=nowrite undolevels=-1 bufhidden=unload
		endif
	endfunc "}}}
	au BufReadPre * call <SID>tooBigSmall()
augroup END "}}}

augroup override_types "{{{
	au!

func! s:setFTCircos() "{{{
	let g:tcommentGuessFileType_circos = 'perl'
	let filename = expand("%:t")
	if filename ==? "circos.conf" || filename ==? "ideogram.conf" || filename ==? "ticks.conf"
		set ft=circos
	endif
endfunc "}}}

	au BufNewFile,BufReadPost *.conf call <SID>setFTCircos()
	au BufNewFile,BufReadPost *.circos setlocal ft=circos
	au BufNewFile,BufReadPost *.md setlocal ft=markdown
	au BufNewFile,BufReadPost *.lst setlocal ft=grub
	au BufNewFile,BufReadPost *.pac setlocal ft=javascript
	au BufNewFile,BufReadPost *.applescript setlocal ft=applescript
augroup END
"}}}

augroup reload_vimrc "{{{
	au!
	au BufWritePost $MYVIMRC source $MYVIMRC | 
				\call SetBackgroundMode() |
				\call s:bufnew_b_vars()
augroup END "}}}

augroup vim_help_keybind "{{{
   au!
   au FileType help,qf,godoc 
			   \nnoremap <buffer> <ESC> <C-w>q|
			   \nnoremap <buffer> q <C-w>q|
			   \nnoremap <buffer> <Space> <C-d>|
			   \nnoremap <buffer> c <C-u>
   au FileType help 
			   \nnoremap <buffer> <CR> <C-]>|
			   \nnoremap <buffer> <BS> <C-t>|
			   \nnoremap <buffer> o /'\l\{2,\}'<CR>|
			   \nnoremap <buffer> O ?'\l\{2,\}'<CR>|
			   \nnoremap <buffer> s /\|\zs\S\+\ze\|<CR>|
			   \nnoremap <buffer> S ?\|\zs\S\+\ze\|<CR>
   au FileType help,qf 
			   \nnoremap <buffer> <C-n> :cnext<CR>|
			   \nnoremap <buffer> <C-p> :cprevious<CR>|
			   \nnoremap <buffer> <C-a> :cwindow<CR>
   au FileType netrw nnoremap <buffer> q <C-w>q
   " if v:version > 703
	"    au FileType help,qf au! Modified TextChanged,TextChangedI <buffer>
   " else
	"    au FileType help,qf au! Modified CursorMoved,CursorMovedI <buffer>
   " endif
   au FileType help,qf au! matchparen
augroup END "}}}

augroup html_css_js "{{{
	au!
	if s:findplugin("emmet-vim")
		let g:user_emmet_install_global=0
		"let g:user_emmet_leader_key="<c-x>"
		let g:user_emmet_leader_key="\\"
		let g:emmet_html5 = 0
		let g:mta_filetypes = {
					\ 'html' : 1,
					\ 'xhtml' : 1,
					\ 'xml' : 1,
					\ 'markdown' : 1,
					\}
		let g:user_emmet_settings = {
					\ 'html': {
					\     'empty_element_suffix': ' />',
					\ }
					\}
		" let g:user_emmet_expandabbr_key = '<C-y>,'
		" let g:user_emmet_expandword_key = '<C-y>;'
		" let g:user_emmet_update_tag = '<C-y>u'
		" let g:user_emmet_balancetaginward_key = '<C-y>d'
		" let g:user_emmet_balancetagoutward_key = '<C-y>D'
		" let g:user_emmet_next_key = '<C-y>n'
		" let g:user_emmet_prev_key = '<C-y>N'
		" let g:user_emmet_imagesize_key = '<C-y>i'
		" let g:user_emmet_togglecomment_key = '<C-y>/'
		" let g:user_emmet_splitjointag_key = '<C-y>j'
		" let g:user_emmet_removetag_key = '<C-y>k'
		" let g:user_emmet_anchorizeurl_key = '<C-y>a'
		" let g:user_emmet_anchorizesummary_key = '<C-y>A'
		" let g:user_emmet_mergelines_key = '<C-y>m'
		" let g:user_emmet_codepretty_key = '<C-y>c'
		au FileType html,css,markdown EmmetInstall
		au FileType css imap <tab> <plug>(emmet-expand-abbr)
	endif
	au FileType html,javascript,css setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
augroup END "}}}

augroup misc_style "{{{
	au!
	au FileType vim setlocal foldmethod=marker
	" au FileType iunmap "
	" au FileType iunmap '
	au FileType c,cpp setlocal cindent
	au FileType perl setlocal tabstop=4 noexpandtab
	au FileType sh setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
	au FileType sh highlight colExceed guibg=#F2DAE8
	au FileType sh match colExceed /\%>78v.\+/
	au FileType haskell setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
	au FileType yaml setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
	au FileType yaml inoreabbrev <buffer> app app_options/:<CR>ascii_mode: true<ESC>k$i<C-r>=<SID>eatchar('\s')<CR>
" 	au FileType  php setlocal omnifunc=phpcomplete_extended#CompletePHP
augroup END "}}}

augroup misc "{{{

au!

func! s:curfiledir() "{{{
	let d = expand('%:p:h')
	if isdirectory(d)
		exe 'cd' fnameescape(d)
	endif
endfunc "}}}
au BufEnter * call <SID>curfiledir()
au BufReadPost * call SetBackgroundMode()

func! s:resCur() "{{{
	if line("'\"") <= line("$")
		call setpos(".", getpos("'\""))
		return 1
	endif
endfunc "}}}
func! s:unfoldCur() "{{{
	if has("folding")
		if !&foldenable
			return
		endif
		let cl = line(".")
		if cl <= 1
			return
		endif
		let cf = foldlevel(cl)
		let uf = foldlevel(cl - 1)
		let min = (cf > uf ? uf : cf)
		if min
			execute "normal!" min . "zo"
			return 1
		endif
	else
		return
	endif
endfunc"}}}
au BufWinEnter * if <SID>resCur() | call <SID>unfoldCur() | endif


augroup END
"}}}


finish
