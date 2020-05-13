"GLOBAL SETTING {{{
set ff=unix
set nocompatible
set number
set laststatus=2
set undolevels=100 updatecount=500
set autoindent smartindent
set backspace=start,eol,indent
set shiftwidth=4 tabstop=4 softtabstop=4
set hlsearch incsearch
set noruler
set fileencodings=ucs-bom,utf8,shift-jis,gbk,euc-kr encoding=utf-8
set cursorline
set lazyredraw
set timeoutlen=330
"set redrawtime=2500
set foldmethod=marker foldnestmax=9 "fold text by specific pattern.
set noautowrite autoread modeline "auto detect file modified, # vim: ... : settings 
set wildmenu "enhanced command line completion
set wildignore=*.o,*~,*.pyc,*.pyo,._*,$~*,*.bak,*.swp,.DS_Store "enhanced cmd completion
set ignorecase "ignore case when searching
set smartcase "override ignorecase when search containing uppper cases
set wildmode=longest:full,full
set nohidden wrap  "wrap text
set noerrorbells
set nobackup nowritebackup noundofile
set cmdheight=1 "set to default
set scrolloff=1 "num of lines preserved when cursor moving out of current screen.
set ttyfast
set noshowcmd
set shortmess+=aOTI "compact messages
set background=light
set complete-=i
set showtabline=2 "0:never 1:when 2:always
set foldcolumn=0
set listchars=    "clean listchars for console
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
set splitbelow
set splitright
hi SpecialKey guifg=#B8B8F8

if has('win64')
	let g:python3_host_prog = expand('$LOCALAPPDATA/nvim/python3/python.exe')
	let $NVIM_PYTHON_LOG_FILE = expand('$LOCALAPPDATA/nvim/python.log')
elseif has('unix')
	let g:python3_host_prog = expand('$HOME/.config/nvim/pypy3/bin/pypy3')
	let $NVIM_PYTHON_LOG_FILE = expand('$HOME/.config/nvim/python.log')
endif
let g:loaded_python_provider = 0

syntax enable
filetype plugin on
filetype indent on

"}}}

"{{{ STATUS LINE

" highlight color for status line{{{
hi NSTL guibg=DarkSlateGray guifg=White " normal
hi ISTL guibg=OrangeRed4 guifg=White  " insert
hi VSTL guibg=#702863 guifg=White  " v select
hi VVSTL guibg=#702863 guifg=White " V select
hi CVSTL guibg=#8E1652 guifg=White " C-V select
hi RSTL guibg=#4578AB guifg=White  " replace
hi CSTL guibg=DarkBlue guifg=White " command
hi NSTLi guibg=DarkSlateGray guifg=White gui=italic " normal
hi ISTLi guibg=OrangeRed4 guifg=White gui=italic  " insert
hi VSTLi guibg=#702863 guifg=White gui=italic  " v select
hi VVSTLi guibg=#702863 guifg=White gui=italic " V select
hi CVSTLi guibg=#8E1652 guifg=White gui=italic " C-V select
hi RSTLi guibg=#4578AB guifg=White gui=italic  " replace
hi CSTLi guibg=DarkBlue guifg=White gui=italic " command
"}}}
" highlight color for modified indicator {{{
hi NMI guibg=DarkSlateGray guifg=LightBlue " normal
hi IMI guibg=OrangeRed4 guifg=LightBlue  " insert
hi VMI guibg=#702863 guifg=LightBlue  " v select
hi VVMI guibg=#702863 guifg=LightBlue " V select
hi CVMI guibg=#8E1652 guifg=LightBlue " C-V select
hi RMI guibg=#4578AB guifg=LightBlue  " replace
hi CMI guibg=DarkBlue guifg=LightBlue " command
"}}}

func! Supnr(num) "{{{
	if !exists('s:snuv')
		let s:snuv = [0x2070,0xb9,0xb2,0xb3,0x2074,
					\0x2075,0x2076,0x2077,0x2078,0x2079]
	endif
	return substitute(string(a:num),'\(\d\)',
				\'\=nr2char(s:snuv[str2nr(submatch(1))])','g')
endfunc "}}}

let s:STLColor = {'n':"%#NSTL#",'i':"%#ISTL#", 'v':"%#VSTL#",'V':"%#VVSTL#",
				\nr2char(22):"%#CVSTL#", 'R':"%#RSTL#", 'c':"%#CSTL#"}

let s:MIColor = {'n':"%#NMI#",'i':"%#IMI#", 'v':"%#VMI#",'V':"%#VVMI#",
				\nr2char(22):"%#CVMI#", 'R':"%#RMI#", 'c':"%#CMI#"}

