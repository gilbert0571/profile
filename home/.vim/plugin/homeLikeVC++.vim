"=============================================================================
" File:		homeLikeVC++.vim
" Author:	Luc Hermitte <EMAIL:hermitte at free.fr>
"		<URL:http://hermitte.free.fr/vim>
" Version:	2.0.0
" Created:	23rd mar 2002
" Last Update:	07th Nov 2005
"------------------------------------------------------------------------
" Description:	Makes <Home> behaves like it does with Ms-VC++.
" -> Hitting <Home> once moves the cursor to the first non blank character of
"  the line, twice: to the first column of the line.
" -> <end> once moves the cursor at the last non blank character, then at the
"  last character (if different), ...
"
"------------------------------------------------------------------------
" Installation:	Drop it into one of your plugin directories
"
"  This plugin does not propose, on purpose, windows-like keybindings
" combining <shift> with <arrows>, <home> nor <end>.
"  These keybinding are more generic, and may need to be implemented
" differently according to one's taste. If you come from a MsWindows
" background you may be interrested in
"	:imap <S-home> <c-\><c-n>gh<home>
"	:nmap <S-home> gh<home>
"	:vmap <S-home> <home>
"
"	:imap <S-home> <c-\><c-n>gh<end>
"	:nmap <S-home> gh<end>
"	:vmap <S-home> <end>
"
"  Personnally, I'd rather never end-up in SELECT-mode unless I
" explicitly say so, or unless I jumped to a |marker| (aka
" |placeholder|). For instance, I often need to (visually) select text
" and then surround it with a pair of brackets, while I expect '(' to
" expand into '()<left>' when I am in INSERT- or SELECT-mode.
"
"  Thus, In my .vimrc, I define the following mappings:
" 	:imap <s-home> <c-\><c-n>vo<home>
"	:nmap <S-home> v<home>
"	:vmap <S-home> <home>
"       :imap <S-end>  <c-\><c-n>v<end>
"       :nmap <S-end>  v<end>
"       :vmap <S-end>  <end>
"
"  Note: I use here :*map and not :*noremap.
"
" History:
"  v1.0:   initial version
"  v1.1:   VISUAL-mode mapping added.
"  v2.0.0: <end> is supported as well
"
" TODO:		any missing features ?
"=============================================================================
"
" Avoid reinclusion
if exists("g:loaded_homeLikeVC") && !exists('g:force_reload_homelikeVC')
  finish
endif
let g:loaded_homeLikeVC = 1

"------------------------------------------------------------------------
inoremap <Home> <c-o>@=<SID>HomeLikeVCpp()<cr>
nnoremap <Home> @=<SID>HomeLikeVCpp()<cr>
vnoremap <Home> @=<SID>HomeLikeVCpp()<cr>

inoremap <End> <c-\><c-n>@=<SID>EndLikeVCpp()<cr>a
nnoremap <End> @=<SID>EndLikeVCpp()<cr>
vnoremap <End> @=<SID>EndLikeVCpp()<cr>

function! s:HomeLikeVCpp()
  let ll = strpart(getline('.'), -1, col('.'))
  if ll =~ '^\s\+$' | return '0'
  else              | return '^'
  endif
endfunction


function! s:EndLikeVCpp()
  let l = strpart(getline('.'), col('.')-1)
  let ll = match(l, '^\S\s*$')
  " Comment the line above and uncomment the line below to make single-press
  " jump to the end of the line and double-press jump to the first
  " non-whitespace character.
  "let ll = match(l,'\S')

  if getline('.') =~ '^\s*$'
    if col('.') + (mode()!='v') == col('$') | return 'g_'
    else                        | return '$'
    endif
  else
    if ll >= 0 | return '$'
    else                        | return 'g_'
    endif
  endif
endfunction
