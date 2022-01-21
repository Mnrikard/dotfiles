set nocompatible
scriptencoding utf-8
set encoding=utf-8
"VundleSection{{{
	filetype off
	" set the runtime path to include Vundle and initialize
	if has("win32")
		set rtp+=c:\users\matthewr\vimfiles\bundle\Vundle.vim
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
	Plugin 'altercation/vim-colors-solarized'
	Plugin 'chrisbra/csv.vim'
	Plugin 'editorconfig/editorconfig-vim'
	Plugin 'rikard-acst/vim-go'
	Plugin 'rikard-acst/vim-vividchalk'
	Plugin 'gabrielelana/vim-markdown'
	Plugin 'iamcco/markdown-preview.nvim'
	Plugin 'junegunn/fzf'
	Plugin 'junegunn/fzf.vim'
	Plugin 'merlinrebrovic/focus.vim'
	Plugin 'preservim/tagbar'
	Plugin 'scrooloose/nerdtree'
	Plugin 'scrooloose/syntastic'
	Plugin 'sheerun/vim-polyglot'
	Plugin 'sukima/xmledit'
	Plugin 'tomtom/tlib_vim'
	Plugin 'tpope/vim-dispatch'
	Plugin 'tpope/vim-fugitive'
	Plugin 'tpope/vim-obsession'
	Plugin 'tpope/vim-repeat'
	Plugin 'tpope/vim-surround'
	Plugin 'tpope/vim-unimpaired'
	Plugin 'tyru/open-browser.vim'
	Plugin 'tyru/open-browser-github.vim'
	Plugin 'vim-airline/vim-airline'
	Plugin 'vim-airline/vim-airline-themes'
	Plugin 'vim-scripts/ctags.vim'
	Plugin 'vim-scripts/dbext.vim'
	Plugin 'ycm-core/YouCompleteMe'
	Plugin 'yegappan/mru'

	call vundle#end()            " required
	filetype plugin indent on    " required
"}}}

"PluginSettings{{{
	"OmniSharp {{{
	let g:OmniSharp_server_stdio = 1

