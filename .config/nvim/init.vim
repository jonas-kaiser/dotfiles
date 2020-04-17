"             _
"            (_)
"  _ ____   ___ _ __ ___    _ __ ___
" | '_ \ \ / / | '_ ` _ \  | '__/ __|
" | | | \ V /| | | | | | | | | | (__
" |_| |_|\_/ |_|_| |_| |_| |_|  \___|


" ====== Basic =========================================================== {{{
if has('mouse')
	set mouse=a
endif
" }}}

" ====== Plugins ========================================================= {{{
call plug#begin('~/.config/nvim/plugged')

" deoplete needs msgpack 1.0.0+ (installed via `pip install --user msgpack==1.0.0`)
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'deoplete-plugins/deoplete-clang'

call plug#end()

let g:deoplete#enable_at_startup = 1
" }}}

" ====== Backup and Undo files =========================================== {{{

set backup
if has('persistent_undo')
	set undofile
endif

set undodir=~/.config/nvim/.undo//
set backupdir=~/.config/nvim/.backup//
set directory=~/.config/nvim/.swp//
"}}}

" ====== Appearance ====================================================== {{{

" Always show status line
set laststatus=2

" Default statusline looks like this:
"set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

" Displays decimal and hex value of current char
set statusline=%<%f\ %h%m%r%=%b\ %-10.(0x%B\%)%-14.(%l,%c%V%)\ %P

set number relativenumber
set scrolloff=5

syntax enable

" Trailing whitespace
	" This one highlights all the time
	"autocmd BufEnter,WinEnter * call matchadd("Error", "\\s\\+$", -1)

	" This one disappears in insert mode
	highlight ExtraWhitespace ctermbg=red guibg=red
	match ExtraWhitespace /\s\+$/
	autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
	autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
	autocmd InsertLeave * match ExtraWhitespace /\s\+$/
	autocmd BufWinLeave * call clearmatches()

" Show hidden chars
"set list
set listchars=tab:→\ ,nbsp:␣,trail:•,precedes:«,extends:»
"set listchars=tab:»\ ,space:·,nbsp:␣,trail:•,eol:¶,precedes:«,extends:»
"}}}

" ====== Indentation ===================================================== {{{

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

" For Tabs == 4 Spaces:
	"set tabstop=4
	"set shiftwidth=4
	"set expandtab

"" To indent with tabs, and allign with spaces:
"" (see http://vim.wikia.com/wiki/Indent_with_tabs,_align_with_spaces#Smart_tabs for reference)
"	set noet sts=0 sw=8 ts=8
"	" this is set automatically via filetype detection and wouldn't be useful for e.g. text files
"	"set cindent
"	set cinoptions+=(0,u0,U0        " allign continuation lines
"	" for some reason java files ignore this setting.... (TODO whyyyy)
"	autocmd Filetype java set cinoptions+=(0,u0,U0
"	" Use the SmartTabs plugin (see ~/.vim/plugin/ctab) to replace <tab>s with spaces if
"	" they're not at beginning of a line.

augroup java_ft
	au!
	autocmd BufNewFile,BufRead *.java set ts=4 sw=4 et list
augroup END

augroup html_ft
	au!
	autocmd BufNewFile,BufRead *.html set ts=2 sw=2 et list

" }}} End Indentation

" ====== Completion ====================================================== {{{
"au FileType c setl ofu=ccomplete#CompleteCpp
" }}} End Completion

" ====== Tab and Split Behavior ========================================== {{{

" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
set splitbelow
set splitright

" Shortcutting split navigation, saving a keypress:
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Move to next/previous tab
nnoremap H gT
nnoremap L gt

"}}}


" ====== Navigating with guides <++> ===================================== {{{

" Replace next guide
noremap ,, <Esc>/<++><Enter>"_c4l
inoremap ,, <Esc>/<++><Enter>"_c4l
vnoremap ,, <Esc>/<++><Enter>"_c4l
noremap ,< <Esc>?<++><Enter>"_c4l
inoremap ,< <Esc>?<++><Enter>"_c4l
vnoremap ,< <Esc>?<++><Enter>"_c4l

" Place a guide '<++>'
inoremap ,g <++>

" TODO implement snippets with ,keyword
autocmd Filetype tex,latex,plaintex inoremap ,s \section{<++>}<Esc>ba
autocmd Filetype tex,latex,plaintex inoremap ,ss \subsection{<++>}<Esc>ba
autocmd Filetype tex,latex,plaintex inoremap ,sss \subsubsection{<++>}<Esc>ba
autocmd Filetype tex,latex,plaintex inoremap ,p \paragraph{<++>}<Esc>ba
autocmd Filetype tex,latex,plaintex inoremap ,i \begin{itemize}<Enter>\end{itemize}<Esc>O\item <++><Esc>ba
autocmd Filetype tex,latex,plaintex inoremap ,en \begin{enumerate}<Enter>\end{enumerate}<Esc>O\item <++><Esc>ba
autocmd Filetype tex,latex,plaintex inoremap ,t \begin{tabular}{\|l\|l\|}<Enter>\end{tabular}<Esc>O\hline<Enter><++><Esc>ba
autocmd Filetype tex,latex inoremap ,ex \begin{solution}<Enter>\end{solution}<Esc>O<++><Esc>kO\begin{exercise}<Enter>\end{exercise}<Esc>O<++><Esc>ba

autocmd Filetype java inoremap sout System.out.println();<Esc>F(a

" }}}

" ====== Spell Check <F6> ================================================ {{{

let b:myLang=0
let g:myLangList=["nospell","en_us","de_de"]
function! ToggleSpell()
	if !exists("b:myLang")
		let b:myLang=0
	endif
	let b:myLang=b:myLang+1
	if b:myLang>=len(g:myLangList) | let b:myLang=0 | endif
	if b:myLang==0
		setlocal nospell
	else
		execute "setlocal spell spelllang=".get(g:myLangList, b:myLang)
	endif
	echo "spell checking language:" g:myLangList[b:myLang]
endfunction

nmap <silent> <F6> :call ToggleSpell()<CR>
"}}}

" ====== Other mappings and autocmds ===================================== {{{

" Load a template file with <Leader> t
map <leader>t :0r<space>~/Templates/<C-d>

" Run xrdb whenever Xdefaults or Xresources are updated.
autocmd BufWritePost ~/.Xresources,~/.Xdefaults !xrdb %

" Runs a script that cleans out tex build files whenever I close out of a .tex file.
autocmd VimLeave *.tex !texclear %

:command RemoveTrailingWhitespace %s/\s\+$//e

"}}}


" vim:foldmethod=marker:foldenable
