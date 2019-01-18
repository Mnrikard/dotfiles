set nocompatible
scriptencoding utf-8
set encoding=utf-8
"VundleSection{{{
	filetype off
	" set the runtime path to include Vundle and initialize
	if has("win32")
		set rtp+=c:\users\mrikard\vimfiles\bundle\Vundle.vim
	else
		set rtp+=~/.vim/bundle/Vundle.vim
	endif
	call vundle#begin()

	" let Vundle manage Vundle, required
	Plugin 'VundleVim/Vundle.vim'

	"plugin on GitHub repo
	Plugin 'ErichDonGubler/vim-sublime-monokai'
	Plugin 'MarcWeber/vim-addon-mw-utils'
	Plugin 'OmniSharp/Omnisharp-vim'
	Plugin 'OrangeT/vim-csharp'
	Plugin 'PProvost/vim-ps1'
	Plugin 'altercation/vim-colors-solarized'
	"Plugin 'codelibra/log4jhighlighter'
	Plugin 'ctrlpvim/ctrlp.vim'
	Plugin 'ervandew/supertab'
	Plugin 'gabrielelana/vim-markdown'
	Plugin 'garbas/vim-snipmate'
	Plugin 'leafgarland/typescript-vim'
	Plugin 'scrooloose/nerdtree'
	Plugin 'scrooloose/syntastic'
	Plugin 'sukima/xmledit'
	Plugin 'terryma/vim-multiple-cursors'
	Plugin 'tomtom/tlib_vim'
	Plugin 'tpope/vim-dispatch'
	Plugin 'tpope/vim-fugitive'
	Plugin 'tpope/vim-repeat'
	Plugin 'tpope/vim-surround'
	Plugin 'tpope/vim-vividchalk'
	Plugin 'vim-airline/vim-airline'
	Plugin 'vim-airline/vim-airline-themes'
	Plugin 'vim-scripts/ctags.vim'
	Plugin 'vim-scripts/dbext.vim'

	"Plugin 'easymotion/vim-easymotion'
	" tabular: used to line things up
	"Plugin 'godlygeek/tabular'
	" fzf: fuzzy finder
	"Plugin 'junegunn/fzf'
	"Plugin 'kien/ctrlp.vim'
	" match xml tags
	"Plugin 'valloric/matchtagalways'
	" Optional:

	call vundle#end()            " required
	filetype plugin indent on    " required
"}}}