"	if(has("python") || has("python3"))
"		let g:OmniSharp_server_type = 'roslyn'
"		let g:OmniSharp_prefer_global_sln = 1
"		let g:OmniSharp_host = "http://localhost:2000"

		if has("win32")
			let g:OmniSharp_server_path = 'C:\OmniSharp\OmniSharp.exe'
		else
			"let g:OmniSharp_server_path = '/mnt/c/OmniSharp/OmniSharp.exe'
			"let g:OmniSharp_translate_cygwin_wsl = 1
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
			"autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()
			autocmd CursorHold *.cs call OmniSharp#actions#documentation#TypeLookup()

			"The following commands are contextual, based on the current cursor position.

			autocmd FileType cs nnoremap gd :OmniSharpGotoDefinition<cr>
			autocmd FileType cs nnoremap <leader>fi :OmniSharpFindImplementations<cr>
			autocmd FileType cs nnoremap <leader>ft :OmniSharpFindType<cr>
			autocmd FileType cs nnoremap <leader>fs :OmniSharpFindSymbol<cr>
			autocmd FileType cs nnoremap <leader>fu :OmniSharpFindUsages<cr>
			"finds members in the current buffer
			autocmd FileType cs nnoremap <leader>fm :OmniSharpFindMembers<cr>
			" cursor can be anywhere on the line containing an issue
			autocmd FileType cs nnoremap <leader>x  :OmniSharpGetCodeActions<cr>
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
"	endif
	"}}}
	"Airline {{{
	"let g:airline#extensions#tabline#enabled = 1
	let g:airline_left_sep=nr2char(0xe0b0)
	let g:airline_right_sep=nr2char(0xe0b2)
	let g:airline_theme='dark'
	let g:airline#extensions#tagbar#enabled = 1
	"let g:airline_section_x = '%{&filetype}'
	"let g:airline_section_y = '%#__accent_bold#%{LineNoIndicator()}%#__restore__#'
	"let g:airline_section_z = '%2c'
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
	let g:dbext_default_profile_develop = 'type=SQLSRV:user=sa:passwd=acsdev123!:srvname=.:dbname=develop'
	let g:dbext_default_profile_harbor = 'type=SQLSRV:user=sa:passwd=acsdev123!:srvname=.:dbname=harbor'
	let g:dbext_default_profile_system = 'type=SQLSRV:user=sa:passwd=acsdev123!:srvname=.:dbname=system'
	let g:dbext_default_profile_utility = 'type=SQLSRV:user=sa:passwd=acsdev123!:srvname=.:dbname=utility'
	let g:dbext_default_profile_orgs='type=pgsql:host=localhost:user=mattr:dsnname=orgs:dbname=orgs'
	let g:dbext_default_profile_changelog='type=pgsql:host=localhost:user=mattr:dsnname=changelog:dbname=changelog'
	let g:dbext_default_profile_shepherd='type=pgsql:host=localhost:user=mattr:dsnname=shepherd:dbname=shepherd'
	let g:dbext_default_profile_experiments='type=pgsql:host=localhost:user=mattr:dsnname=experiments:dbname=experiments'

	vnoremap <f5> :call ExecuteVisualSql()<cr>
	nnoremap <f5> :call ExecuteSql()<cr>
	"}}}

	"supertab {{{
		let g:SuperTabNoCompleteAfter = ['\s','^',',']
	"}}}

	"ctags {{{
		let g:ctags_path = "/home/mattr/.gvm/pkgsets/go1.16/global/bin/gotags"
		let g:ctags_statusline=1
		let g:ctags_title=1
		let g:ctags_args='-I __declspec+'
	"}}}

	"solarized{{{
	let g:solarized_italic=0
	"}}}

	"vim-go{{{

		let g:go_highlight_fields = 1
		let g:go_highlight_functions = 1
		let g:go_highlight_function_calls = 1
		let g:go_highlight_extra_types = 1
		let g:go_highlight_operators = 1
		let g:go_auto_type_info = 1
		let g:go_doc_popup_window = 1
		let g:go_debug_breakpoint_sign_text = '🟠'

		let g:go_build_tags = 'unit'

		let g:go_fmt_autosave = 1
		let g:go_fmt_command = "goimports"
		let g:go_fmt_fail_silently = 1
		let g:go_list_type = "quickfix"

		let g:go_build_tags = "unit"
        let g:go_debug_use_getcwd = "true"
		augroup vimgo_commands
			autocmd!

			autocmd FileType go nnoremap <leader>si :GoDebugStep<cr>
			autocmd FileType go nnoremap <leader>so :GoDebugStepOut<cr>
		augroup end
	"}}}

    "SnipMate {{{
        let g:snipMate = { 'snippet_version' : 1 }
    "}}}

	"NerdTree {{{
		let NERDTreeShowHidden=1
	"}}}

	"markdown-preview{{{
		let g:mkdp_auto_start = 0
		let g:mkdp_auto_close = 1
		let g:mkdp_refresh_slow = 0
		let g:mkdp_command_for_global = 0
		let g:mkdp_open_to_the_world = 0
		let g:mkdp_open_ip = ''

		let g:mkdp_browser = 'sensible-browser'

		let g:mkdp_echo_preview_url = 1

		" a custom vim function name to open preview page
		" this function will receive url as param
		" default is empty
		let g:mkdp_browserfunc = ''

		" options for markdown render
		" mkit: markdown-it options for render
		" katex: katex options for math
		" uml: markdown-it-plantuml options
		" maid: mermaid options
		" disable_sync_scroll: if disable sync scroll, default 0
		" sync_scroll_type: 'middle', 'top' or 'relative', default value is 'middle'
		"   middle: mean the cursor position alway show at the middle of the preview page
		"   top: mean the vim top viewport alway show at the top of the preview page
		"   relative: mean the cursor position alway show at the relative positon of the preview page
		" hide_yaml_meta: if hide yaml metadata, default is 1
		" sequence_diagrams: js-sequence-diagrams options
		" content_editable: if enable content editable for preview page, default: v:false
		" disable_filename: if disable filename header for preview page, default: 0
		let g:mkdp_preview_options = {
			\ 'mkit': {},
			\ 'katex': {},
			\ 'uml': {},
			\ 'maid': {},
			\ 'disable_sync_scroll': 0,
			\ 'sync_scroll_type': 'middle',
			\ 'hide_yaml_meta': 1,
			\ 'sequence_diagrams': {},
			\ 'flowchart_diagrams': {},
			\ 'content_editable': v:false,
			\ 'disable_filename': 0
			\ }

		let g:mkdp_port = ''
		let g:mkdp_page_title = '「${name}」'
		let g:mkdp_filetypes = ['markdown']
		"}}}
"}}}

"Sets{{{

	if exists("&renderoptions")
		set renderoptions=type:directx
	endif

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
	"set listchars=tab:»\ ,trail:·
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
	set cursorline
	set cursorcolumn
	if exists('&spelloptions') 
		set spelloptions=camel
	endif

	if has('gui_running')
		set guifont=Fira_Code:h10:cANSI:qDRAFT
		set guioptions -=m
		set guioptions-=T  " no toolbar
		colorscheme sublimemonokai
	else
		colorscheme sublimemonokai
		highlight Cursor guifg=white guibg=red
	endif

	highlight default spacesbad term=undercurl ctermbg=13 gui=undercurl guisp=#2aa198
	highlight default CodeSmells ctermbg=red guibg=red
	match CodeSmells /\v\s$/
	"2match spacesbad /  /

