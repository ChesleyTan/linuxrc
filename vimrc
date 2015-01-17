" General configuration {{{
" vim:fdm=marker
set nocompatible " Disable Vi-compatibility settings
set hidden " Hides buffers instead of closing them, allows opening new buffers when current has unsaved changes
"set title " Show title in terminal
set number " Show line numbers
set wrap " Wrap lines
set linebreak " Break line on word
set hlsearch " Highlight search term in text
set incsearch " Show search matches as you type
set wrapscan " Automatically wrap search when hitting bottom
set autoindent " Enable autoindenting
set copyindent " Copy indent of previous line when autoindenting
set history=1000 " Command history
set undolevels=500 " Levels of undo
set wildignore=*.class " Ignore .class files
set tabstop=4 " Tab size
set expandtab " Spaces instead of tabs
set softtabstop=4 " Treat n spaces as a tab
set shiftwidth=4 " Tab size for automatic indentation
set shiftround " When using shift identation, round to multiple of shift width
set laststatus=2 " Always show statusline on last window
set pastetoggle=<F3> " Toggle paste mode
set mouse=a " Allow using mouse to change cursor position
set timeoutlen=300 " Timeout for entering key combinations
set t_Co=256 " Enable 256 colors
set textwidth=80 " Maximum width in characters
set synmaxcol=150 " Limit syntax highlight parsing to first 150 columns
set foldmethod=marker " Use vim markers for folding
set foldnestmax=4 " Maximum nested folds
set noshowmatch " Do not temporarily jump to match when inserting an end brace
set nocursorline " Highlight current line
set lazyredraw " Conservative redrawing
set backspace=indent,eol,start " Allow full functionality of backspace
syntax enable " Enable syntax highlighting
filetype indent on " Enable filetype-specific indentation
filetype plugin on " Enable filetype-specific plugins
colorscheme default " Set default colors

" Autocompletion settings
set completeopt=longest,menuone,preview

" Command line completion settings
set wildmode=longest,list,full
set wildmenu

" Backup settings
set backup " Back up previous versions of files
set backupdir=$HOME/.vim/backup// " Store backups in a central directory
set backupdir+=. " Alternatively, store backups in the same directory as the file
" Create backup directory if it does not exist
if !isdirectory($HOME . '/.vim/backup/')
    call mkdir($HOME . '/.vim/backup/')
endif

" GUI settings
set guioptions-=L "Remove left-hand scrollbar
set guioptions-=r "Remove right-hand scrollbar
set guioptions-=T "Remove toolbar
set guifont=Monaco\ 10 "Set gui font
set winaltkeys=no "Disable use of alt key to access menu

" Session settings
set sessionoptions-=options    " Do not save global and local values
set sessionoptions-=folds      " Do not save folds

" Autocommands
augroup defaults
    " Clear augroup
    autocmd!
    " Execute runtime configurations for plugins
    autocmd VimEnter * call PluginConfig()
    autocmd BufWritePost * call RefreshGitInfo()
    " Change statusline color when entering insert mode
    autocmd InsertEnter * call RefreshColors(g:insertModeStatuslineColor_cterm, g:insertModeStatuslineColor_gui)
    autocmd InsertLeave * call ToggleStatuslineColor()
augroup END

" List/listchars
set list
execute "set listchars=tab:\u2592\u2592,trail:\u2591"
" }}}
" Custom mappings {{{
:command Q q
:command W w
cmap Q! q!
" Prevent Ex Mode
map Q <Nop>
" Use jj to exit insert mode, rather than <Esc>
inoremap jj <Esc>
" Map ; to : in normal mode
nnoremap ; :
" Map : to ; in normal mode
nnoremap : ;
" Use Control + (hjkl) to mimic arrow keys for navigating menus in insert mode
inoremap <C-k> <Up>
inoremap <C-j> <Down>
inoremap <C-h> <Left>
inoremap <C-l> <Right>
" Smart indent when entering insert mode
nnoremap <expr> i SmartInsertModeEnter()
" Easy buffer switching
nnoremap <Leader>b :buffers<CR>:buffer<Space>
nnoremap t :tabnew
" Clear hlsearch using Return/Enter
nnoremap <CR> :noh<CR><CR>
" Allow saving when forgetting to start vim with sudo
cmap w!! w !sudo tee > /dev/null %
" Easy toggle for paste
nnoremap <C-p> :set paste!<CR>:echo "Paste mode: " . &paste<CR>
" Easy page up/down
nnoremap <C-Up> <C-u>
nnoremap <C-Down> <C-d>
nnoremap <C-k> <C-u>
nnoremap <C-j> <C-d>
vnoremap <C-k> <C-u>
vnoremap <C-j> <C-d>

