scriptencoding utf-8
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nvim/init.vim: neovim configuration file for starting up
" Platform: Linux, OSX
" Keyboard: US
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"===== Map Leader ===============================================
"{{{1
"{{{2
set nocompatible
augroup MyAutoCmd
    autocmd!
augroup END
nn [toggle] <Nop>
nn [unite] <Nop>
nn [git] <Nop>
nn [fmt] <Nop>
no [sub] <Nop>
no [sort] <Nop>
no [align] <Nop>
"}}}2
nmap <Space>t [toggle]
nmap <Space>u [unite]
nmap <Space>g [git]
nmap <Space>f [fmt]
map s [sub]
map <Space>s [sort]
map <Space>a [align]
"}}}1

"===== Function =================================================
function! s:path_mkdir(path) abort "{{{1
    let path = expand(a:path)
    return (isdirectory(path) || mkdir(path, 'p')) ? path : ''
endfunction
"}}}1
function! s:path_exists(path) abort "{{{1
    let path = resolve(expand(a:path))
    return (filereadable(path) || isdirectory(path)) ? 1 : 0
endfunction
"}}}1

"===== Options ==================================================
function! s:load_my_options() abort "{{{1
    "----- General ----------------------------------------------
    set helplang=en
    "set lazyredraw

    "----- Windows ----------------------------------------------
    set shellslash
    set winaltkeys=no

    "----- Encoding ---------------------------------------------
    set tenc=utf-8 enc=utf-8
    set ffs=unix,dos
    set fencs=utf-8,iso-2022-jp,eucjp-ms,euc-jp,sjis,cp932

    "----- Editor -----------------------------------------------
    set autoindent smartindent
    set ts=4 tw=0 sts=4 sw=4
    set expandtab

    set nowrap
    set nobreakindent
    set nolinebreak
    "set breakat=\ \ ;:,!?
    set whichwrap=b,s,h,l,<,>,[,]
    set backspace=indent,eol,start
    set noshowmatch
    set matchtime=1
    "set matchpairs+=<:>
    "set list lcs=trail:\ ,extends:»,precedes:«,tab:▸\  " [eol:↲]
    set list lcs=trail:\ ,extends:>,precedes:<,tab:▸\  " [eol:↲]
    set nrformats=alpha,hex "nf=[octal,alpha,hex]
    set formatoptions=tcqlB

    "----- Search -----------------------------------------------
    set sc ic
    set is hls
    "set nowrapscan    " +ws

    "----- Completion -------------------------------------------
    set wildmenu
    set wildmode=full:list
    "set wildignore=
    "set infercase

    "----- Input Method -----------------------------------------
    set imdisable
    set iminsert=0
    set imsearch=0

    "----- File Management --------------------------------------
    set confirm
    set hidden
    set browsedir=buffer
    set autoread
    set autochdir
    "set autowrite
    "set updatetime=500
    set undofile
    set backup
    set noswapfile

    "----- Terminal ---------------------------------------------
    com! -nargs=? TermOpen call <SID>VsplitTermOpen(<f-args>)
    nn <silent> [unite]t :<C-u>TermOpen<CR>
    function! s:VsplitTermOpen(...) abort "{{{2
        let w = a:0 > 0 ? a:1 : 80
        let bufnums = filter(range(1, bufnr('$')), 'bufexists(v:val)')
        for i in bufnums
            if stridx(bufname(i), 'term://') == 0
                call win_gotoid(win_findbuf(i)[0])
                execute 'vertical resize ' . w
                return
            endif
        endfor
        execute w . 'vsplit | terminal'
    endfunction
    "}}}2

    "----- User Interface ---------------------------------------
    syntax enable
    set number
    set title
    set titlelen=95
    set showcmd
    set cmdheight=1
    set laststatus=2
    set stl=%n)%<%F%m%r%h%w\%=\ \ \|%{&ff}\|%{(&fenc!=''?&fenc:&enc)}\|%{&ft}\|%c.%l/%L
    set nocursorline
    set mousemodel=popup_setpos "mousem=extend
    set go-=T go+=c "guioptions=mgtTrL
    if !&wrap | set go+=b | endif
    set ambiwidth=double
    " set columns=130 lines=60
    set visualbell t_vb=

endfunction "}}}1

"===== Built-in =================================================
function! s:unload_builtin_plugins() abort "{{{1
    "" Stop to read unnecessary builtin scripts
    let g:loaded_gzip              = 1
    let g:loaded_tar               = 1
    let g:loaded_tarPlugin         = 1
    let g:loaded_zip               = 1
    let g:loaded_zipPlugin         = 1
    let g:loaded_rrhelper          = 1
    let g:loaded_2html_plugin      = 1
    let g:loaded_vimball           = 1
    let g:loaded_vimballPlugin     = 1
    let g:loaded_getscript         = 1
    let g:loaded_getscriptPlugin   = 1
    let g:loaded_netrw             = 1
    let g:loaded_netrwPlugin       = 1
    let g:loaded_netrwSettings     = 1
    let g:loaded_netrwFileHandlers = 1
    let g:loaded_logipat           = 1
    let g:loaded_spellfile_plugin  = 1
    let g:loaded_matchparen        = 1
endfunction "}}}1

