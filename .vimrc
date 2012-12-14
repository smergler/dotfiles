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
colorscheme default
filetype plugin on
"set mouse:a
silent! set mouse=nvc       " Use the mouse, but not in insert mode

set ofu=syntaxcomplete#Complete " Set omni-completion method.
set omnifunc=ft-php-omni              " this one neither


" SubSection: Folding Options
" ---------------------------------------------------------------------------
set foldenable
set foldmethod=indent       " I work with devs who dont use VIM, so they start
                            " to wonder about {{1's
set foldminlines=1          " Only Fold when more than one line


" SubSection: Tab Options
" ---------------------------------------------------------------------------
set autoindent              " Carry over indenting from previous line
set smarttab                " a <Tab> in front of a line inserts blanks
                            " according to shiftwidth
set shiftwidth=2            " The # of spaces for indenting.
set tabstop=2               " option 4 from :help tabstop
set softtabstop=2           " Tab key results in 2 spaces
set noexpandtab             " Keep ALL the tabs
set bs=2                    " Allow backspacing of everything
set tw=80                   " set max line to 80




" Section: Mappings
" ---------------------------------------------------------------------------
" Why not use the space or return keys to toggle folds?
nnoremap <space> za
nnoremap <CR> za
nnoremap <C-c> zA

map <C-t> :NERDTreeToggle<CR>

map <C-e> :e#<CR>
map b :e#<CR>
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



" Syntastic
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

" Lithium configuration
"-- Encoding
set fileencodings=utf-8

autocmd BufWritePre * :%s/\s\+$//e
set list
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<


" Pathogen
filetype off " Pathogen needs to run before plugin indent on
call pathogen#runtime_append_all_bundles()
call pathogen#helptags() " generate helptags for everything in 'runtimepath'
filetype plugin indent on