"}}}

"Maps{{{

	map <MiddleMouse> <Nop>
	imap <MiddleMouse> <Nop>
	map <2-MiddleMouse> <Nop>
	imap <2-MiddleMouse> <Nop>

	"copy to system clipboard
	"vnoremap <C-c> "+y
	" leader+h searches for word under cursor
	vnoremap <leader>h y:<C-U>let @/="<C-R>=@"<CR>"<CR>:set hls<CR>
	""un-J this, or put a new line here
	"nnoremap <C-S-j> a<CR><Esc>kA<Esc>
	"clear highlighting
	nnoremap <C-L> :nohl<CR><C-L>
	" new line
	nnoremap <leader>nl o<Esc>
	"Ctrl+S saves
	nnoremap <C-s> :w<cr>
	""new line
	"nnoremap <Leader>o i<cr><Esc>
	" paste the last line copied (not last deleted)
	nnoremap <Leader>p "0p
	" edit and save vimrc
	nnoremap <leader>ev :vsplit ~/.vimrc<cr>
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
	"nnoremap <C-v> "+p
	"f6 moves windows
	nnoremap <f6> :wincmd W<cr>
	"paste over word
	nnoremap <leader>rp ciw<C-r>0<esc>
	"paste from system over everything
	"nnoremap <C-S-v> :PasteOver<cr>

	"escape home rows
	"inoremap jjk <Esc>
	" new line below
	"inoremap <C-J> <Esc>jo
	" new line above
	"inoremap <C-K> <Esc>ko
	" save in insert mode
	"inoremap <C-s> <Esc>:w<cr>a
	" write
	" make Ctrl+V work as expected
	"inoremap <C-v> <C-r>+<right>
	"inoremap <C-S-v> <esc>"+pa
	inoremap }k }<esc>O
	inoremap uuuu <esc>viwgUea
    inoremap kkk <esc>k
	"inoremap [] []<Esc>i
	"Shift+arrows to select
	"inoremap <C-S-Left> <esc>vb
	"inoremap <C-S-Right> <esc>ve
	"inoremap <S-Left> <esc>vh
	"inoremap <S-Right> <esc>vl
	inoremap <S-Tab> <C-x><C-o>

	" paste over selection
	"vnoremap <C-v> d"+p

"}}}

"AutoCmd{{{
	augroup myAutoCmds
		autocmd!
		autocmd BufNewFile, BufRead *.config set filetype=xml
		autocmd FileType xml,xsl,xslt,xsd setlocal foldmethod=syntax
		autocmd BufEnter * syntax sync minlines=1000

		autocmd FileType *.go setlocal autowriteall
		autocmd CursorHold *.go update

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
	"nnoremap <C-M-u> :call SmoothScroll("up",2)<cr>
	"nnoremap <C-M-d> :call SmoothScroll("down",2)<cr>

	function! DropCurrentBuffer()
		" drops the current buffer without closing window"
		let cbuf=bufnr('%')
		execute 'bp'
		execute "bd ".cbuf
	endfunction
	command! -nargs=0 BD execute "call DropCurrentBuffer()"

	command! Nom execute "%s///g"
	command! BM execute "bufdo | bd!"
	if has("win32")
		command! SAC execute 'normal! ggVG"+y'
	else
		command! SAC execute 'normal! ggVG:!~/copy.sh'
	endif

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
    command! -nargs=0 TrimEOL execute "%s/\\v[\\t ]+\\n/\\r/g"
	command! -nargs=0 BufOnly silent! execute "%bd|e#|bd#"

	function! ExecuteVisualSql()
		execute ":DBExecVisualSQL"
	endfunction
	function! ExecuteSql()
		execute ":DBExecSQLUnderCursor"
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

	" Sometimes Ag will leave its popup window there unusable
	command! ClearPopup call popup_clear(1)

	function! GetWindowsClipboardContents()
		let winclip = system("/usr/local/lib/node_modules/pasty-clipboard-editor/node_modules/clipboardy/fallbacks/windows/clipboard_x86_64.exe --paste")
		let @" = winclip
	endfunction
	command! -nargs=0 GetClip execute "call GetWindowsClipboardContents()"

	" WSL yank support
	let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point
	if executable(s:clip)
		augroup WSLYank
			autocmd!
			autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
		augroup END
	endif


	"vnoremap <C-S-c> :!~/copy.sh<cr>u


"}}

"}