"===== Plugins ==================================================
function! s:load_my_plugins(dein_repository, dein_base_dir) abort "{{{1
    if !s:path_exists(a:dein_repository)
        echohl WarningMsg | echo 'No Plugin Manger: ' . a:dein_repository | echohl None
        return
    endif

    let &runtimepath = printf('%s,%s', a:dein_repository, &runtimepath)
    if dein#load_state(a:dein_base_dir)
        call dein#begin(a:dein_base_dir)
        call dein#add('Shougo/dein.vim')

        "" APPEARANCE
        ""---------------
        "" HowTo: indentLine
        "" [n]  [toggle]i   Toggle indent line
        "" HowTo: rainbow
        "" [n]  [toggle]r   Toggle parenthesis coloring
        call dein#add('rafi/awesome-vim-colorschemes')
        call dein#add('itchyny/lightline.vim')
        call dein#add('Yggdroot/indentLine')
        call dein#add('luochen1990/rainbow')

        "" EDIT
        ""---------------
        "" HowTo: surround
        "" [n]  ys[textobj]'    Surround with ''
        "" [n]  cs'"            Change '' to ""
        "" [n]  ds'             Delete ''
        "" [v]  S'              Surround visual selection with ''
        "" HowTo: alignta
        "" [nV] [align]a =      Align at `=`
        "" [NV] [align]a : ":Alignta <<<1:1 =" (align) Align at '='
        "" [OV] [align]s : ":Alignta <- #" (shifting align) Align characters behind '#'
        call dein#add('tpope/vim-surround')
        call dein#add('h1mesuke/vim-alignta')
        call dein#add('LeafCage/yankround.vim')
        call dein#add('tpope/vim-speeddating')
        call dein#add('AndrewRadev/switch.vim')
        call dein#add('tkhren/vim-substy')

        "" TEXT OBJECT
        ""---------------
        "" HowTo: text-object
        "" ii  ai    Indent level
        "" ic  ac    Continuous character (-----------)
        "" ie  ae    Entire
        "" il  al    Line
        "" iw  aw    Word   (aaa_123_ccc aaa-123-ccc)
        "" is  as    Space
        "" iS  aS    Non-Space
        "" in  an    Number (123 -6.00 +2e10 +2.0e-10)
        "" id  ad    Digits (123,456,789)
        "" if  af    Float  (-123.987)
        "" ix  ax    Hex    (-F7B8DD)
        "" iu  au    URL    (http://example.com/abc/def?a=123&b=456)
        "" it  at    Time   (21:15:21.95)
        "" i/  a/    Path   (/usr/local/bin/vim)
        "" [n] +     Select larger region
        "" [n] -     Select narrower region
        call dein#add('kana/vim-textobj-user')
        call dein#add('kana/vim-textobj-indent')
        call dein#add('tkhren/vim-textobj-samechars')
        call dein#add('terryma/vim-expand-region')
        call dein#add('kana/vim-operator-user')

        "" SEARCH
        ""---------------
        "" HowTo: cleaver-f
        "" [n]  f[char]fffffff........
        "" HowTo: easymotion
        "" [n]  sj      Jump to labeled position
        "" [n]  sk      Jump to labeled position
        "" HowTo: open-browser
        "" [nv]  gs     Open the default browser and search on Google
        call dein#add('rhysd/clever-f.vim')
        call dein#add('haya14busa/vim-easymotion')
        call dein#add('tyru/open-browser.vim')

        "" WINDOW
        ""---------------
        "" HowTo: startify
        "" [n]   [unite]n     Open startify in the current buffer
        "" [n]   [unite]N     Open startify in the new tab
        call dein#add('mhinz/vim-startify')
        call dein#add('Shougo/denite.nvim')
        call dein#add('Shougo/defx.nvim')
        call dein#add('kristijanhusak/defx-git')
        call dein#add('mbbill/undotree')

        "" PROGRAMMING
        ""---------------
        "" HowTo: caw
        "" [nV]  ,,     Comment out and yank
        "" [nV]  ,a     Start comment section at the end of line
        "" [nV]  ,o     Start comment section at the next new line
        "" HowTo: neosnippet
        "" [i]   <TAB>           Select a candidate
        "" [i]   <C-n> / <C-p>   Select a candidate
        "" [i]   <C-m>           Confirm
        "" [i]   <CR>            Confirm
        "" HowTo: figitive
        "" [n]   [git]a          Git add [CURRENT_FILE]
        "" [n]   [git]b          Git blame
        "" [n]   [git]c          Git commit -v
        "" [n]   [git]d          Git diff
        "" [n]   [git]m          Git mv [NEW_NAME]
        "" [n]   [git]s          Git status
        "" [n]   [git]h          Git checkout HEAD^
        "" [n]   [git]v          Git checkout [REVISION]
        "" [n]   [git]p          Git push origin master
        "" [n]   [git]l          Git log
        "" HowTo: ale
        "" [n]   [fmt]f          ALE Fix
        "" [n]   [fmt]n          ALE Next
        "" [n]   [fmt]p          ALE Previous
        "" [n]   [fmt]e          ALE Enable
        "" [n]   [fmt]d          ALE Disable
        call dein#add('terryma/vim-smooth-scroll')
        call dein#add('itchyny/vim-parenmatch')
        call dein#add('tyru/caw.vim')
        call dein#add('tkhren/vim-fake')
        call dein#add('Shougo/deoplete.nvim')
        call dein#add('Shougo/neosnippet',          {'lazy': 1, 'on_i': 1})
        call dein#add('Shougo/neosnippet-snippets', {'lazy': 1, 'on_i': 1})
        call dein#add('tpope/vim-fugitive')
        call dein#add('airblade/vim-gitgutter')
        call dein#add('dense-analysis/ale', {'lazy': 1, 'on_i': 1})

        "" HTML/CSS
        ""---------------
        "" HowTo: emmet
        "" [i]   <C-z>      Expand HTML expression
        "" [i]   !<C-z>     Expand DOCTYPE declaration
        "" Refer on http://docs.emmet.io/cheat-sheet/
        let ft_html = ['html', 'html5', 'xhtml', 'htmldjango', 'xml']
        let ft_css  = ['css', 'css3', 'scss', 'sass']
        let ft_js   = ['javascript', 'json']
        let ft_csv  = ['csv', 'tsv', 'csv_semicolon', 'csv_whitespace', 'csv_pipe', 'rfc_csv', 'rfc_semicolon']
        call dein#add('mattn/emmet-vim',    {'lazy': 1, 'on_ft': ft_html})
        call dein#add('lilydjwg/colorizer', {'lazy': 1, 'on_ft': ft_css})
        " call dein#add('mechatroner/rainbow_csv', {'lazy': 1, 'on_ft': ft_csv})

        call dein#end()
        call dein#save_state()
    endif

    if dein#check_install()
        call dein#install()
    endif

    "" Plugin Specific Settings
    if dein#tap('awesome-vim-colorschemes') "{{{2
        set background=dark
        color nord
    endif
    "}}}2
    if dein#tap('indentLine') "{{{2
        let g:indentLine_faster = 0
        let g:indentLine_fileTypeExclude = ['help', 'vimfiler', '_.*']
        nmap [toggle]i :<C-u>IndentLinesToggle<CR>
    endif
    "}}}2
    if dein#tap('rainbow') "{{{2
        let g:rainbow_conf = {
       \   'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
       \   'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
       \   'operators': '_,\|+\|-\|*\|\/\|&&\|||_',
       \ }
        let g:rainbow_active = 1
        nmap [toggle]r :RainbowToggle<CR>
    endif
    "}}}2
    if dein#tap('lightline.vim') "{{{2
        let g:lightline = {
                \ 'colorscheme': 'wombat',
                \ 'mode_map': {'c': 'NORMAL'},
                \ 'active': {
                \   'left': [
                \     ['mode', 'paste'],
                \     ['fugitive', 'gitgutter', 'filename'],
                \   ],
                \ },
                \ 'component_function': {
                \   'fugitive': 'MyFugitive',
                \   'gitgutter': 'MyGitGutter',
                \ },
                \ }

        function! MyFugitive()
            try
                if exists('*fugitive#head')
                    let _ = fugitive#head()
                    return strlen(_) ? _ : ''
                endif
            catch
            endtry
            return ''
        endfunction

        function! MyGitGutter()
            if ! exists('*GitGutterGetHunkSummary')
                        \ || ! get(g:, 'gitgutter_enabled', 0)
                        \ || winwidth('.') <= 90
                return ''
            endif
            let hunks = GitGutterGetHunkSummary()
            let diff = [
                    \ '✚' . hunks[0],
                    \ '➜' . hunks[1],
                    \ '✘' . hunks[2]
                    \ ]
            return join(diff, ' ')
        endfunction
    endif
    "}}}2
    if dein#tap('yankround.vim') "{{{2
        let g:yankround_max_history = 20
        let g:yankround_dir = s:path_mkdir('$VIMDATA/yankround')
        nmap p <Plug>(yankround-p)
        nmap P <Plug>(yankround-P)
        nmap gp <Plug>(yankround-gp)
        nmap gP <Plug>(yankround-gP)
        nmap <C-p> <Plug>(yankround-prev)
        nmap <C-n> <Plug>(yankround-next)
    endif
    "}}}2
    if dein#tap('vim-alignta') "{{{2
        " set textwidth=80
        nn [align]a :<C-u>Alignta <<<1:1<Space>
        vn [align]a :Alignta <<<1:1<Space>
        nn [align]s :<C-u>Alignta <-<Space>
        vn [align]s :Alignta <-<Space>
    endif
    "}}}2
    if dein#tap('switch.vim') "{{{2
        let g:switch_mapping = '<C-s>'
        let g:switch_custom_definitions = [
            \   {'\Ctrue': 'false', '\Cfalse': 'true'},
            \   {'\CTrue': 'False', '\CFalse': 'True'},
            \   {'\CTRUE': 'FALSE', '\CFALSE': 'TRUE'},
            \   {'\Cyes': 'no', '\Cno': 'yes'},
            \   {'\CYes': 'No', '\CNo': 'Yes'},
            \   {'\CYES': 'NO', '\CNO': 'YES'},
            \   {'\Cand': 'or', '\Cor': 'and'},
            \   {'\CAnd': 'Or', '\COr': 'And'},
            \   {'\CAND': 'OR', '\COR': 'AND'},
            \   {'on': 'off', 'off': 'on'},
            \   {'On': 'Off', 'Off': 'On'},
            \   {'ON': 'OFF', 'OFF': 'ON'},
            \   ['public', 'private', 'protected'],
            \   ['OK', 'NG'],
            \   ['&&', '||'],
            \   ['friday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'],
            \   ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
            \   ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY'],
            \   ['junuary', 'february', 'march', 'april', 'may', 'june', 'july', 'august', 'september', 'october', 'novenber', 'december'],
            \   ['Junuary', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'Novenber', 'December'],
            \   ['JUNUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE', 'JULY', 'AUGUST', 'SEPTEMBER', 'OCTOBER', 'NOVENBER', 'DECEMBER'],
            \ ]
    endif
    "}}}2
    if dein#tap('vim-substy') "{{{2
        let g:substy#template_force_offset = ''
        nmap <expr> [sub]s substy#template('', '')
        vmap <expr> [sub]s substy#template('', '')
        nmap <expr> [sub]/ substy#template(@/, '')
        vmap <expr> [sub]/ substy#template(@/, '')
        nmap <expr> [sub]? substy#template(@/, @/)
        vmap <expr> [sub]? substy#template(@/, @/)
        nmap <expr> [sub]y substy#yank()
        vmap <expr> [sub]y substy#yank()
        nmap <expr> [sub]U substy#yank({i,v -> toupper(v)})
        vmap <expr> [sub]U substy#yank({i,v -> toupper(v)})
        nmap <expr> [sub]u substy#yank({i,v -> tolower(v)})
        vmap <expr> [sub]U substy#yank({i,v -> toupper(v)})
        nmap <expr> [sub] substy#template_operator()
        for c in split('abcdefghijklmnopqrstuvwxyz0123456789*+.%/"', '\zs')
            let mapcmd = '%s <expr> [sub]"%s substy#template(escape(@%s, "\\.*^$[~/"), "")'
            exec printf(mapcmd, 'nmap', c, c)
            exec printf(mapcmd, 'vmap', c, c)
        endfor
    endif
    "}}}2
    if dein#tap('vim-textobj-user') "{{{2
        call textobj#user#plugin('any', {
           \     'entire': {
           \         'select': ['ie', 'ae'],
           \         'pattern': '\_.*',
           \     },
           \     'line_a': {
           \         'select': ['al'],
           \         'pattern': '^.*$',
           \     },
           \     'line_i': {
           \         'select': ['il'],
           \         'pattern': '^\s*\zs.*\ze\s*$',
           \     },
           \     'keyword_a': {
           \         'select': ['aw'],
           \         'pattern': '[0-9A-Za-z_-]\+',
           \     },
           \     'keyword_i': {
           \         'select': ['iw'],
           \         'pattern': '[0-9A-Za-z]\+',
           \     },
           \     'space': {
           \         'select': ['is', 'as'],
           \         'pattern': '\s\+',
           \     },
           \     'not_space': {
           \         'select': ['iS', 'aS'],
           \         'pattern': '\S\+',
           \     },
           \     'numeral_a': {
           \         'select': ['an'],
           \         'pattern': '[-+]\?\d\+\%(\.\d\+\)\?\%([eE][-+]\?\d\+\)\?',
           \     },
           \     'numeral_i': {
           \         'select': ['in'],
           \         'pattern': '\d\+',
           \     },
           \     'digit_a': {
           \         'select': ['ad'],
           \         'pattern': '[-+]\?\d\+',
           \     },
           \     'digit_i': {
           \         'select': ['id'],
           \         'pattern': '\d\+',
           \     },
           \     'float_a': {
           \         'select': ['af'],
           \         'pattern': '[-+]\?\d\+\%(\.\d\+\)\?',
           \     },
           \     'float_i': {
           \         'select': ['if'],
           \         'pattern': '\d\+\%(\.\d\+\)\?',
           \     },
           \     'hex_a': {
           \         'select': ['ax'],
           \         'pattern': '[-+]\<\%(0x\|#\)\?\x\+\>',
           \     },
           \     'hex_i': {
           \         'select': ['ix'],
           \         'pattern': '\x\+\>',
           \     },
           \     'url': {
           \         'select': ['iu', 'au'],
           \         'pattern': '\(http\|https\|ftp\)://[a-zA-Z0-9][a-zA-Z0-9_-]*'
           \                  . '\(\.[a-zA-Z0-9][a-zA-Z0-9_-]*\)*\(:\d\+\)\?'
           \                  . '\(/[a-zA-Z0-9_/.\-+%?&=;@$,!''*~]*\)\?'
           \                  . '\(#[a-zA-Z0-9_/.\-+%#?&=;@$,!''*~]*\)\?',
           \     },
           \     'time': {
           \         'select': ['it', 'at'],
           \         'pattern': '\%('
           \                  . '\%(\d\d:\d\d\%(:\d\d\%(\.\d\+\)\?\)\?\)\|'
           \                  . '\%(\d\d\d\d\%(-\d\d\%(-\d\d\)\?\)\?\)\|'
           \                  . '\%(\%(:\d\d\%(\.\d\+\)\?\)\zs\%(Z\|[+-]\d\d:\d\d\)\)\|'
           \                  . '\)',
           \     },
           \     'path': {
           \         'select': ['i/', 'a/'],
           \         'pattern': '\(\/\([0-9a-zA-Z_\-\.]\+\)\)\+',
           \     },
           \ } )
    endif
    "}}}2
     if dein#tap('vim-expand-region') "{{{2
         let g:expand_region_text_objects = {
        \   'iw' : 0,
        \   'iW' : 0,
        \   "i'" : 1,
        \   'i"' : 1,
        \   'i)' : 1,
        \   'i}' : 1,
        \   'it' : 1,
        \   'at' : 1,
        \   'il' : 1,
        \   'ip' : 0,
        \   'ii' : 1,
        \ }

         map + <Plug>(expand_region_expand)
         map - <Plug>(expand_region_shrink)
     endif
     "}}}2
    if dein#tap('vim-operator-user') "{{{2
    endif
    "}}}2
    if dein#tap('clever-f.vim') "{{{2
        let g:clever_f_smart_case = 1
    endif
    "}}}2
    if dein#tap('vim-easymotion') "{{{2
        let g:EasyMotion_do_mapping = 0
        "let g:EasyMotion_leader_key = "'"
        let g:EasyMotion_smartcase = 1
        let g:EasyMotion_grouping = 1
        let g:EasyMotion_keys = 'jkhlnmzxcvbgtrewqyuipofdas'
        let g:EasyMotion_startofline = 0

        hi link EasyMotionTarget2First Statement
        hi link EasyMotionTarget2Second Boolean

        map sj <Plug>(easymotion-bd-jk)
        map sk <Plug>(easymotion-bd-jk)
    endif
    "}}}2
    if dein#tap('open-browser.vim') "{{{2
        let g:netrw_nogx = 1 " disable netrw's gx mapping.
        nmap gs <Plug>(openbrowser-smart-search)
        vmap gs <Plug>(openbrowser-smart-search)
    endif
    "}}}2
    if dein#tap('undotree') "{{{2
        let g:undotree_SetFocusWhenToggle = 0
        let g:undotree_WindowLayout = 4
        nn [toggle]u :<C-u>UndotreeToggle<CR>
    endif
    "}}}2
    if dein#tap('vim-startify') "{{{2
        let g:startify_list_order = ['bookmarks', 'files', 'sessions']
        let g:startify_bookmarks = [expand('$MYVIMRC'), expand('$HOME/.zshrc')]
        let g:startify_relative_path = 1
        let g:startify_change_to_dir = 1
        let g:startify_files_number = 10
        let g:startify_session_dir = s:path_mkdir('$VIMDATA/session')
        nmap [unite]n :<C-u>Startify<CR>
        nmap [unite]N :<C-u>tabnew<CR>:<C-u>Startify<CR>
        autocmd MyAutoCmd FileType startify :setl cursorline
    endif
    "}}}2
    if dein#tap('denite.nvim') "{{{2
        nn <silent> [unite]u :<C-u>Denite<Space>
        nn <silent> [unite]s :<C-u>Denite source<CR>
        nn <silent> [unite]b :<C-u>Denite buffer<CR>
        nn <silent> [unite]x :<C-u>Denite menu:misc_commands<CR>
        nn <silent> [unite]" :<C-u>Denite register<CR>
        nn <silent> [unite]m :<C-u>Denite mark<CR>
        nn <silent> [unite]d :<C-u>Denite dein<CR>
        nn <silent> [unite]o :<C-u>Denite output<CR>
        nn <silent> [unite]f :<C-u>Denite file/rec<CR>
        nn <silent> [unite]c :<C-u>Denite colorscheme<CR>

        let l:menus = {}
        let l:menus.misc_commands = {
            \ 'description': 'Misc commands',
            \ 'command_candidates': [
            \   ['[toggle] Paste mode (setl paste!)', 'setl paste! paste?'],
            \   ['[toggle] Ignore case (setl ignorecase!)', 'setl ic! ic?'],
            \   ['[toggle] Wrap lines (setl wrap!)', 'setl wrap! wrap?'],
            \   ['[toggle] Expand tab (setl expandtab!)', 'setl et! et?'],
            \   ['[toggle] Invisible characters (setl list!)', 'setl list! list?'],
            \   ['[toggle] Line numbers (setl number!)', 'setl number! number?'],
            \   ['[toggle] Spell check (setl spell!)', 'setl spell! spell?'],
            \   ['[toggle] Background (light/dark)', 'let &bg=((&bg=="dark")?"light":"dark")'],
            \   ['[toggle] Rainbow parentheses', 'RainbowToggle'],
            \   ['[command] Delete End-of-Line WhiteSpaces', ':%s/\s\+$//'],
            \   ['[command] Delete End-of-Line ^M', ':%s/\r//g'],
            \   ['[command] Delete Blank Lines', ':v/\S/d'],
            \   ['[command] Delete Duplicate Lines (Unique)', ':%sort u'],
            \   ['[command] Delete XML Tags', ':%s#<[^>]\+>##g'],
            \   ['[command] Duplicate Lines', ':g/^/t.'],
            \   ['[command] Reverse Lines', ':g/^/m0'],
            \   ['[command] Sort Lines', ':%sort'],
            \   ['[command] Sort Lines By Length', ':%s/.*/\=printf("%04d",len(submatch(0)))."|".submatch(0)/ |sor n|%s/^\d\+|/'],
            \   ['[command] Shuffle Lines', ':%s/^/\=reltimestr(reltime())[-2:]."\t"/|sort n|%s/^\S*\t//'],
            \   ['[command] Format xml', ':%s/></>\r</g | filetype indent on | setf xml | normal gg=g'],
            \ ],
            \ }
        call denite#custom#var('menu', 'menus', l:menus)

        augroup denite_filter
          autocmd MyAutoCmd FileType denite call s:denite_my_settings()
          function! s:denite_my_settings() abort
            nn <silent><buffer><expr> <CR> denite#do_map('do_action')
            nn <silent><buffer><expr> d denite#do_map('do_action', 'delete')
            nn <silent><buffer><expr> p denite#do_map('do_action', 'preview')
            nn <silent><buffer><expr> q denite#do_map('quit')
            nn <silent><buffer><expr> i denite#do_map('open_filter_buffer')
            nn <silent><buffer><expr> <Space> denite#do_map('toggle_select').'j'
          endfunction
        augroup END
    endif
    "}}}2
    if dein#tap('defx.nvim') "{{{2
        nn <silent> [unite]e :<C-u>Defx -toggle -listed -resume
                    \ -split=vertical -winwidth=30 -direction=topleft
                    \ -show-ignored-files
                    \ -columns=indent:git:mark:filename:type<CR>
        " nn <silent> [unite]e :<C-u>Defx -split=horizontal -toggle
        "           \ -show-ignored-files -columns=git:mark:filename:type<CR>

        autocmd FileType defx call s:defx_my_settings()
        function! s:defx_my_settings() abort
          " Define mappings
          nn <silent><buffer><expr> <CR> defx#do_action('drop')
          nn <silent><buffer><expr> c defx#do_action('copy')
          nn <silent><buffer><expr> m defx#do_action('move')
          nn <silent><buffer><expr> p defx#do_action('paste')
          " nn <silent><buffer><expr> e defx#do_action('drop')
          " nn <silent><buffer><expr> l defx#do_action('open')
          " nn <silent><buffer><expr> E defx#do_action('open', 'vsplit')
          " nn <silent><buffer><expr> P defx#do_action('open', 'pedit')
          nn <silent><buffer><expr> l defx#do_action('open_or_close_tree')
          nn <silent><buffer><expr> K defx#do_action('new_directory')
          nn <silent><buffer><expr> N defx#do_action('new_file')
          " nn <silent><buffer><expr> M defx#do_action('new_multiple_files')
          nn <silent><buffer><expr> C defx#do_action('toggle_columns', 'mark:indent:icon:filename:type:size:time')
          nn <silent><buffer><expr> S defx#do_action('toggle_sort', 'time')
          nn <silent><buffer><expr> d defx#do_action('remove')
          nn <silent><buffer><expr> r defx#do_action('rename')
          nn <silent><buffer><expr> !  defx#do_action('execute_command')
          " nn <silent><buffer><expr> x defx#do_action('execute_system')
          nn <silent><buffer><expr> yy defx#do_action('yank_path')
          nn <silent><buffer><expr> .  defx#do_action('toggle_ignored_files')
          nn <silent><buffer><expr> ; defx#do_action('repeat')
          nn <silent><buffer><expr> h defx#do_action('cd', ['..'])
          nn <silent><buffer><expr> ~ defx#do_action('cd')
          nn <silent><buffer><expr> q defx#do_action('quit')
          nn <silent><buffer><expr> <Space> defx#do_action('toggle_select') . 'j'
          nn <silent><buffer><expr> * defx#do_action('toggle_select_all')
          nn <silent><buffer><expr> j line('.') == line('$') ? 'gg' : 'j'
          nn <silent><buffer><expr> k line('.') == 1 ? 'G' : 'k'
          nn <silent><buffer><expr> <C-l> defx#do_action('redraw')
          " nn <silent><buffer><expr> <C-g> defx#do_action('print')
          " nn <silent><buffer><expr> cd defx#do_action('change_vim_cwd')
        endfunction
    endif
    "}}}2
    if dein#tap('defx-git') "{{{2
        let g:defx_git#indicators = {
        \ 'Modified'  : 'M',
        \ 'Staged'    : '●',
        \ 'Untracked' : '?',
        \ 'Renamed'   : '➜',
        \ 'Unmerged'  : '═',
        \ 'Deleted'   : 'x',
        \ 'Unknown'   : '?'
        \ }
    endif
    "}}}2
    if dein#tap('vim-smooth-scroll') "{{{2
        " distance, duration, speed
        nn <silent><C-u> :call smooth_scroll#up(&scroll, 0, 8)<CR>
        nn <silent><C-d> :call smooth_scroll#down(&scroll, 0, 8)<CR>
        nn <silent><C-b> :call smooth_scroll#up(&scroll*2, 0, 8)<CR>
        nn <silent><C-f> :call smooth_scroll#down(&scroll*2, 0, 8)<CR>
    endif
    "}}}2
    if dein#tap('vim-parenmatch') "{{{2
        hi! default link ParenMatch MatchParen
    endif
    "}}}2
    if dein#tap('caw.vim') "{{{2
        let g:caw_dollarpos_sp_left = '   '
        nmap ,, yy<Plug>(caw:hatpos:toggle)
        vmap ,, ygv<Plug>(caw:hatpos:toggle)
        nmap ,a <Plug>(caw:dollarpos:toggle)
        vmap ,a <Plug>(caw:dollarpos:toggle)
        nmap ,o <Plug>(caw:jump:comment-next)
        nmap ,O <Plug>(caw:jump:comment-prev)
    endif
    "}}}2
    if dein#tap('vim-fake') "{{{2
        let g:fake_bootstrap = 1
        let g:fake_src_paths = [$VIMCONFIG . '/fakesrc']
    endif
    "}}}2
    if dein#tap('deoplete.vim') "{{{2
        let g:deoplete#enable_at_startup = 1
    endif
    "}}}2
    if dein#tap('neosnippet') "{{{2
        imap <expr> <C-m> neosnippet#expandable_or_jumpable()
                         \ ? "\<Plug>(neosnippet_expand_or_jump)"
                         \ : "\<C-m>"
        smap <expr> <C-m> neosnippet#expandable_or_jumpable() ?
                         \ "\<Plug>(neosnippet_expand_or_jump)"
                         \ : "\<C-m>"
        imap <expr> <CR>  (neosnippet#expandable()
                         \ <bar><bar> neosnippet#jumpable())
                         \ ? "\<Plug>(neosnippet_expand_or_jump)"
                         \ : "\<CR>"
        imap <expr> <TAB> neosnippet#jumpable()
                         \ ? "\<Plug>(neosnippet_expand_or_jump)"
                         \ : pumvisible() ? "\<C-n>" : "\<TAB>"
        smap <expr> <TAB> neosnippet#jumpable()
                         \ ? "\<Plug>(neosnippet_expand_or_jump)"
                         \ : "\<TAB>"
        if has('conceal')
            set conceallevel=2 concealcursor=i
        endif
    endif
    "}}}2
    if dein#tap('vim-fugitive') "{{{2
        nn <silent> [git]d :<C-u>Gdiff<CR>
        nn <silent> [git]s :<C-u>Gstatus<CR>
        nn <silent> [git]a :<C-u>Gwrite<CR>
        nn <silent> [git]b :<C-u>Gblame<CR>
        nn <silent> [git]c :<C-u>Gcommit -v<CR>
        nn <silent> [git]m :<C-u>Gmove<Space>
        nn <silent> [git]v :<C-u>Gread<Space>
        nn <silent> [git]h :<C-u>Gread HEAD^<CR>
        nn <silent> [git]p :<C-u>Gpush origin master<CR>
        nn <silent> [git]l :<C-u>Glog<CR>
    endif
    "}}}2
    if dein#tap('ale') "{{{2
        let g:ale_fmts = {
            \ 'python': ['flake8'],
            \ 'javascript': ['eslint'],
            \ }
        let g:ale_fixers = {
            \ '*': ['trim_whitespace', 'remove_trailing_lines'],
            \ 'python': ['autopep8', 'black', 'isort'],
            \ 'javascript': ['prettier-eslint'],
            \ }

        let g:ale_python_flake8_executable = g:python3_host_prog
        let g:ale_python_flake8_options = '-m flake8'
        let g:ale_python_autopep8_executable = g:python3_host_prog
        let g:ale_python_autopep8_options = '-m autopep8'
        let g:ale_python_isort_executable = g:python3_host_prog
        let g:ale_python_isort_options = '-m isort'
        let g:ale_python_black_executable = g:python3_host_prog
        let g:ale_python_black_options = '-m black'

        nmap [fmt]f <Plug>(ale_fix)
        nmap [fmt]n <Plug>(ale_next_wrap)
        nmap [fmt]p <Plug>(ale_previous_wrap)
        nmap [fmt]e <Plug>(ale_enable)
        nmap [fmt]d <Plug>(ale_disable)
        let g:ale_fix_on_save = 1
    endif
    "}}}2
    if dein#tap('emmet-vim') "{{{2
        let g:user_emmet_leader_key = 'gy'
        imap <C-z> gy,
    endif
    "}}}2

    filetype plugin indent on
endfunction "}}}1

"===== Commands =================================================
function! s:load_my_commands() abort "{{{1
    "" :H [expr]        : Open the first help page in the next tab
    "" :Hgrep [expr]    : Open multiple help pages in the next tab
    "" :FT [filetype]   : File Type (python, ruby, cpp, ...)
    "" :FF [fileformat] : File Format (mac, unix, dos)
    "" :FE [fileenc]    : File Encoding (utf-8, sjis, ...)
    "" :EditVimrc       : Eidt vimrc or init.vim
    "" :ReloadVimrc     : Reload vimrc or init.vim
    "" :ClearMessages   : Clear messages cache
    "" Remember position before buffer closing
    "{{{2
    com! -nargs=1 -complete=help H tab help <args>
    com! -nargs=+ -complete=help Hgrep call <SID>TabHelpGrep(<q-args>)
    com! -nargs=1 FT setl ft=<args>
    com! -nargs=1 FF setl ff=<args>
    com! -nargs=1 FE setl fenc=<args>
    com! EditVimrc :e $MYVIMRC
    com! EditVimrcInTab :tabedit $MYVIMRC
    com! ReloadVimrc :so $MYVIMRC
    com! ClearMessages for n in range(200) | echom '' | endfor
    autocmd MyAutoCmd FileType help,qf nnoremap <buffer> q <C-w>c
    function! s:TabHelpGrep(keywords) abort
        exec 'tab helpgrep ' . a:keywords
        exec 'copen'
    endfunction
    autocmd MyAutoCmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line('$') |
        \ execute "normal! g'\"" | endif
    "}}}2
endfunction "}}}1

"===== Key Mappings =============================================
function! s:load_my_keymaps() abort "{{{1

"----- NORMAL MODE ----------------------------------------------
    "" Window/Tab Settings
    "" [n] <Space>n     : To next tab
    "" [n] <Space>p     : To previous tab
    "" [n] <Space>j     : To J↓ buffer
    "" [n] <Space>k     : To K↑ buffer
    "" [n] <Space>h     : To H← buffer
    "" [n] <Space>l     : To L→ buffer
    "{{{2
    nn <silent> <Space>n :<C-u>tabnext<CR>
    nn <silent> <Space>p :<C-u>tabprevious<CR>
    nn <silent> <Space>j <C-w>j
    nn <silent> <Space>k <C-w>k
    nn <silent> <Space>h <C-w>h
    nn <silent> <Space>l <C-w>l
    "}}}2

    "" General Settings
    "" [n]  Not distinguish ; and :
    "" [n]  Adjust the cursor after jumping of n,N,*,#
    "" [n]  Remember cursor position before big jump like gg,G
    "" [n]  Ignore line wraping when up and down key pressed ('↓' = gj, '↑' = gk)
    "" [n]  <C-k>      : Delete right part of cursor
    "" [n]  <C-l>      : Cancel matching highlight
    "" [n]  <C-q>      : Close the current buffer
    "" [n]  <C-e>      : Jump the next window. Equivalent to <C-w><C-w>
    "" [n]  <C-w><C-t> : Jump the next tab
    "{{{2
    nn ; :
    vn ; :
    nn n nzzzv
    nn N Nzzzv
    nn * *zzzv
    nn # #zzzv
    nn g* g*zzzv
    nn g# g#zzzv
    function! s:keep_column(key) abort
        let col = getpos('.')[2] - 1
        return a:key .'0'. (col ? col : '') .'l'
    endfunction
    nn <expr> gg <SID>keep_column('gg')
    nn <expr> G  <SID>keep_column('G')
    nn <Down> gj
    nn <Up> gk
    nn <C-k> D
    nn <silent> <C-l> :<C-u>noh<CR>
    nn <C-q> <C-w><C-c>
    nn <C-e> <C-w><C-w>
    nn <silent> <C-w><C-t> :<C-u>tabedit<CR>
    "" Typo防止
    nn Q <Nop>
    nn ZZ <Nop>
    nn ZQ <Nop>
    nn gt <Nop>
    nn gT <Nop>
    "}}}2

    "" Toggle Settings ([unite]t)
    "" [n]  [toggle]s : Toggle spell check
    "" [n]  [toggle]e : Toggle expandtab
    "" [n]  [toggle]l : Toggle unvisible characters
    "" [n]  [toggle]w : Toggle line wrap
    "" [n]  [toggle]p : Toggle Paste mode
    "" [n]  [toggle]n : Toggle line number
    "" [n]  [toggle]c : Toggle ignore case option
    "" [n]  [toggle]b : Toggle light/dark of colorscheme
    "{{{2
    nn <silent> [toggle]s :setl spell!<CR>:setl spell?<CR>
    nn <silent> [toggle]e :setl expandtab!<CR>:setl expandtab?<CR>
    nn <silent> [toggle]l :setl list!<CR>:setl list?<CR>
    nn <silent> [toggle]w :setl wrap!<CR>:setl wrap?<CR>
    nn <silent> [toggle]p :setl paste!<CR>:setl paste?<CR>
    nn <silent> [toggle]n :setl number!<CR>:setl number?<CR>
    nn <silent> [toggle]c :setl ignorecase!<CR>:setl ignorecase?<CR>
    nn <silent> [toggle]b :set bg=<C-r>=((&bg=='dark')?'light':'dark')<CR><CR>
    "}}}2

"----- INSERT MODE ----------------------------------------------
    "" [i]  <C-y>   : Copy the above character
    "" [i]  <C-v>   : Copy the below character
    "" [i]  <C-a>   : Back to start of line (0)
    "" [i]  <C-e>   : Jump to end of line ($)
    "" [i]  <C-f>   : Forward to head of the next word (w)
    "" [i]  <C-b>   : Back to head of the previous word (b)
    "" [i]  <C-u>   : Delete left part of cursor
    "" [i]  <C-k>   : Delete right part of cursor
    "" [i]  <C-j>   : ESC
    "" [i]  jj      : ESC
    "" [i]  <C-d>   : Jump to the next )]}>
    "" [i]  <C-s>   : Jump to the next ([{<
    "{{{2
    ino <C-v> <C-e>
    ino <C-a> <C-o>0
    ino <C-e> <C-o>$
    ino <C-f> <C-o>w
    ino <C-b> <C-o>b
    ino <C-k> <C-o>D
    ino <silent> jj <ESC>
    ino <silent> <C-j> <ESC>
    ino <C-d> <C-r>=cursor(searchpos('[)}>\]]', 'cew'))?'\\<Right>':''<CR><Right>
    ino <C-s> <Left><C-r>=cursor(searchpos('[)}>\]]', 'bw'))?'':''<CR><Right>
    "}}}2

"----- COMMANDLINE MODE -----------------------------------------
    "" [c]  <C-a>   : Back to start of line (0)
    "" [c]  <C-e>   : Jump to end of line ($)
    "" [c]  <C-u>   : Delete left part of cursor
    "" [c]  <C-k>   : Delete right part of cursor
    "" [c]  <C-l>   : Clear line
    "" [i]  <C-f>   : Forward to the next word (w)
    "" [i]  <C-b>   : Back to the previous word (b)
    "" [i]  <C-d>   : Jump to the next /
    "{{{2
    cno <C-a> <C-b>
    cno <C-y> <C-r>"
    cno <C-f> <S-Right>
    cno <C-b> <S-Left>
    cno <C-k> <C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2]<CR>
    cno <C-l> <C-e><C-u>
    cno <C-d> <C-r>=setcmdpos(match(getcmdline(), '\\\@<!/', getcmdpos()-1)+2)<CR><BS>
    "}}}2

"----- TERMINAL MODE --------------------------------------------
    "" [t] <C-[>    : Move to Terminal-normal mode
    "{{{2
    tno <C-[> <C-\><C-n>
    "}}}2
"----- GLOBAL ---------------------------------------------------
    "" Substitution
    "" & : Substitute again with the last expression
    "" g&: Global substitution again with the last expression
    "" guu or Vu: To lowercase
    "" gUU or VU: To uppercase
    "" gtt or Vt: To titlecase
    "" g~~: To swapcase
    "{{{2
    vn <silent> t :s/\<\(.\)\(\k*\)\>/\u\1\l\2/g<cr>:noh<cr>
    nn <silent> gtt :s/.*/\l&/<bar>:s/\<./\u&/g<cr>:noh<cr>
    "}}}2

    """ Cycle Word Shape
    "" [n]  <C-h>   : lower_snake -> UPPER_SNAKE -> TitleCase
    function! s:decompose_word(text) "{{{2
        if match(a:text, '^\C[a-z0-9_]\+$') > -1
            return ['lower,_', split(a:text, '_')]
        elseif match(a:text, '^\C[A-Z0-9_]\+$') > -1
            return ['upper,_', split(a:text, '_')]
        elseif match(a:text, '^\C\([A-Z0-9][a-z0-9]*\)\+$') > -1
            return ['title,', split(a:text, '\(\l\+\zs\)\|\([0-9]\+\zs\)')]
        elseif match(a:text, '^\C\([A-Z0-9][a-z0-9_]*\)\+$') > -1
            return ['title,_', split(a:text, '_')]
        elseif match(a:text, '^\C[a-z0-9]\+\([A-Z0-9][a-z0-9]*\)\+$') > -1
            return ['camel,', split(a:text, '\(\l\+\zs\)\|\([0-9]\+\zs\)')]
        endif
        return ['unknown,', [a:text]]
    endfunction

    function! s:case_wise_join(word_parts, case_style, joint_char)
        call map(a:word_parts, {_, val -> tolower(val)})
        if a:case_style == 'title'
            call map(a:word_parts, {_, val -> substitute(val, '^\l', '\U\0', '')})
        elseif a:case_style == 'camel'
            call map(a:word_parts, {idx, val -> (idx > 0) ? substitute(val, '^\l', '\U\0', ''): val})
        elseif a:case_style == 'upper'
            call map(a:word_parts, {_, val -> toupper(val)})
        endif
        return join(a:word_parts, a:joint_char)
    endfunction

    function! CycleWordShape(word) abort
        let info = s:decompose_word(a:word)
        let cycle = ['lower,_','upper,_', 'title,']
        let i = index(cycle, info[0])
        if i > -1
            let next_i = (i < len(cycle) - 1) ? (i + 1) : 0
            let next_style = split(cycle[next_i], ',', 1)
            return s:case_wise_join(info[1], next_style[0], next_style[1])
        endif
        return a:word
    endfunction

    nmap <silent><C-h> "-caw<C-r>=CycleWordShape(@-)<CR><ESC>
    "}}}2

    """ Sort ([sort] <Space>s)
    "" [nV] [sort]s  : Sort (sort)
    "" [nV] [sort]r  : Reverse (sort reverse)
    "" [nV] [sort]u  : Sort and remove duplicated (sort unique, ASC)
    "" [nV] [sort]a  : Sort by ascending (sort, ASC)
    "" [nV] [sort]d  : Sort by descending (sort, DESC)
    "{{{2
    nn <silent> [sort]s :<C-u>%sort i<CR>
    vn <silent> [sort]s :sort i<CR>
    nn <silent> [sort]u :<C-u>%sort u<CR>
    vn <silent> [sort]u :sort u<CR>
    nn <silent> [sort]r :<C-u>%sort! i<CR>
    vn <silent> [sort]r :sort! i<CR>
    nn [sort]a :<C-u>%sort i //<Left><C-r>/
    vn [sort]a :sort i //<Left><C-r>/
    nn [sort]d :<C-u>%sort! i //<Left><C-r>/
    vn [sort]d :sort! i //<Left><C-r>/
    "}}}2

endfunction "}}}1

"===== Setup ====================================================
let $VIMCONFIG = stdpath('config')
let $VIMDATA   = stdpath('data')
if !s:path_exists('$NVIM_PYENV_ROOT')
    " let $NVIM_PYENV_ROOT = substitute(system('cd $VIMCONFIG && pipenv --venv'), '\n', '', 'g')
    let $NVIM_PYENV_ROOT = expand("$HOME/.local/share/virtualenvs/dotvim-B1L6jKPx")
endif
let g:python3_host_prog = expand('$NVIM_PYENV_ROOT') . '/bin/python3'

let &undodir   = s:path_mkdir('$VIMDATA/undo')
let &backupdir = s:path_mkdir('$VIMDATA/backup')
let &directory = s:path_mkdir('$VIMDATA/swap')
let &viewdir   = s:path_mkdir('$VIMDATA/view')

call s:unload_builtin_plugins()
call s:load_my_options()
call s:load_my_plugins(
    \ expand('$VIMCONFIG/dein/repos/github.com/Shougo/dein.vim'),
    \ expand('$VIMCONFIG/dein')
    \ )
call s:load_my_commands()
call s:load_my_keymaps()

" vim: set fdm=marker fenc=utf-8 ff=unix ft=vim :
