GuiTabline 0

if has('win32')
GuiPopupmenu 0
GuiLinespace 1
endif

if has('macunix')
GuiScrollBar 1
endif

if has('mac')
	GuiFont Menlo:h14
elseif has('unix')
	GuiFont Dejavu\ Sans\ Mono:h14
endif

set foldcolumn=2
set mousehide "hide mouse when typing
set mouse=a
set list "show invisible chars
set listchars+=tab:┊┈
if has('macunix')
set tabline=%!TablineOSX()
else
set tabline=%!Tabline()
endif

hi TabLineFill guifg=#487897

"{{{ general remap keys
inoremap <S-CR> <esc>A<CR>
nnoremap <S-CR> O<esc>
if !has("macunix")
	vnoremap <C-c> "+y
	vnoremap <C-v> "+p
	inoremap <C-b> <esc>"+pa
endif
"}}}

augroup python_style_g "{{{

	au!
	au FileType python highlight BadWhitespace guibg=#F2DAE8
	au FileType python match BadWhitespace /\s\+$/

augroup END "}}}