" Allow window commands in insert mode (currently overridden by omnicomplete binding)
" imap <C-w> <C-o><C-w>
" Easy split navigation using alt key
nnoremap <A-Up> <C-w><Up>
nnoremap <A-Down> <C-w><Down>
nnoremap <A-Left> <C-w><Left>
nnoremap <A-Right> <C-w><Right>
nnoremap <A-k> <C-w><Up>
nnoremap <A-j> <C-w><Down>
nnoremap <A-h> <C-w><Left>
nnoremap <A-l> <C-w><Right>
" Mapping alt+(hjkl) doesn't work in terminal, so we use escape codes instead
nnoremap k <C-w><Up>
nnoremap j <C-w><Down>
nnoremap h <C-w><Left>
nnoremap l <C-w><Right>
" Note: <bar> denotes |
" Shortcuts for window commands
nnoremap <bar> <C-w>v
nnoremap <bar><bar> :vnew<CR><C-w>L
nnoremap _ <C-w>s
nnoremap __ <C-w>n
nnoremap - <C-w>-
nnoremap + <C-w>+
nnoremap > <C-w>>
nnoremap < <C-w><
" Mappings to move window splits
nnoremap <Space><Left> <C-w>H
nnoremap <Space><Right> <C-w>L
nnoremap <Space><Up> <C-w>K
nnoremap <Space><Down> <C-w>J
nnoremap <Space>h <C-w>H
nnoremap <Space>l <C-w>L
nnoremap <Space>k <C-w>K
nnoremap <Space>j <C-w>J
" Easy system clipboard copy/paste
vnoremap <C-c> "+y
vnoremap <C-x> "+x
inoremap <C-S-v> <Esc>"+pi
iunmap <C-V>
" Autocompletion bindings
inoremap <C-O> <C-X><C-O>
inoremap <C-U> <C-X><C-U>
" Mapping for autoformat
nnoremap <C-f> gq
nnoremap <C-S-f> mkggVGgq'k
" Spell ignore commands
command SpellIgnoreOnce normal zG
command SpellIgnore normal zg
" Navigation mappings
" Jump to beginning of tag
nnoremap {{ vat<Esc>'<
" Jump to end of tag
nnoremap }} vat<Esc>'>
nnoremap <Tab> ==
vnoremap <Tab> =
" Easy delete to black hole register
nnoremap D "_dd
" Quick toggle terminal background transparency
nnoremap <S-t> :call ToggleTransparentTerminalBackground()<CR>
" Quick toggle fold method
nnoremap <Leader>f :call ToggleFoldMethod()<CR>
" Quick toggle syntax highlighting
nnoremap <Leader>s :call SyntaxToggle()<CR>
" }}}
" Custom functions {{{