"PluginSettings{{{
	"OmniSharp {{{
	if(has("python") || has("python3"))
		let g:OmniSharp_server_type = 'roslyn'
		let g:OmniSharp_prefer_global_sln = 1
		let g:OmniSharp_host = "http://localhost:2000"

		if has("win32")
			let g:OmniSharp_server_path = 'C:\OmniSharp\omnisharp.http-win-x64\OmniSharp.exe'
		else
			let g:OmniSharp_server_path = '/mnt/c/OmniSharp/omnisharp.http-win-x64/OmniSharp.exe'
			let g:OmniSharp_translate_cygwin_wsl = 1
		endif

		"Set the type lookup function to use the preview window instead of the status line
		let g:OmniSharp_typeLookupInPreview = 0
		"Timeout in seconds to wait for a response from the server
		let g:OmniSharp_timeout = 2
		set noshowmatch

		let g:SuperTabDefaultCompletionType = 'context'
		let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"
		let g:SuperTabDefaultCompletionTypeDiscovery = ["&omnifunc:<c-x><c-o>","&completefunc:<c-x><c-n>"]
		let g:SuperTabClosePreviewOnPopupClose = 1
		set completeopt=longest,menuone,preview
		set splitbelow

		augroup omnisharp_commands
			autocmd!

			"Set autocomplete function to OmniSharp (if not using YouCompleteMe completion plugin)
			autocmd FileType cs,razor setlocal omnifunc=OmniSharp#Complete

			" Synchronous build (blocks Vim)
			"autocmd FileType cs nnoremap <F5> :wa!<cr>:OmniSharpBuild<cr>
			" Builds can also run asynchronously with vim-dispatch installed
			autocmd FileType cs nnoremap <leader>b :wa!<cr>:OmniSharpBuildAsync<cr>
			" automatic syntax check on events (TextChanged requires Vim 7.4)
			autocmd BufEnter,TextChanged,InsertLeave *.cs SyntasticCheck

			" Automatically add new cs files to the nearest project on save
			"autocmd BufWritePost *.cs call OmniSharp#AddToProject()

			"show type information automatically when the cursor stops moving
			autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()

			"The following commands are contextual, based on the current cursor position.

			autocmd FileType cs nnoremap gd :OmniSharpGotoDefinition<cr>
			autocmd FileType cs nnoremap <leader>fi :OmniSharpFindImplementations<cr>
			autocmd FileType cs nnoremap <leader>ft :OmniSharpFindType<cr>
			autocmd FileType cs nnoremap <leader>fs :OmniSharpFindSymbol<cr>
			autocmd FileType cs nnoremap <leader>fu :OmniSharpFindUsages<cr>
			"finds members in the current buffer
			autocmd FileType cs nnoremap <leader>fm :OmniSharpFindMembers<cr>
			" cursor can be anywhere on the line containing an issue
			autocmd FileType cs nnoremap <leader>x  :OmniSharpFixIssue<cr>
			autocmd FileType cs nnoremap <leader>fx :OmniSharpFixUsings<cr>
			autocmd FileType cs nnoremap <leader>tt :OmniSharpTypeLookup<cr>
			autocmd FileType cs nnoremap <leader>dc :OmniSharpDocumentation<cr>
			autocmd FileType cs nnoremap <leader>rr :OmniSharpRename<cr>
			"navigate up by method/property/field
			autocmd FileType cs nnoremap <C-K> :OmniSharpNavigateUp<cr>
			"navigate down by method/property/field
			autocmd FileType cs nnoremap <C-J> :OmniSharpNavigateDown<cr>
		augroup end 
		set updatetime=500

		" Add syntax highlighting for types and interfaces
		nnoremap <leader>th :OmniSharpHighlightTypes<cr>
	endif 
	"}}}
	"Airline {{{
	"let g:airline#extensions#tabline#enabled = 1
	let g:airline_left_sep=nr2char(0xe0b0)
	let g:airline_right_sep=nr2char(0xe0b2)
	let g:airline_theme='vice'
	"}}}
	"MatchTagAlways{{{
	let g:mta_filetypes = { 'html' : 1, 'xhtml' : 1, 'xml' : 1, 'jinja' : 1, 'xslt':1,'cshtml':1 }
	"}}}
	let g:xml_syntax_folding=1
	au FileType xml,xsl,xslt,html,razor setlocal foldmethod=syntax
	"set statusline+=%{fugitive#statusline()}
	"syntastic {{{
	"	set statusline+=%#warningmsg#
	"	set statusline+=%{SyntasticStatuslineFlag()}
	"	set statusline+=%*

		let g:syntastic_always_populate_loc_list = 1
		let g:syntastic_auto_loc_list = 2
		let g:syntastic_check_on_open = 1
		let g:syntastic_check_on_wq = 0
"		let g:syntastic_cs_checkers = ["code_checker","issues","semantic","syntax"]
		let g:syntastic_cs_checkers = ['code_checker',"syntax"]
		let g:syntastic_js_checkers = ['code_checker']
	"}}}
	"dbext{{{
	let g:dbext_default_profile_ProdDb3Sup = 'type=SQLSRV:integratedlogin=1:srvname=ProdDb3Sup\ProdDb3Sup:dbname=ClientInterfaces:port=1757'
	let g:dbext_default_profile_DBCluster2 = 'type=SQLSRV:integratedlogin=1:srvname=DBCluster2:dbname=EquestPlus'
	let g:dbext_default_profile_Dev2Db3Sup = 'type=SQLSRV:integratedlogin=1:srvname=Dev2Db3Sup:dbname=ClientInterfaces'
	let g:dbext_default_profile_Dev2Db3 = 'type=SQLSRV:integratedlogin=1:srvname=Dev2Db3:dbname=EquestPlus'
	let g:dbext_default_profile_Model2Db3Sup = 'type=SQLSRV:integratedlogin=1:srvname=model2Db3Sup:dbname=ClientInterfaces'
	let g:dbext_default_profile_Model2Db3 = 'type=SQLSRV:integratedlogin=1:srvname=model2Db3:dbname=EquestPlus'
	"let g:dbext_default_profile_Dev2ClientInt = 'type=SQLSRV:integratedlogin=1:srvname=Dev2Db3Sup:dbname=ClientInterfaces'
	
	vnoremap <f5> :call ExecuteVisualSql()<cr>
	nnoremap <f5> :call ExecuteSql()<cr>
	"}}}

	"supertab {{{
		let g:SuperTabNoCompleteAfter = ['\s','^',',']
	"}}}
	
	"solarized{{{
	let g:solarized_italic=0
	"}}}
	
