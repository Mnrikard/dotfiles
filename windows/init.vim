set nocompatible
scriptencoding utf-8
set encoding=utf-8

"Sets{{{
	set whichwrap+=<,>,[,]
	set nowrapscan
	set hidden
	set confirm
	set wildmode=longest,list,full
	set wildmenu
	set wildignore+=~*,*.png,*.jpg,*.exe,*.dll,*.swp
	set showcmd
	set hlsearch
	set ignorecase
	set smartcase
	set backspace=indent,eol,start
	set autoindent
	set nostartofline
	set ruler
	set laststatus=1
	set confirm
	"set mouse=a
	set cmdheight=2
	set number
	set notimeout ttimeout ttimeoutlen=200
	set pastetoggle=<F11>
	set shiftwidth=4
	set tabstop=4
	set softtabstop=4
	set foldlevelstart=99
	set foldmethod=indent
	set nowrap
	set list
	set listchars=tab:¦\ ,trail:«
	let mapleader=" "
	set encoding=utf8
	set laststatus=2
	set complete=.,w,b,u,t,i,kspell
	set splitright
	set splitbelow
	set visualbell
	set noexpandtab
	set background=dark
	set fileignorecase
    set sidescroll=1

	highlight default spacesbad term=undercurl ctermbg=13 gui=undercurl guisp=#2aa198
	highlight default CodeSmells ctermbg=red guibg=red
	match CodeSmells /\v\s$/
	2match spacesbad /  /
	
"}}}

