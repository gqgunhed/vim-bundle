version 6.0
if &cp | set nocp | endif
let s:cpo_save=&cpo
set cpo&vim
map! <S-Insert> <MiddleMouse>
nmap gx <Plug>NetrwBrowseX
nnoremap <silent> <Plug>NetrwBrowseX :call netrw#NetrwBrowseX(expand("<cWORD>"),0)
map <S-Insert> <MiddleMouse>
let &cpo=s:cpo_save
unlet s:cpo_save

"" by gunhed
    "set runtimepath=~/.vim,/var/lib/vim/addons,/usr/share/vim/vimfiles,/usr/share/vim/vim73,/usr/share/vim/vimfiles/after,/var/lib/vim/addons/after,~/.vim/after
    "set runtimepath=$HOME\vimfiles,$VIM\vimfiles,$VIMRUNTIME,$VIM\vimfiles\after,$HOME\vimfiles\after,$HOME\vimfiles\bundle,$HOME\vimfiles\autoload
" Pathogen load
    filetype off
    call pathogen#infect()
    call pathogen#helptags()
    filetype plugin indent on
    syntax on

    set nomodeline  "" FreeBSD security advisory
    set nocompatible
    ""set visualbell
    set noerrorbells
"" Encodings and Fonts
    "set fileencodings=utf-8,default,latin1
    set fileencodings=utf-8
    set termencoding=utf-8
    set encoding=utf-8
    set window=59
    "set guifont=DejaVu_Sans_Mono:h11
    set guifont=Source_Code_Pro:h10
    "set guifont=Sauce_Code_Powerline:h10
    let g:tex_flavors='latex'
"" help and history
    set helplang=de
    set history=500
"" Sucheinstellungen
    set hlsearch    "" Hervorheben der Treffer
    set incsearch   "" beim Tippen zum ersten Treffer springen
    set ignorecase
    set smartcase
    set showmatch
"" Statuszeile
    set laststatus=2
    "" this statusline does not work under MS Windows
    "set statusline=%n:\ %f%m%r%h%w\ [%Y,%{%fileencoding},%{&fileformat}]\ [%l-%L,%v][%p%%%]\ [%{strftime(\"%l:%M:%S\ \%p,\ %a\ %b\ %d,\ %Y\")}]
    set ruler
    ""set rulerformat=%25(%n%m%r;\ %Y\ [%l,%v]\ %p%%%)
    set showmode
    set number
    "" from http://spf13.com/post/perfect-vimrc-vim-config-file/
    if has('cmdline_info')
        set ruler                   " show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " a ruler on steroids
        set showcmd                 " show partial commands in status line and
                                    " selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=2

        " Broken down into easily includeable segments
        set statusline=%<%f\   " Filename
        set statusline+=%w%h%m%r " Options
        set statusline+=%{fugitive#statusline()} "  Git Hotness
        set statusline+=\ [%{&ff}/%Y]            " filetype
        set statusline+=\ [%{getcwd()}]          " current dir
        "set statusline+=\ [A=\%03.3b/H=\%02.2B] " ASCII / Hexadecimal value of char
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif
    "" endfrom http://spf13.com/post/perfect-vimrc-vim-config-file/

"" optical positioning
    set cursorline
    set cursorcolumn
    set mouse=a
    set printoptions=paper:a4
"" Tab-Einstellungen
    set expandtab   "" Tabs zu Leerschritten
    set shiftwidth=4
    set softtabstop=4
    set tabstop=4
"" Einrück und Folding
    set smartindent
    set autoindent
    set backspace=indent,eol,start
    set foldmethod=indent
"" Zeileneinstellungen
    set textwidth=79
    ""set linebreak
    set wrap
    ""set list

set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" vim: set ft=vim :

"" keymappings
    map <F9> :if has("syntax_items")<CR>syntax off<CR>else<CR>syntax on<CR>endif<CR><CR>

"" set my colorscheme
    ""colorscheme kingtop
    "" colorscheme night
    "" colorscheme neon
    ""colorscheme evening
    colorscheme zenburn
    "set background=dark
"" CtrlP settings
    let g:ctrlp_map = '<c-p>'
    let g:ctrlp_cmd = 'CtrlP'
    let g:ctrlp_working_path_mode = 'ra'
"" PowerLine settings
    "let g:Powerline_symbols = 'fancy'
    let g:Powerline_symbols = 'unicode'
"" UltiSnips like TextMate
    let g:UltiSnipsExpandTrigger="<tab>"
    let g:UltiSnipsJumpForwardTrigger="<tab>"
    let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
""NERDTree settings
    "" opens NERDTree if no startup-filename is given
    autocmd vimenter * if !argc() | NERDTree | endif
    "" closes vim if NERDTree is only window left
    ""autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

    " Map NERDTreeToggle to convenient key
    nnoremap <silent> <c-n> :NERDTreeToggle<cr>

    " bufkill bd's: really do not mess with NERDTree buffer
    nnoremap <silent> <backspace> :BD<cr>
    nnoremap <silent> <s-backspace> :BD!<cr>

    " Prevent :bd inside NERDTree buffer
    au FileType nerdtree cnoreabbrev <buffer> bd <nop>
    au FileType nerdtree cnoreabbrev <buffer> BD <nop>

" Python optimizations
    ""autocmd BufRead *.py set foldmethod=indent
    ""autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
    autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``

"" python-mode settings
    " Load rope plugin
    let g:pymode_rope = 1
    " Additional python paths
    let g:pymode_paths = ['$HOME\vimfiles\bundle\python-mode', '$HOME\vimfiles\bundle\python-mode\pylibs']

"" tasklist settings
    map T :TaskList<CR>

"" TagList
    "nnoremap <silent> <F8> :TlistToggle<CR>
    "nnoremap <silent> <c-F8> :TlistUpdate<CR>
    "" open taglist on startup
    let Tlist_Auto_Open = 0
    "" update taglist on filesave
    let Tlist_Auto_Update = 1
    "" jump into taglist window?
    let Tlist_GainFocus_On_ToggleOpen = 0

"" TagBar
    nmap <F8> :TagbarToggle<CR>    

"" from: http://vimcasts.org/episodes/whitespace-preferences-and-filetypes/
" Only do this part when compiled with support for autocommands
if has("autocmd")
  " Enable file type detection
  filetype on
  
  " Syntax of these languages is fussy over tabs Vs spaces
  autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
  
  " Customisations based on house-style (arbitrary)
  autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType javascript setlocal ts=4 sts=4 sw=4 noexpandtab
  autocmd FileType python setlocal ts=4 sts=4 sw=4 expandtab
  autocmd FileType lua setlocal ts=4 sts=4 sw=4 expandtab
  
  " Treat .rss files as XML
  autocmd BufNewFile,BufRead *.rss setfiletype xml
endif

"" from: http://vimcasts.org/episodes/tidying-whitespace/
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
autocmd BufWritePre *.py,*.js :call <SID>StripTrailingWhitespaces()
