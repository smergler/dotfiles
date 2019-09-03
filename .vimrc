"
" This is a list of options, remappings, commands that I've used over the
" years, some taken from statico, some from paulirish, others I've found and
" liked
"

" Section: Options
" ---------------------------------------------------------------------------
set sm                      " show matching brace or parenthesis while inserting
set ic                      " Change default to ignore case for text searches
set hls                     " Highlight searches


set bdir=~/.vim/backup/
set dir=~/.vim/swap/
set undodir=~/.vim/undo/
set cursorline              " Highlight current line
set cindent                 " automatic indenting, might take it out later
set number                  " show line numbers
set incsearch               " Search as you type
set ignorecase              " Case insensitive
set ruler                   " show the colum width and line number
syntax on
autocmd BufEnter * :syntax sync fromstart " sync syntax from start of file (fixes bug with folds, but can slow down vim)
colorscheme default
filetype plugin on
"set mouse:a
silent! set mouse=nvc       " Use the mouse, but not in insert mode

set ofu=syntaxcomplete#Complete " Set omni-completion method.
set omnifunc=ft-php-omni              " this one neither
set clipboard=unnamed           " Set bi-directional clipboard
"set wildignorecase              " allows for opening files with case insensitivity


" SubSection: Folding Options
" ---------------------------------------------------------------------------
set foldenable
set foldmethod=indent       " I work with devs who dont use VIM, so they start
                            " to wonder about {{1's
set foldminlines=1          " Only Fold when more than one line


" SubSection: Tab Options
" ---------------------------------------------------------------------------
set autoindent              " Carry over indenting from previous line
"set smarttab                " a <Tab> in front of a line inserts blanks
                            " according to shiftwidth
set shiftwidth=2            " The # of spaces for indenting.
set tabstop=2               " option 4 from :help tabstop
set softtabstop=2           " Tab key results in 2 spaces
set expandtab               " Keep ALL the tabsa
set bs=2                    " Allow backspacing of everything
set tw=1180                   " set max line to 80
set exrc                    " if a .vimrc file is in the working dir, use it
set secure                  " restrict usage of some commands in non-default .vimrc files



" Section: Plugs
" ---------------------------------------------------------------------------
"
" Specify a directory for plugins
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')


Plug 'johngrib/vim-game-snake'

" NERDTree - A tree explorer plugin for vim.
Plug 'scrooloose/nerdtree'

" Syntastic - Syntax checking hacks for vim
Plug 'vim-syntastic/syntastic'

" vim-fugitive - Git Wrapper
Plug 'tpope/vim-fugitive'

" git gutter - Git diff-er
Plug 'airblade/vim-gitgutter'

" Mustache template system for VIMScript
Plug 'tobyS/vmustache'

" UltiSnips - The ultimate snippet solution for Vim
Plug 'SirVer/ultisnips'

" pdv PHP Documentor for VIM
Plug 'tobyS/pdv'

" ctrlp Fuzzy file, buffer, mru, tag, etc finder
Plug 'ctrlpvim/ctrlp.vim'

" Editor config
Plug 'editorconfig/editorconfig-vim'

" typescript syntax for vim
Plug 'leafgarland/typescript-vim'

" Vim Plugin for typescript
Plug 'Quramy/tsuquyomi'

" adds API Blueprint syntax
Plug 'kylef/apiblueprint.vim'

"lightline updates the statusline/tabline
Plug 'itchyny/lightline.vim'

" Vim-go for all your go needs
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" capslock.vim to train for newer macs
Plug 'tpope/vim-capslock'

" Vim Airline - apparently very pretty
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Initialize plugin system
call plug#end()

" Section: Mappings
" ---------------------------------------------------------------------------
" Why not use the space or return keys to toggle folds?
nnoremap <space> za
nnoremap <CR> za
nnoremap <C-c> zA

" NERDTree plugin specific commands
:nnoremap <C-g> :NERDTreeToggle<CR>

map <C-e> :e#<CR>
map e :e#<CR>
map <C-x>o <C-w><C-w>
map <C-x>0 <C-w>c
map <C-x>1 <C-w>o
map <C-x>1 <C-w>s
map <C-x>1 <C-w>v

" Alt-p pipes the current buffer to the current filetype as a command
" (good for perl, python, ruby, shell, gnuplot...)
nmap <M-p>  :call RunUsingCurrentFiletype()<CR>
nmap <Esc>r :call RunUsingCurrentFiletype()<CR>

function! RunUsingCurrentFiletype()
    execute 'write'
    execute '! clear; '.&filetype.' <% '
endfunction

" i always, ALWAYS hit ":W" instead of ":w"
command! Q q
command! W w

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint', './node_modules/.bin/eslint']
let g:syntastic_javascript_eslint_exe = 'npm run lint'
let g:syntastic_php_checkers = ['php', 'phpcs', 'phpmd']
let g:syntastic_json_checkers=['jsonlint']


" Status line
set statusline=
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%{FugitiveStatusline()}
set statusline+=\  "separator
set statusline+=%l
set statusline+=/
set statusline+=%L
set statusline+=\  "separator
set statusline+=%f "tail of the filename
set statusline+=%*
set laststatus=2

" Lithium configuration
"-- Encoding
set fileencodings=utf-8

autocmd BufWritePre * :%s/\s\+$//e
set list
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<

au BufRead,BufNewFile *.handlebars,*.hbs,*.html set ft=html syntax=handlebars

let g:ragtag_global_maps = 1

let g:pdv_template_dir = $HOME ."/.vim/plugged/pdv/templates_snip"
nnoremap <C-o> :call pdv#DocumentWithSnip()<CR>

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlPMixed'

set noexpandtab             " Keep ALL the tabs
:au BufWinEnter *.php,*.py let w:m1=matchadd('Search', '\%<101v\%>80v', -1)
:au BufWinEnter *.php,*.py let w:m2=matchadd('ErrorMsg', '\%>100v.', -1)

" checking out buffers from this article
" http://joshldavis.com/2014/04/05/vim-tab-madness-buffers-vs-tabs/
let g:airline#extensions#tabline#enabled = 1        " Enable the list of buffers
let g:airline#extensions#tabline#fnamemod = ':t'    " Show just the filename
set hidden                                          " My preference with using buffers. See `:h hidden` for more details
" To open a new empty buffer
nmap <Leader>T :enew<cr>
" Move to the next buffer
nmap gt :bnext<CR>
" Move to the previous buffer
nmap gT :bprevious<CR>
" Close the current buffer and move to the previous one
nmap <Leader>bq :bp <BAR> bd #<CR>
" Show all open buffers and their status
nmap <Leader>bl :ls<CR>

" fugitive mappings
map gs :Gstatus<CR>
map gc :Gcommit<CR>
map gp :Git push<CR>

" capslock mapping
imap <C-L> <C-O><Plug>CapsLockToggle

"gitgutter mappings
"nmap ]h <Plug>GitGutterNextHunk
"nmap [h <Plug>GitGutterPrevHunk
"nmap ha <Plug>GitGutterStageHunk
"nmap hr <Plug>GitGutterUndoHunk
"nmap hv <Plug>GitGutterPreviewHunk

" Press i to enter insert mode, and ii to exit.
imap ii <Esc>

" vim-go settings
let g:go_fmt_command = "goimports"    " Run goimports along gofmt on each save
let g:go_auto_type_info = 1           " Automatically get signature/type info for object under cursor