function! s:bufnew_b_vars() "{{{
if !exists('b:buffer_num') | let b:buffer_num = ""  | endif
if !exists('b:buffer_enc') | let b:buffer_enc = "nil" | endif
if !exists('b:buffer_ft')  | let b:buffer_ft = 'nil' | endif
endfunc "}}}

function! StatusLine() "{{{
	return s:STLColor[mode()]."%F%r%{b:buffer_num}".s:MIColor[mode()]."%{(&mod==1)?'⁺':''}%*".s:STLColor[mode()]."%=%{(&co>70)?'┊'.strftime('%H:%M'):''}┊%{b:buffer_enc}┊%{toupper(&ff[0])}┊%2{b:buffer_ft}┊%5(%l,%c%)┊%L%*"
"%F : full path to file
"%m : modified indicator
"%r : read only indicator
"%y : syntax highlighyting type
"%l : current line
"%v : current column
"%n : buffer number
endfunc
"}}}

"call s:bufnew_b_vars()
setlocal statusline=%!StatusLine()

augroup statusline "{{{
	au!
	au BufEnter * call s:bufnew_b_vars()
	au BufWinEnter,BufWritePost * let b:buffer_num = Supnr(bufnr())
	au BufWinEnter,BufWritePost * setlocal statusline=%!StatusLine()
	au BufReadPost,EncodingChanged * let b:buffer_enc = (&fenc!='')?toupper(&fenc):'nil'
	au FileType help,qf setlocal statusline=%h\ %f%=┊%n┊%P┊%L foldcolumn=0 number
	au FileType * let b:buffer_ft = (&ft!='')?&ft:'nil'
augroup END "}}}

"}}}

" Plug {{{
silent! call plug#begin(expand('$LOCALAPPDATA/nvim/plug'))

Plug 'roxma/nvim-yarp'
Plug 'vim-scripts/c.vim'
Plug 'vim-scripts/tComment' "[v]gc [n]gcc
Plug 'vim-scripts/renamer.vim'
Plug 'vim-scripts/ctrlp.vim' " [n]<c-p> browse files
Plug 'Valloric/MatchTagAlways'
Plug 'ajh17/VimCompletesMe'
Plug 'lfilho/cosco.vim' " VIM colon and semicolon insertion bliss
Plug 'mattn/emmet-vim' "<c-y>,
Plug 'Lokaltog/vim-easymotion' " \\w \\f
Plug 'tpope/vim-characterize' " [n]ga
Plug 'tpope/vim-surround' " [n]cs ds ys 
Plug 'arzg/vim-colors-xcode'

call plug#end()
"}}}

" Plug Configs {{{

"}}}

"{{{ GENERAL REMAP KEY
" inoremap jk <esc>
" inoremap jl <esc>la
" inoremap jh <esc>ha
nnoremap gs :echo synIDattr(synID(line("."), col("."), 1), "name")<CR>
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <tab> :tabnext<CR>
nnoremap <S-tab> :tabprev<CR>
nnoremap <C-q> <C-w>q
nnoremap <M-j> mz:m+<CR>`z
nnoremap <M-k> mz:m-2<CR>`z
vnoremap <silent> <leader>u :<C-u>call <SID>str2uninr_visual_replace()<CR>

"}}}

"{{{ FUNCTIONS

func! s:checkPrevComma() "{{{
	" this function assumes itself 
	" to be called imediately after insert a comma
	" thus it must called in ',<C-r>=<SID>checkPrevComma()' fashion
	let l:col = col('.')
	if synIDattr(synID(line('.'), col('.')-1,0),'name') =~ '\%(String\|Comment\|Quotes\)$'
		return ''
	endif
	return ' '
endfunc
"}}}

if !exists('*s:reload_initvim') "{{{
	func! s:reload_initvim()
		let loc = s:dirname($MYVIMRC)
		let ginit = loc.'/ginit.vim'
		exec 'source' $MYVIMRC
		if exists('g:GuiLoaded')
			exec 'source' ginit
		endif
	endfunc
endif
"}}}

func! s:dirname(path) "{{{
	return fnamemodify(a:path, ':h')
endfunc "}}}

func! s:basename(path) "{{{
	return fnamemodify(a:path, ':l')
endfunc "}}}

func! s:vimrc() "{{{
	tabnew $MYVIMRC
endfunc "}}}

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

func! Tabline() "{{{
  let s = []
  let tpnr = tabpagenr('$')
  let tpnrc = tabpagenr()
  if tpnr > 1
	  let closeb = ' %999X✗ '
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
endfunc "}}}

function! s:cr_function() "{{{
	return neocomplcache#smart_close_popup() . "\<CR>"
	" For no inserting <CR> key.
	"   "return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
endfunction "}}}

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
endfunc "}}}

func! s:str2uninr_visual_replace() "{{{
	let l:temp = @x
	normal gv"xy
	let @x = <SID>str2uninr(@x)
	normal gv"xp
	let @x = l:temp