"Maps{{{

	map <MiddleMouse> <Nop>
	imap <MiddleMouse> <Nop>
	map <2-MiddleMouse> <Nop>
	imap <2-MiddleMouse> <Nop>

	"copy to system clipboard
	vnoremap <C-c> "+y
	" leader+h searches for word under cursor
	vnoremap <leader>h y:<C-U>let @/="<C-R>=@"<CR>"<CR>:set hls<CR>
    "vnoremap <leader>h y/\V<C-R>=escape(@",'/\')<CR><CR>
	""un-J this, or put a new line here
	"nnoremap <C-S-j> a<CR><Esc>kA<Esc>
	"clear highlighting
	nnoremap <C-L> :nohl<CR><C-L>
	" new line
	nnoremap <leader>nl o<Esc>
	"Tab around buffers
	nnoremap <C-tab> :bn<cr>
	nnoremap <C-S-tab> :bprev<cr>
	"Ctrl+S saves
	nnoremap <C-s> :w<cr>
	""new line
	"nnoremap <Leader>o i<cr><Esc>
	" paste the last line copied (not last deleted)
	nnoremap <Leader>p "0p
	" edit and save vimrc
	nnoremap <leader>ev :vsplit $MYVIMRC<cr>
	nnoremap <leader>sv :source $MYVIMRC<cr>
	"" prettify
	"nnoremap <leader>kd :execute "normal! mhgg=G<C-v><cr>`h"<cr>
	"switch windows
	nnoremap <leader>wh :wincmd W<cr>
	" search for word under cursor
	nnoremap <leader>h :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>
	" rename
	nnoremap <leader>rr :set operatorfunc=Refactor<cr>g@
	" lower case this word
	nnoremap <leader>ll guiw
	" upper case this word
	nnoremap <leader>uu gUiw
	" open nerdtree
	nnoremap <leader>nt :NERDTreeToggle<cr>
	" undo
	nnoremap <C-z> u
	" grep for word under cursor
	nnoremap <leader>K :vimgrep /<cword>/g **/*<cr>:copen<cr>
	" Ctrl+v works in normal mode too
	nnoremap <C-v> "+p
	"f6 moves windows
	nnoremap <f6> :tabnext<cr>
	"shift-f6 moves windows
	nnoremap <S-f6> :tabprev<cr>
	"paste over word
	nnoremap <leader>rp ciw<C-r>0<esc>
	"paste from system over everything
	nnoremap <C-S-v> :PasteOver<cr>
    "tab next
    nnoremap <C-tab> :tabnext<cr>
    nnoremap <C-S-tab> :tabprevious<cr>


	"escape home rows
	"inoremap jjk <Esc>
	" new line below
	"inoremap <C-J> <Esc>jo
	" new line above
	"inoremap <C-K> <Esc>ko
	" save in insert mode
	inoremap <C-s> <Esc>:w<cr>a
	" write
	" make Ctrl+V work as expected
	inoremap <C-v> <C-r>+<right>
	inoremap <C-S-v> <esc>"+pa
	inoremap }k }<esc>O
	inoremap uuuu <esc>viwgUea
    inoremap kkk <esc>k
	"inoremap [] []<Esc>i
	"Shift+arrows to select
	inoremap <C-S-Left> <esc>vb
	inoremap <C-S-Right> <esc>ve
	inoremap <S-Left> <esc>vh
	inoremap <S-Right> <esc>vl

	vnoremap <C-S-Left> b
	vnoremap <C-S-Right> e
	vnoremap <S-Left> h
	vnoremap <S-Right> l

	" paste over selection
	vnoremap <C-v> d"+p

	" smart add the braces
	"iabbrev {{ {<cr>}<Esc>O
"}}}

"AutoCmd{{{
	augroup myAutoCmds
		autocmd!
		autocmd BufNewFile, BufRead *.config set filetype=xml
		autocmd FileType xml,xsl,xslt,xsd setlocal foldmethod=syntax
		autocmd BufEnter * syntax sync minlines=1000

		autocmd ColorScheme * highlight default spacesbad term=undercurl ctermbg=13 gui=undercurl guisp=#2aa198
		autocmd ColorScheme * highlight default CodeSmells ctermbg=red guibg=red

		autocmd FileType vim setlocal  foldmethod=marker
		autocmd FileType vim setlocal foldlevel=0

		"autocmd FileType markdown setlocal wrap
		autocmd FileType markdown setlocal colorcolumn=120,121,122,123,124,125,126,127,128,129,130
		autocmd FileType markdown setlocal spell
		autocmd FileType markdown setlocal foldcolumn=5
		autocmd TextChanged,InsertLeave *.md silent write

        autocmd FileType yaml setlocal shiftwidth=2
        autocmd FileType yaml setlocal tabstop=2

		autocmd FileType cs inoremap <buffer> ){ )<cr>{<cr>}<Esc>kA
		autocmd FileType cs setlocal errorformat=%f(%l\\\,%c):\ %m\[

		autocmd FileType html setlocal foldmethod=indent

        autocmd FileType make setlocal noexpandtab


	augroup end
	augroup FileTypeCmds
		autocmd!
		autocmd FileType sql nnoremap <f5> :call ExecuteSql()<cr>
		autocmd FileType sql vnoremap <f5> :call ExecuteVisualSql()<cr>
        autocmd FileType go nnoremap <buffer> <S-F12> :GoReferrers<cr>
        autocmd FileType go nnoremap <buffer> <C-F12> :GoImpl<cr>
	augroup end
"}}}

syntax on
syntax sync minlines=1000

"Commands {{{
	function! s:WhiteSpaceIgnore()
		execute ':set diffopt+=iwhite'
		execute ':diffu'
	endfunction
	command! -nargs=0 WhiteSpaceIgnore execute "call s:WhiteSpaceIgnore()"

	function! s:SearchOnlyDiff()
		execute ":set diffopt+=filler,context:0"
		execute ":set fdo-=search"
	endfunction
	command! -nargs=0 SearchOnlyDiff execute "call s:SearchOnlyDiff()"

	function! Refactor(type)
		let toname=input('New Name:')

		let savedReg = @@
		if a:type  ==# 'v'
			normal! y
		elseif a:type ==# 'char' || a:type ==# 'line'
			normal! viwy
		else
			return
		endif

		execute 'normal! m0'
		execute ':%s/\v<'.@@.'>/'.toname."/g" . expand("<cr>")
		execute "normal! `0"
		let @@ = savedReg
	endfunction

	function! CleanUp()
		silent execute "normal! mhgg=G"		
		silent execute ":%s/\\s\\+$//e"
		silent execute "normal! <C-v><cr>`h"
	endfunction
	nnoremap <leader>kd :call CleanUp()<cr>

	function! DragVertical(type, dir)
		" move a selection around
		if a:type ==# 'V'
			let [tline, col1] = getpos("'<")[1:2]
			let [bline, col2] = getpos("'>")[1:2]
			let linecount = bline-tline

			let fdir = bline+1
			if(a:dir ==# -1)
				let fdir = tline - 2
			endif

			let tline = tline + a:dir
			execute "'<,'>m" fdir
			execute "normal! ".tline."G"
			if linecount ==# 0
				execute "normal! V"
			else
				execute "normal! V".linecount."j"
			endif
		else
			return
		endif
	endfunction
	vnoremap <up> :<C-U>call DragVertical(visualmode(), -1)<cr>
	vnoremap <down> :<C-U>call DragVertical(visualmode(), 1)<cr>

	function! SmoothScroll(dir,ln)
		let h = (winheight(0)-5)/a:ln
		for i in range(0,h)
			if(a:dir ==# "up")
				execute ":normal! \<C-Y>"
			else
				execute ":normal! \<C-E>"
			endif
			redraw
			sleep 25m
		endfor
	endfunction
	"nnoremap <C-u> :call SmoothScroll("up",1)<cr>
	"nnoremap <C-d> :call SmoothScroll("down",1)<cr>
	nnoremap <C-M-u> :call SmoothScroll("up",2)<cr>
	nnoremap <C-M-d> :call SmoothScroll("down",2)<cr>

	function! DropCurrentBuffer()
		" drops the current buffer without closing window"
		let cbuf=bufnr('%')
		execute 'bp'
		execute "bd ".cbuf
	endfunction
	command! -nargs=0 BD execute "call DropCurrentBuffer()"

	command! Nom execute "%s///g"
	command! BM execute "bufdo | bd!"
	command! SAC execute 'normal! ggVG"+y'
	command! WBD execute "w | bd"

	function! MoveLine(lnum)
		let currline=line('.')
		echo currline "moving to" a:lnum
		execute "m" a:lnum
		execute currline
	endfunction

	function! MoveLineUp()
		let currline=line('.')
		execute "m" currline-2
	endfunction

	function! MoveLineDown()
		let currline=line('.')
		execute "m" currline+1
	endfunction

	function! ShowChars()
		execute ":setlocal list"
		execute ":redraw"
		execute ":sleep 2000m"
		execute ":setlocal nolist"
	endfunction
	nnoremap <Leader>vv :ShowChars<cr>

	command! Pst execute 'normal! "+p'

	command! PasteOver execute 'normal! ggdG"+p'

	command! -nargs=1 M execute "call MoveLine(<args>)"
	command! -nargs=0 Md execute "call MoveLineDown()"
	command! -nargs=0 Mu execute "call MoveLineUp()"
	command! -nargs=0 ShowChars execute "call ShowChars()"

	function! ExecuteVisualSql()
		execute ":DBExecVisualSQL"
		#execute ":wincmd W"
		#execute ":%!pasty trimosql"
	endfunction
	function! ExecuteSql()
		execute ":DBExecSQLUnderCursor"
		#execute ":wincmd W"
		#execute ":%!pasty trimosql"
	endfunction

	function! OpenHere()
		execute ":!start explorer.exe %:p"
	endfunction

	function! OpenThis()
		execute ":!start explorer.exe %:p:h"
	endfunction

	function! DiffToggle()
		let diffon=&diff
		if diffon ==# 0
			execute ":windo diffthis"
		else
			execute ":windo diffoff"
			execute ":q"
		endif
	endfunction
	nnoremap <leader>dd :call DiffToggle()<cr>

	command! Don execute ":windo diffthis"
	command! Doff execute "call DiffToggle()"

	function! s:DiffWithSaved()
		let filetype=&ft
		diffthis
		vnew | r # | normal! 1Gdd
		diffthis
		execute "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
	endfunction
	command! DiffSaved call s:DiffWithSaved()

	function! NewFromClipboard()
		execute ":enew"
		execute 'normal! "+p'
		" if the first non-whitespace character is an open angle bracket, then
		" set this as XML
		if search("\\%^\\_\\s*<","c") > 0	
			execute ":setf xml"
		endif
	endfunction
	nnoremap <C-S-n> :call NewFromClipboard()<cr>
	"inoremap <C-S-n> <Esc>:call NewFromClipboard()<cr>

    let w:zoomed=0
    function! ZoomInOut()
        if w:zoomed
            execute ":wincmd ="
            let w:zoomed=0
        else
            execute ":wincmd |"
            execute ":wincmd _"
            let w:zoomed=1
        endif
    endfunction
    nnoremap <C-w>z :call ZoomInOut()<cr>


	function! RefreshOmni()
		execute ":OmniSharpStopServer"
		execute ":OmniSharpStartServer"
	endfunction
	command! OmniSharpRefreshServer call RefreshOmni()
"}}

"}