"}}}

"Sets{{{

set renderoptions=type:directx

	if has("win32")
		"set shell=shl.exe
		"set shellcmdflag=/c\ ps
		"set shellpipe=|
		"set shellredir=\|Out-File\ %s\ -Encoding\ ASCII\ -Width\ 1000
		""set shellredir=>
		"set shellquote=\ 
		"set shellxquote=(

		"set shell=PowerShell.exe
		"set shellcmdflag=\ -NoLogo\ -NoProfile\ -NonInteractive\ -ExecutionPolicy\ RemoteSigned\ -c\ &
		"set shellpipe=|
		"set shellredir=\|Out-File\ %s\ -Encoding\ ASCII\ -Width\ 1000
		"set shellquote=\ 
		"set shellxquote=
		"set noshelltemp
	else
		set shell=/bin/zsh
	endif
	"set guifont=DejaVu_Sans_Mono_for_Powerline:h10:cANSI:qDRAFT
	
	set whichwrap+=<,>,[,]
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
	set nolist
	set listchars=tab:»\ ,trail:·
	let mapleader=" "
	set encoding=utf8
	set laststatus=2
	set complete=.,w,b,u,t,i,kspell
	set splitright
	set splitbelow
	set visualbell
	set noexpandtab
	set background=dark

	if has('gui_running')
		set guifont=Fira_Code:h10:cANSI:qDRAFT
		set guioptions -=m
		set guioptions-=T  " no toolbar
		colorscheme sublimemonokai
	else
		colorscheme vividchalk
	endif

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
	" run tests
	nnoremap <leader>rt :OmniSharpRunTests<cr>
	" open nerdtree
	nnoremap <leader>nt :NERDTreeToggle<cr>
	" undo
	nnoremap <C-z> u
	" grep for word under cursor
	nnoremap <leader>K :vimgrep /<cword>/g **/*<cr>:copen<cr>
	" Ctrl+v works in normal mode too
	nnoremap <C-v> "+p
	"f6 moves windows
	nnoremap <f6> :wincmd W<cr>
	"paste over word
	nnoremap <leader>rp ciw<C-r>0<esc>
	"paste from system over everything
	nnoremap <C-S-v> :PasteOver<cr>


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
	iabbrev {{ {<cr>}<Esc>O
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

		autocmd FileType cs inoremap <buffer> ){ )<cr>{<cr>}<Esc>kA
		autocmd FileType cs setlocal errorformat=%f(%l\\\,%c):\ %m\[

		autocmd FileType html setlocal foldmethod=indent

	augroup end
	augroup FileTypeCmds
		autocmd!
		autocmd FileType sql nnoremap <f5> :call ExecuteSql()<cr>
		autocmd FileType sql vnoremap <f5> :call ExecuteVisualSql()<cr>
	augroup end
"}}}

syntax on
syntax sync minlines=1000

"Commands {{{
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
	nnoremap <C-u> :call SmoothScroll("up",1)<cr>
	nnoremap <C-d> :call SmoothScroll("down",1)<cr>
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
		execute ":wincmd W"
		execute ":%!pasty trimosql"
	endfunction
	function! ExecuteSql()
		execute ":DBExecSQLUnderCursor"
		execute ":wincmd W"
		execute ":%!pasty trimosql"
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
	

	function! RefreshOmni()
		execute ":OmniSharpStopServer"
		execute ":OmniSharpStartServer"
	endfunction
	command! OmniSharpRefreshServer call RefreshOmni()
"}}

"variables {{
let g:equestplusws = "c:\GitRepos\eqPlusClientServices\EquestPlusWS\EquestPlusWSInternal\EquestPlusWS.asmx.vb"
"}}}
"}
