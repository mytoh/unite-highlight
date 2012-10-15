
let s:save_cpo = &cpo
set cpo&vim


let s:unite_source = {
      \   'name': 'highlight',
      \   'syntax': 'uniteSource__Highlight',
      \   'hooks': {},
      \}


function! s:unite_source.gather_candidates(args, context)
  redir => highs
  silent! highlight
  redir END
  let highlights = split(highs, '\n')
  let format = '%s'
  return map(copy(highlights), '{
        \   "word": printf(format, v:val),
        \   "source": "highlight",
        \   "kind": "common",
        \}')
endfunction

function! s:on_syntax(args, context)
  redir => highs
  silent! highlight
  redir END
  let highlight_names = map(split(highs, '\n'), 'get(split(v:val), 0)')
  for hiname in highlight_names
    execute 'syntax match uniteSource__Highlight_' . hiname  '/' . hiname . '\s*xxx/'
          \ 'contained containedin=uniteSource__Highlight'
    execute 'highlight default link uniteSource__Highlight_' . hiname hiname
  endfor
endfunction

function! s:unite_source.hooks.on_syntax(args, context)"{{{
  return s:on_syntax(a:args, a:context)
endfunction"}}}

function! unite#sources#highlight#define()
  return s:unite_source
endfunction



let &cpo = s:save_cpo
unlet s:save_cpo