" This function is called by autocmd when vim starts
function! PluginConfig()
    if exists(":PingEclim") && !(eclim#PingEclim(0))
        echom "Eclimd not started"
    endif
    if !exists(":PingEclim") || (!(eclim#PingEclim(0)) && isdirectory(expand("$HOME/.vim/bundle/javacomplete")))
        echom "Enabling javacomplete for java files because eclimd is not started"
        augroup javacomplete
            autocmd Filetype java setlocal runtimepath+=$HOME/.vim/bundle/javacomplete
            autocmd Filetype java setlocal omnifunc=javacomplete#Complete
            autocmd Filetype java setlocal completefunc=javacomplete#CompleteParamsInfo
        augroup END
    else
        echom "Eclim enabled"
    endif
endfunction
let g:current_mode="default"
function! WordProcessorMode()
    if g:current_mode ==# "default"
        let g:current_mode="wpm"
        " Break line before one-letter words when possible
        setlocal textwidth=80
        setlocal formatoptions=t1
        setlocal noexpandtab
        setlocal spell spelllang=en_us
        setlocal spellcapcheck=""
        " Add dictionary to contextual completion
        setlocal dictionary=/usr/share/dict/words
        setlocal complete+=k
        setlocal wrap
        setlocal linebreak
    else
        let g:current_mode="default"
        setlocal formatoptions=tcq
        setlocal expandtab
        setlocal nospell
        setlocal complete-=k
    endif
endfunction
command WPM call WordProcessorMode()
function! s:DiffWithSaved()
    let filetype=&filetype
    diffthis
    vnew | r # | normal! 1Gdd
    diffthis
    execute "setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile readonly filetype=" . filetype
endfunction
command! DiffSaved call s:DiffWithSaved()
" Close the diff and return to last modified buffer
command! DiffQuit diffoff | b#
function! Molokai()
    if !has("gui_running")
        let g:rehash256 = 1
    endif
    colorscheme molokai
    call ToggleStatuslineColor()
endfunction
command Molokai call Molokai()
function! Solarized()
    set background=dark
    colorscheme solarized
    highlight Folded term=NONE cterm=NONE gui=NONE
    call ToggleStatuslineColor()
endfunction
command Solarized call Solarized()
function! ToggleStatuslineColor()
    call RefreshColors(g:defaultStatuslineColor_cterm, g:defaultStatuslineColor_gui)
endfunction
command ToggleStatuslineColor call ToggleStatuslineColor()
function! Custom()
    call ColorschemeInit()
endfunction
command Custom call Custom()
" Store default bg color
let g:original_bg_color = synIDattr(synIDtrans(hlID('Normal')), 'bg')
function! ToggleTransparentTerminalBackground()
    if (synIDattr(synIDtrans(hlID('Normal')), 'bg')) == -1
        if (g:original_bg_color == -1)
            execute "highlight Normal ctermbg=NONE"
        else
            execute "highlight Normal ctermbg=" . g:original_bg_color
        endif
        let g:original_bg_color = -1
    else
        let g:original_bg_color = synIDattr(synIDtrans(hlID('Normal')), 'bg')
        highlight Normal ctermbg=NONE
    endif
endfunction
function! ToggleFoldMethod()
    if &foldmethod ==? "manual"
        setlocal foldmethod=indent
    elseif &foldmethod ==? "indent"
        setlocal foldmethod=expr
    elseif &foldmethod ==? "expr"
        setlocal foldmethod=marker
    elseif &foldmethod ==? "marker"
        setlocal foldmethod=syntax
    elseif &foldmethod ==? "syntax"
        setlocal foldmethod=diff
    elseif &foldmethod ==? "diff"
        setlocal foldmethod=manual
    endif
    echo "Fold method set to: " . &foldmethod
endfunction
function! Rot13()
    normal mkggVGg?'k
endfunction
command Rot13 call Rot13()
function! DeflateWhitespace(string)
    let i = 0
    let newString = ""
    while i < len(a:string)
        if a:string[i] == " "
            let newString .= " "
            while a:string[i] == " "
                let i += 1
            endwhile
        endif
        let newString .= a:string[i]
        let i += 1
    endwhile
    return newString
endfunction
function! SmartInsertModeEnter()
    if len(getline('.')) == 0
        return "cc"
    else
        return "i"
    endif
endfunction
function! LAG()
    if &cursorline == 1
        set nocursorline " Disable cursorline
        set nonumber     " Disable line numbers
        "set laststatus=0 " Disable statusline
    else
        set cursorline   " Enable cursorline
        set number       " Enable line numbers
        "set laststatus=2 " Enable statusline
    endif
endfunction
command LAG call LAG()
function! RemoveWhitespace()
    % !sed 's/[ \t]*$//'
endfunction
command RemoveWhitespace call RemoveWhitespace()
function! SyntaxToggle()
    if exists('g:syntax_on')
        syntax off
        echo "Syntax: Disabled"
    else
        syntax enable
        echo "Syntax: Enabled"
        call ColorschemeInit()
    endif
endfunction
command SyntaxToggle call SyntaxToggle()

" }}}
" Custom colorscheme {{{
" Note that these highlight commands have to be formed with concatenation and then
" be evaluated with :execute because :highlight does not accept variables as arguments
function s:Highlight(group, term, cterm, ctermfg, ctermbg, gui, guifg, guibg, guisp, font)
    execute 'highlight clear ' . a:group
    let cmd = 'highlight '
    let cmd .= a:group
    if !empty(a:term)
        let cmd .= ' term=' . a:term
    endif
    if !empty(a:cterm)
        let cmd .= ' cterm=' . a:cterm
    endif
    if !empty(a:ctermfg)
        let cmd .= ' ctermfg=' . a:ctermfg
    endif
    if !empty(a:ctermbg)
        let cmd .= ' ctermbg='. a:ctermbg
    endif
    if !empty(a:gui)
        let cmd .= ' gui=' . a:gui
    endif
    if !empty(a:guifg)
        let cmd .= ' guifg=' . a:guifg
    endif
    if !empty(a:guibg)
        let cmd .= ' guibg='. a:guibg
    endif
    if !empty(a:guisp)
        let cmd .= ' guisp=' . a:guisp
    endif
    if !empty(a:font)
        let cmd .= ' font=' . a:font
    endif
    silent execute cmd
endfunction
function ColorschemeInit()
    " Colors inspired by flatcolor colorscheme created by Max St
    call s:Highlight('Normal', '', '', '15', '234', '', '#ECF0F1', '#1C1C1C', '', '')
    call s:Highlight('Statement', 'bold', 'bold', '197', '', 'bold', '#FF0033', '', '', '')
    call s:Highlight('Conditional', 'bold', 'bold', '197', '', 'bold', '#FF0033', '', '', '')
    call s:Highlight('Operator', '', '', '197', '', '', '#FF0033', '', '', '')
    call s:Highlight('Label', '', '', '197', '', '', '#FF0033', '', '', '')
    call s:Highlight('Repeat', 'bold', 'bold', '197', '', 'bold', '#FF0033', '', '', '')
    call s:Highlight('Type', '', '', '196', '', '', '#FF0000', '', '', '')
    call s:Highlight('StorageClass', '', '', '197', '', '', '#FF0033', '', '', '')
    call s:Highlight('Structure', '', '', '197', '', '', '#FF0033', '', '', '')
    call s:Highlight('TypeDef', 'bold', 'bold', '197', '', 'bold', '#FF0033', '', '', '')
    call s:Highlight('Exception', 'bold', 'bold', '37', '', 'bold', '#1ABC9C', '', '', '')
    call s:Highlight('Include', 'bold', 'bold', '37', '', 'bold', '#1ABC9C', '', '', '')
    call s:Highlight('PreProc', '', '', '37', '', '', '#1ABC9C', '', '', '')
    call s:Highlight('Macro', '', '', '37', '', '', '#1ABC9C', '', '', '')
    call s:Highlight('Define', '', '', '37', '', '', '#1ABC9C', '', '', '')
    call s:Highlight('Delimiter', '', '', '37', '', '', '#1ABC9C', '', '', '')
    call s:Highlight('Ignore', '', '', '37', '', '', '#1ABC9C', '', '', '')
    call s:Highlight('PreCondit', 'bold', 'bold', '37', '', 'bold', '#1ABC9C', '', '', '')
    call s:Highlight('Debug', 'bold', 'bold', '37', '', 'bold', '#1ABC9C', '', '', '')
    call s:Highlight('Function', '', '', '202', '', '', '#FF5F00', '', '', '')
    call s:Highlight('Identifier', '', '', '202', '', '', '#FF5F00', '', '', '')
    call s:Highlight('Comment', '', '', '41', '', '', '#2ECC71', '', '', '')
    call s:Highlight('CommentEmail', 'underline', 'underline', '41', '', 'underline', '#2ECC71', '', '', '')
    call s:Highlight('CommentUrl', 'underline', 'underline', '41', '', 'underline', '#2ECC71', '', '', '')
    call s:Highlight('SpecialComment', 'bold', 'bold', '41', '', 'bold', '#2ECC71', '', '', '')
    call s:Highlight('Todo', 'bold', 'bold', '41', '', 'bold', '#2ECC71', '', '', '')
    call s:Highlight('String', '', '', '220', '', '', '#FFD700', '', '', '')
    call s:Highlight('SpecialKey', 'bold', 'bold', '236', '', 'bold', '#303030', '', '', '')
    call s:Highlight('Special', 'bold', 'bold', '68', '', 'bold', '#3498DB', '', '', '')
    call s:Highlight('SpecialChar', 'bold', 'bold', '68', '', 'bold', '#3498DB', '', '', '')
    call s:Highlight('Boolean', 'bold', 'bold', '68', '', 'bold', '#3498DB', '', '', '')
    call s:Highlight('Character', 'bold', 'bold', '68', '', 'bold', '#3498DB', '', '', '')
    call s:Highlight('Number', 'bold', 'bold', '68', '', 'bold', '#3498DB', '', '', '')
    call s:Highlight('Constant', 'bold', 'bold', '68', '', 'bold', '#3498DB', '', '', '')
    call s:Highlight('Float', 'bold', 'bold', '68', '', 'bold', '#3498DB', '', '', '')
    call s:Highlight('MatchParen', 'bold', 'bold', '202', '0', 'bold', '#FF5F00', '#000000', '', '')
    call s:Highlight('NonText', '', '', '', '', '', '', '', '', '')
    call s:Highlight('Cursor', '', '', '235', '15', '', '#262626', '#FFFFFF', '', '')
    call s:Highlight('vCursor', '', '', '235', '15', '', '#262626', '#FFFFFF', '', '')
    call s:Highlight('iCursor', '', '', '235', '15', '', '#262626', '#FFFFFF', '', '')
    call s:Highlight('CursorColumn', '', '', '', '235', '', '', '#262626', '', '')
    call s:Highlight('CursorLine', '', '', '', '235', '', '', '#262626', '', '')
    call s:Highlight('SignColumn', '', '', '', '235', '', '', '#262626', '', '')
    call s:Highlight('ColorColumn', '', '', '', '235', '', '', '#262626', '', '')
    call s:Highlight('Error', 'bold', 'bold', '196', '', 'bold', '#FF0000', '', '', '')
    call s:Highlight('ErrorMsg', 'bold', 'bold', '196', '', 'bold', '#FF0000', '', '', '')
    call s:Highlight('WarningMsg', 'bold', 'bold', '220', '', 'bold', '#FFD700', '', '', '')
    call s:Highlight('Title', 'bold', 'bold', '166', '', 'bold', '#EF5939', '', '', '')
    call s:Highlight('Tag', 'bold', 'bold', '', '', 'bold', '', '', '', '')
    call s:Highlight('Visual', '', '', '', '237', '', '', '#3A3A3A', '', '')
    call s:Highlight('VisualNOS', '', '', '', '237', '', '', '#3A3A3A', '', '')
    call s:Highlight('Search', '', '', '235', '70', '', '#262626', '#5FAF00', '', '')
    call s:Highlight('IncSearch', '', '', '234', '37', '', '#1C1C1C', '#1ABC9C', '', '')
    call s:Highlight('StatusLine', 'bold', 'bold', '118', '235', 'bold', '#87FF00', '#262626', '', '')
    call s:Highlight('StatusLineNC', 'bold', 'bold', '255', '235', 'bold', '#EEEEEE', '#262626', '', '')
    call s:Highlight('LineNr', '', '', '118', '235', '', '#87FF00', '#262626', '', '')
    call s:Highlight('VertSplit', 'bold', 'bold', '43', '235', 'bold', '#00D7AF', '#262626', '', '')
    call s:Highlight('TabLine', '', '', '118', '235', '', '#87FF00', '#262626', '', '')
    call s:Highlight('TabLineFill', '', '', '', '235', '', '', '#262626', '', '')
    call s:Highlight('TabLineSel', '', '', '255', '23', '', '#EEEEEE', '#005F5F', '', '')
    call s:Highlight('CursorLineNr', 'bold', 'bold', '255', '23', 'bold', '#EEEEEE', '#005F5F', '', '')
    call s:Highlight('FoldColumn', '', '', '39', '235', '', '#00afff', '#262626', '', '')
    call s:Highlight('Folded', '', '', '39', '235', '', '#00afff', '#262626', '', '')
    call s:Highlight('SpellBad', '', 'underline,bold', '160', '', 'undercurl', '', '', '#D70000', '')
    call s:Highlight('SpellCap', '', 'underline,bold', '214', '', 'undercurl', '', '', '#FFAF00', '')
    call s:Highlight('SpellLocal', '', 'underline,bold', '51', '', 'undercurl', '', '', '#5FFFFF', '')
    call s:Highlight('SpellRare', '', 'underline,bold', '195', '', 'undercurl', '', '', '#DFFFFF', '')
    call s:Highlight('Conceal', '', '', '41', '', '', '#2ECC71', '', '', '')
    call s:Highlight('ModeMsg', 'bold', 'bold', '220', '', 'bold', '#FFD700', '', '', '')
    call s:Highlight('Pmenu', '', '', '41', '', '', '#2ECC71', '', '', '')
    call s:Highlight('PmenuSel', 'bold', 'bold', '202', '0', 'bold', '#FF5F00', '#000000', '', '')
    call s:Highlight('DiffDelete', '', '', '255', '196', '', '#EEEEEE', '#FF0000', '', '')
    call s:Highlight('DiffText', '', '', '240', '', '', '#545454', '', '', '')
    call s:Highlight('DiffChange', '', '', '236', '', '', '#343434', '', '', '')
    call s:Highlight('DiffAdd', '', '', '22', '', '', '#004225', '', '', '')
    call s:Highlight('Underlined', 'underline', 'underline', '', '', 'underline', '', '', '', '')
    call s:Highlight('Directory', '', '', '37', '', '', '#1ABC9C', '', '', '')
    call s:Highlight('Question', '', '', '37', '', '', '#1ABC9C', '', '', '')
    call s:Highlight('MoreMsg', '', '', '37', '', '', '#1ABC9C', '', '', '')
    call s:Highlight('WildMenu', 'bold', 'bold', '255', '23', 'bold', '#EEEEEE', '#005F5F', '', '')
    call s:Highlight('Orange_202', 'bold', 'bold', '202', '235', 'bold', '#FF5F00', '#262626', '', '')
    call s:Highlight('Blue_51', 'bold', 'bold', '51', '235', 'bold', '#00FFFF', '#262626', '', '')
    call s:Highlight('Blue_39', 'bold', 'bold', '39', '235', 'bold', '#00AFFF', '#262626', '', '')
    call s:Highlight('Green_41', 'bold', 'bold', '41', '235', 'bold', '#2ECC71', '#262626', '', '')
    call s:Highlight('Red_196', 'bold', 'bold', '196', '235', 'bold', '#FF0000', '#262626', '', '')
    call s:Highlight('Green_34', 'bold', 'bold', '34', '235', 'bold', '#00AF00', '#262626', '', '')
endfunction

" }}}
" Statusline {{{
" Functions for generating statusline {{{
function GitBranch()
    let output=system("git branch | grep '*' | grep -o '\\([A-Za-z0-9]\\+\\s\\?\\)\\+'")
    if output=="" || output=~?"fatal"
        return ""
    else
        return "[Git][" . output[0 : strlen(output)-2] . " " " Strip newline ^@
    endif
endfunction
function GitStatus()
    let output=system('git status')
    let retStr=""
    if output=="" || output=~?"fatal"
        return ""
    endif
    if output=~?"Changes to be committed"
        let retStr.="\u2718"
    else
        let retStr.="\u2714"
    endif
    if output=~?"modified"
        let retStr.=" \u0394"
    endif
    let retStr.="]"
    return retStr
endfunction
function GitRemote(branch) " Note: this function takes a while to execute
    let remotes=split(system("git remote")) " Get names of remotes
    if remotes==[] " End if no remotes found or error
        return ""
    else
        let remotename=remotes[0] " Get name of first remote
    endif
    let output=system("git remote show " . remotename . " | grep \"" . a:branch . "\"")
    if output=="" || output=~?"fatal" " Checkpoint for error
        return ""
    elseif output =~? "local out of date"
        return " (!)Local repo out of date: Use git pull"
    else
        return ""
    endif
endfunction
function! RefreshGitInfo()
    let g:gitBranch=GitBranch()
    let g:gitStatus=GitStatus() . GitRemote(g:gitBranch)
endfunction
call RefreshGitInfo()
" }}}
" Custom statusline {{{
set statusline=%t       "tail of the filename
set statusline+=%y      "filetype
if winwidth(0) > 85
    set statusline+=[%{strlen(&fenc)?&fenc:'none'}\|  "file encoding
    set statusline+=%{&ff}]                           "file format
endif
set statusline+=%#Orange_202#%r%##      "read only flag
set statusline+=%#Blue_51#%m\%##        "modified flag
set statusline+=%h                      "help file flag
set statusline+=\ B:%n                  "buffer number
if winwidth(0) > 100
    set statusline+=\ %#Green_34#%{gitBranch}%## "Git branch
    set statusline+=%#Green_34#%{gitStatus}%##   "Git status
endif
set statusline+=%=                                        "left/right separator
set statusline+=%#Red_196#%{SyntasticStatuslineFlag()}%## "Syntastic plugin flag
"set statusline+=%3*%F%*\ %4*\|%*\                        "file path with full names
set statusline+=%#Blue_39#%{pathshorten(expand('%:p'))}%##%#Green_41#\|%##  "file path with truncated names
set statusline+=C:%2c\                  "cursor column, reserve 2 spaces
set statusline+=R:%3l/%3L               "cursor line/total lines, reserve 3 spaces for each
set statusline+=%#Green_41#\|%##%3p     "percent through file, reserve 3 spaces
set statusline+=%%                      "percent symbol
" }}}
" Statusline color changing function {{{
function RefreshColors(statusLineColor, gui_statusLineColor)
    let l:isEnteringInsertMode = 0
    if a:statusLineColor == g:insertModeStatuslineColor_cterm
        let l:isEnteringInsertMode = 1
    endif
    call s:Highlight('Orange_202', 'bold', 'bold', '202', a:statusLineColor, 'bold', '#FF5F00', a:gui_statusLineColor, '', '')
    call s:Highlight('Blue_51', 'bold', 'bold', '51', a:statusLineColor, 'bold', '#00FFFF', a:gui_statusLineColor, '', '')
    call s:Highlight('Blue_39', 'bold', 'bold', '39', a:statusLineColor, 'bold', '#00AFFF', a:gui_statusLineColor, '', '')
    call s:Highlight('Green_41', 'bold', 'bold', '41', a:statusLineColor, 'bold', '#2ECC71', a:gui_statusLineColor, '', '')
    call s:Highlight('Red_196', 'bold', 'bold', '196', a:statusLineColor, 'bold', '#FF0000', a:gui_statusLineColor, '', '')
    call s:Highlight('Green_34', 'bold', 'bold', '34', a:statusLineColor, 'bold', '#00AF00', a:gui_statusLineColor, '', '')
    "Status line of current window
    call s:Highlight('StatusLine', 'bold', 'bold', '118', a:statusLineColor, 'bold', '#87FF00', a:gui_statusLineColor, '', '')
    "Status line color for noncurrent window
    call s:Highlight('StatusLineNC', 'bold', 'bold', '255', a:statusLineColor, 'bold', '#EEEEEE', a:gui_statusLineColor, '', '')
    "Line numbers
    call s:Highlight('LineNr', '', '', '118', a:statusLineColor, '', '#87FF00', a:gui_statusLineColor, '', '')
    "Vertical split divider
    call s:Highlight('VertSplit', 'bold', 'bold', '43', a:statusLineColor, 'bold', '#00D7AF', a:gui_statusLineColor, '', '')
    "Nonselected tabs
    call s:Highlight('TabLine', '', '', '118', a:statusLineColor, '', '#87FF00', a:gui_statusLineColor, '', '')
    "Empty space on tab bar
    call s:Highlight('TabLineFill', '', '', '', a:statusLineColor, '', '', a:gui_statusLineColor, '', '')
    "Selected tab
    if l:isEnteringInsertMode == 1
        call s:Highlight('TabLineSel', '', '', '45', a:statusLineColor, '', '#00D7FF', a:gui_statusLineColor, '', '')
    else
        call s:Highlight('TabLineSel', '', '', '255', '23', '', '#EEEEEE', '#005F5F', '', '')
    endif
    "Current line highlighting
    if l:isEnteringInsertMode == 1
        call s:Highlight('CursorLineNr', 'bold', 'bold', '45', '23', 'bold', '#00D7FF', '#005F5F', '', '')
    else
        call s:Highlight('CursorLineNr', 'bold', 'bold', '255', '23', 'bold', '#EEEEEE', '#005F5F', '', '')
    endif

    "PLUGINS HIGHLIGHTING
    "indentLine plugin
    execute 'let g:indentLine_color_term = ' . a:statusLineColor
endfunction

function ReverseColors()
    if &background == "light"
        set background=dark
    else
        set background=light
    endif
    call ToggleStatuslineColor()
endfunction
" }}}
" }}}
" {{{ Constants
let g:defaultStatuslineColor_cterm = 235
let g:defaultStatuslineColor_gui = '#073642'
let g:insertModeStatuslineColor_cterm = 23
let g:insertModeStatuslineColor_gui = '#173762'
" }}}
" Plugins configuration/constants {{{
" Add locally installed bundles to runtimepath
set runtimepath+=$HOME/.vim/bundle/conque
" NeoBundle Scripts {{{
if has('vim_starting')
    set runtimepath+=$HOME/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('$HOME/.vim/bundle'))

" Required:
" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" Add or remove your Bundles here:
NeoBundle 'ChesleyTan/wordCount.vim'
NeoBundle 'ervandew/supertab'
NeoBundle 'Yggdroot/indentLine'
NeoBundle 'xolox/vim-easytags'
NeoBundle 'xolox/vim-misc'
NeoBundle 'xolox/vim-notes'
NeoBundle 'itchyny/calendar.vim'
NeoBundle 'terryma/vim-multiple-cursors'
NeoBundle 'Raimondi/delimitMate'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'jistr/vim-nerdtree-tabs'
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundleLazy 'davidhalter/jedi-vim'
"NeoBundle 'Valloric/YouCompleteMe'
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'sjl/gundo.vim.git'
NeoBundle 'gorodinskiy/vim-coloresque'
NeoBundle 'tomasr/molokai'
NeoBundle 'altercation/vim-colors-solarized.git'

augroup neoBundleLazySource
    autocmd FileType python NeoBundleSource jedi-vim
augroup END

" You can specify revision/branch/tag.
" NeoBundle 'Shougo/vimshell', { 'rev' : '3787e5' }

" Required:
call neobundle#end()

" Required (Re-enable because neobundle disables this):
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
" }}}
let g:ConqueTerm_Color = 1
let g:ConqueTerm_TERM = 'xterm-256color'
let g:ConqueTerm_PromptRegex = '^\w\+@[0-9A-Za-z_.-]\+:[0-9A-Za-z_./\~,:-]\+\$'
let g:indentLine_char = '┆'
command Tree NERDTreeTabsToggle
nnoremap <Leader>t :Tree<CR>
let g:SuperTabDefaultCompletionType = 'context'
nnoremap <Leader>c :SyntasticCheck<CR>
"let g:ycm_register_as_syntastic_checker = 0 " Prevent YCM-Syntastic conflict
" NeoComplete Settings {{{
let g:neocomplete#enable_at_startup = 1 " Enable neocomplete
let g:neocomplete#enable_smart_case = 1 " Ignore case unless a capital letter is included
let g:neocomplete#sources#syntax#min_keyword_length = 3 " Only show completions longer than 3 chars
let g:neocomplete#enable_fuzzy_completion = 0 " Disable fuzzy completion
inoremap <expr><C-g> neocomplete#undo_completion()
inoremap <expr><C-l> neocomplete#complete_common_string()
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
    return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" Quick leader toggle for autocompletion
nnoremap <Leader>d :NeoCompleteToggle<CR>
" }}}
" Disable easytag's warning about vim's updatetime being too low
let g:easytags_updatetime_warn = 0
let g:nerdtree_tabs_open_on_gui_startup = 1
let g:nerdtree_tabs_open_on_console_startup = 1
let g:nerdtree_tabs_no_startup_for_diff = 1
let g:nerdtree_tabs_smart_startup_focus = 1
let g:nerdtree_tabs_open_on_new_tab = 1
let g:nerdtree_tabs_meaningful_tab_names = 1
let g:nerdtree_tabs_autoclose = 1
let g:nerdtree_tabs_synchronize_view = 1
let g:nerdtree_tabs_synchronize_focus = 1
let g:gundo_width = 30
let g:gundo_preview_height = 20
let g:gundo_right = 1
let g:gundo_preview_bottom = 1
command DiffTree GundoToggle
let g:notes_directories = ['~/Dropbox/Shared Notes']
nnoremap <Leader>n :Note 
let g:EclimCompletionMethod = 'omnifunc'
let g:calendar_google_calendar = 0
let g:calendar_google_task = 0
let g:calendar_cache_directory = expand('~/Dropbox/Shared Notes/calendar.vim')

" }}}
" tabline from StackOverflow {{{
set tabline+=%!MyTabLine()
function MyTabLine()
    let tabline = ''
    " Iterate through each tab page
    for tabIndex in range(tabpagenr('$'))
        " Set highlight for tab
        if tabIndex + 1 == tabpagenr()
            let tabline .= '%#TabLineSel#'
        else
            let tabline .= '%#TabLine#'
        endif
        " Set the tab page number (for mouse clicks)
        let tabline .= '%' . (tabIndex + 1) . 'T'
        let tabline .= ' '
        " Set page number string
        let tabline .= tabIndex + 1 . ' '
        " Get buffer names and statuses
        let tmp = '' " Temp string for buffer names while we loop and check buftype
        let numModified = 0 " &modified counter
        let bufsRemaining = len(tabpagebuflist(tabIndex + 1)) " Counter to avoid last ' '
        " Iterate through each buffer in the tab
        for bufIndex in tabpagebuflist(tabIndex + 1)
            " Use a variable to keep track of whether a new name was added
            let newBufNameAdded = 1
            " buffer types: quickfix gets a [Q], help gets [H]{base fname}
            " others get 1dir/2dir/3dir/fname shortened to 1/2/3/fname
            if getbufvar( bufIndex, "&buftype" ) == 'help'
                let tmp .= '[H]' . fnamemodify( bufname(bufIndex), ':t:s/.txt$//' )
            elseif getbufvar( bufIndex, "&buftype" ) == 'quickfix'
                let tmp .= '[Q]'
            else
                " Do not show NERDTree or Gundo in the bufferlist
                if bufname(bufIndex) =~# "NERD" || bufname(bufIndex) =~# "Gundo"
                    let newBufNameAdded = 0
                else
                    let tmp .= pathshorten(bufname(bufIndex))
                endif
            endif
            " Check and increment tab's &modified count
            if getbufvar( bufIndex, "&modified" )
                let numModified += 1
            endif
            " Add trailing ' ' if necessary
            if bufsRemaining > 1 && newBufNameAdded == 1
                let tmp .= ' '
            endif
            let bufsRemaining -= 1
        endfor
        " Add modified label [n+] where n pages in tab are modified
        if numModified > 0
            let tabline .= '[' . numModified . '+]'
        endif
        " Select the highlighting for the buffer names
        if tabIndex + 1 == tabpagenr()
            let tabline .= '%#TabLineSel#'
        else
            let tabline .= '%#TabLine#'
        endif
        " Add buffer names
        if tmp == ''
            let tabline .= '[New]'
        else
            let tabline .= tmp
        endif
        " Add trailing ' ' for tab
        let tabline .= ' '
    endfor
    " Remove excess whitespace
    let tabline = DeflateWhitespace(tabline)
    " After the last tab fill with TabLineFill, and reset tab page number to
    " support mouse clicks
    let tabline .= '%#TabLineFill#%T'
    " Add close button
    if tabpagenr('$') > 1
        " Right-align the label to close the current tab page
        let tabline .= '%=%#TabLineFill#%999X%#Red_196#Close%##'
    endif
    return tabline
endfunction
" }}}
" Filetype-specific settings/abbreviations {{{
augroup ft_java
    autocmd Filetype java call s:FileType_Java()
augroup END
function s:FileType_Java()
    " Use Ctrl-] to expand abbreviation
    inoreabbrev psvm public static void main(String[] args) {}<esc>i<CR><esc>ko
    inoreabbrev sysout System.out.println("");<esc>2hi
    inoreabbrev syserr System.err.println("");<esc>2hi
endfunction
augroup ft_c
    autocmd Filetype c call s:FileType_C()
augroup END
function s:FileType_C()
    inoreabbrev #<defaults> #include <stdio.h><CR>#include <stdlib.h>
endfunction
" }}}
" Pre-start function calls (non-autocommand) {{{
if has("gui_running")
    call Custom()
elseif empty($DISPLAY) "If running in a tty, use solarized theme for better colors
    call Solarized()
else
    call Custom()
endif
" }}}
" Add the virtualenv's site-packages to vim path
py << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF

"TODO async git remote