endfunc "}}}

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
endfunc
"}}}

func! s:rstrip() "{{{
	if col('.') > 1 && col('.') == col('$')
		let p = getpos('.')
		exec 's/\s*$//'
		let e = col('$')
		let p[2] = e
		call setpos('.',p)
	endif
	return ''
endfunc
"}}}

"}}}

"{{{ GROUPS

augroup reload_vimrc "{{{
	au!
	au BufWritePost $LOCALAPPDATA/nvim/init.vim call s:reload_initvim()
	au BufWritePost $LOCALAPPDATA/nvim/ginit.vim call s:reload_initvim()
augroup END "}}}

augroup Commands "{{{
	command! -range -nargs=0 Trimdot :<line1>,<line2>s/\.\+\([^\.]\+\)\(\.\)\@=/ \1/ge|:nohl
	command! -nargs=? NF echo len(split(getline('.'),<q-args>!=""?<q-args>:'\s\+'))
	command! -nargs=? NC echo len(split(getline('.')[0:col('.')-1],<q-args>!=""?<q-args>:'\s\+'))
	command! Bcd cd %:p:h
	command! Tdir tabedit <C-R>=expand("%:p:h")
	nnoremap <leader>f :NF<cr>
	nnoremap <leader>c :NC<cr>
	command! -nargs=1 Enc e ++enc=<args>
	command! Vimrc call <SID>vimrc()
augroup END "}}}

augroup python_style "{{{

	au!
	au FileType python syn keyword pythonBuiltin self
	au FileType python setlocal tabstop=4 noexpandtab
	au FileType python inoremap <buffer> , ,<C-r>=<SID>checkPrevComma()<CR>

augroup END "}}}

augroup LargeFile "{{{
	au!
	au BufReadPre * call <SID>tooBigSmall()
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
   au FileType help,qf au! matchparen
augroup END "}}}

augroup misc_style "{{{
	au!
	au FileType vim setlocal foldmethod=marker
	au FileType c,cpp setlocal cindent
	au FileType perl setlocal tabstop=4 noexpandtab
	au FileType sh setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
	au FileType sh highlight colExceed guibg=#F2DAE8
	au FileType sh match colExceed /\%>78v.\+/
	au FileType haskell setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
	au FileType yaml setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
	au FileType yaml inoreabbrev <buffer> app app_options/:<CR>ascii_mode: true<ESC>k$i<C-r>=<SID>eatchar('\s')<CR>
" 	au FileType php setlocal omnifunc=phpcomplete_extended#CompletePHP
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

" augroup commentToggle "{{{
" 	au!
" 	au FileType python,perl,sh nnoremap <buffer> <Leader>c I#<ESC>
" 	au FileType python,perl,sh nnoremap <buffer> <Leader>u :.s/^\v(\s*)#/\1/<CR>:nohlsearch<CR>
" 	au FileType python,perl,sh vnoremap <buffer> <Leader>c :s/^\v(\s*)/\1#/<CR>:nohlsearch<CR>
" 	au FileType python,perl,sh vnoremap <buffer> <Leader>u :s/^\v(\s*)#/\1/<CR>:nohlsearch<CR>
" 	au FileType vim nnoremap <buffer> \c I"<ESC>
" 	au FileType vim nnoremap <buffer> \u :.s/^\v(\s*)"/\1/<CR>:nohlsearch<CR>
" 	au FileType vim vnoremap <buffer> \c :s/^\v(\s*)/\1"/<CR>:nohlsearch<CR>
" 	au FileType vim vnoremap <buffer> \u :s/^\v(\s*)"/\1/<CR>:nohlsearch<CR>
" 	au FileType c,cpp,go nnoremap <buffer> <Leader>c I//<ESC>
" 	au FileType c,cpp,go nnoremap <buffer> <Leader>u :.s/^\v(\s*)\/\//\1/<CR>:nohlsearch<CR>
" 	au FileType c,cpp,go vnoremap <buffer> <Leader>c :s/^\v(\s*)/\1\/\//<CR>:nohlsearch<CR>
" 	au FileType c,cpp,go vnoremap <buffer> <Leader>u :s/^\v(\s*)\/\//\1/<CR>:nohlsearch<CR>
" 	au FileType dosbatch nnoremap <buffer> <Leader>c I::<ESC>
" 	au FileType dosbatch nnoremap <buffer> <Leader>u :.s/^\v(\s*)::/\1/<CR>:nohlsearch<CR>
" 	au FileType dosbatch vnoremap <buffer> <Leader>c :s/^\v(\s*)/\1::/<CR>:nohlsearch<CR>
" 	au FileType dosbatch vnoremap <buffer> <Leader>u :s/^\v(\s*)::/\1/<CR>:nohlsearch<CR>
" augroup END
"}}}

"}}}

finish
