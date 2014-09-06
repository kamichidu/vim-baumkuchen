"
" Author: kamichidu
" Last Change: 06-Sep-2014.
" Lisence: The MIT License (MIT)
" 
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
" 
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
" 
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
" THE SOFTWARE.
"
let s:save_cpo= &cpo
set cpo&vim

let s:prototype= {
\   '_ranges':      [],
\   '_keys':        [],
\   '_values':      [],
\   '_assignments': [],
\   '_skips':       [],
\}

function! baumkuchen#of(...)
    let config= get(a:000, 0, {})
    let obj= deepcopy(s:prototype)

    let obj._ranges=      get(config, 'ranges', [])
    let obj._keys=        get(config, 'keys', [])
    let obj._values=      get(config, 'values', [])
    let obj._assignments= get(config, 'assignments', [])
    let obj._skips=       get(config, 'skips', [])

    return obj
endfunction

function! s:prototype.ranges(...)
    if a:0 == 0
        return deepcopy(self._ranges)
    else
        let self._ranges= deepcopy(a:1)
    endif
endfunction

function! s:prototype.keys(...)
    if a:0 == 0
        return deepcopy(self._keys)
    else
        let self._keys= deepcopy(a:1)
    endif
endfunction

function! s:prototype.values(...)
    if a:0 == 0
        return deepcopy(self._values)
    else
        let self._values= deepcopy(a:1)
    endif
endfunction

function! s:prototype.assignments(...)
    if a:0 == 0
        return deepcopy(self._assignments)
    else
        let self._assignments= deepcopy(a:1)
    endif
endfunction

function! s:prototype.skips(...)
    if a:0 == 0
        return deepcopy(self._skips)
    else
        let self._skips= deepcopy(a:1)
    endif
endfunction

function! s:prototype.map(...)
    let expr= get(a:000, 0, '%')
    let pattern= self.make_pattern()
    let lines= getbufline(expr, 1, '$')
    let result= {}

    for range in self.ranges()
        let from_idx= range[0] >= 0 ? range[0] - 1 : range[0]
        let to_idx=   range[1] >= 0 ? range[1] - 1 : range[1]
        " linenr to index
        for line in lines[from_idx : to_idx]
            let list= matchlist(line, pattern)
            if !empty(list)
                let result[list[1]]= list[2]
            endif
        endfor
    endfor

    return result
endfunction

function! s:prototype.make_pattern()
    let skip=   '\%(' . join(self._skips, '\|') . '\)*'
    let key=    '\(' . join(self._keys, '\|') . '\)'
    let assign= '\%(' . join(self._assignments, '\|') . '\)'
    let value=  '\(' . join(self._values, '\|') . '\)'

    return '\m' . skip . key . skip . assign . skip . value
endfunction

let &cpo= s:save_cpo
unlet s:save_cpo
