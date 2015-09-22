if &cp || exists("g:loaded_vim_xmode")
   finish
  endif
  let g:loaded_vim_xmode = 1
  let s:savecpo            = &cpo
  set cpo&vim
  "
" Whole lines                                | i_CTRL-X_CTRL-L |
" keywords in the current file               | i_CTRL-X_CTRL-N |
" keywords in 'dictionary'                   | i_CTRL-X_CTRL-K |
" keywords in 'thesaurus', thesaurus-style   | i_CTRL-X_CTRL-T |
" keywords in the current and included files | i_CTRL-X_CTRL-I |
" tags                                       | i_CTRL-X_CTRL-] |
" file names                                 | i_CTRL-X_CTRL-F |
" definitions or macros                      | i_CTRL-X_CTRL-D |
" Vim command-line                           | i_CTRL-X_CTRL-V |
" User defined completion                    | i_CTRL-X_CTRL-U |
" omni completion                            | i_CTRL-X_CTRL-O |
" Spelling suggestions                       | i_CTRL-X_s      |
" keywords in 'complete'                     | i_CTRL-N        |

let s:xdictionary =
            \ [
            \   [ "n" , "next"         , "\<C-N>" ] ,
            \   [ "p" , "prev"         , "\<C-P>" ] ,
            \   [ "l" , "line"         , "\<C-L>" ] ,
            \   [ "k" , "dictionary"   , "\<C-K>" ] ,
            \   [ "t" , "thesaurus"    , "\<C-T>"]  ,
            \   [ "i" , "include"      , "\<C-I>" ] ,
            \   [ "]" , "tags"         , "\<C-]>" ] ,
            \   [ "d" , "definitions"  , "\<C-D>" ] ,
            \   [ "f" , "filename"     , "\<C-f>" ] ,
            \   [ "v" , "commandline"  , "\<C-V>" ] ,
            \   [ "u" , "userdefined"  , "\<C-U>" ] ,
            \   [ "o" , "omnicomplete" , "\<C-O>" ] ,
            \   [ "s" , "spelling"     , "\<C-S>" ] ,
            \ ]

function! Xfunccomplete(...)
    let a:return = ""
    for i in s:xdictionary
        let a:return .= i[1] . "\n"
    endfor
    return a:return
endfunction

function! s:xcommand(...)
    let old_cmdheight = &cmdheight
    set cmdheight=3
    echohl Statement
    let k = 0
    let a:prompt = ""
    for i in s:xdictionary
        let k += 1
        let a:prompt .= "[" . i[0] . "]" . i[1] . " "
        if k == 5
            let a:prompt .= "\n"
        endif
    endfor
    let input = input(
                \   a:prompt . "\n",
                \   "",
                \   "custom,Xfunccomplete"
                \ )

    echohl None
    execute "set cmdheight=" . old_cmdheight
    let x_char = <SID>get_ctrl(input)
    call feedkeys("\<C-X>" . x_char )
endfunction

function! s:get_ctrl( key )
    for i in s:xdictionary
        for j in i
            if tolower(a:key) =~ j
                return i[2]
            endif
        endfor
    endfor
endfunction

map <Plug>CTRL_X :call <SID>xcommand()<cr>
imap <C-X><C-X> <C-O><Plug>CTRL_X


let cpo = s:savecpo
