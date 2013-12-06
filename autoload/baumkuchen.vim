"
" Author: kamichidu
" Last Change: 07-Dec-2013.
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
\}

function! baumkuchen#of(config)
    let l:obj= deepcopy(s:prototype)

    let l:obj._ranges=      get(a:config, 'ranges', [])
    let l:obj._keys=        get(a:config, 'keys', [])
    let l:obj._values=      get(a:config, 'values', [])
    let l:obj._assignments= get(a:config, 'assignments', [])

    return l:obj
endfunction

function! s:prototype.ranges()
    return deepcopy(self._ranges)
endfunction

function! s:prototype.keys()
    return deepcopy(self._keys)
endfunction

function! s:prototype.values()
    return deepcopy(self._values)
endfunction

function! s:prototype.assignments()
    return deepcopy(self._assignments)
endfunction

function! s:prototype.map(expr)
    let l:pattern= self._make_pattern()
    let l:result= {}

    for l:range in self.ranges()
        let l:lines= getbufline(a:expr, l:range[0], l:range[1])
        let l:founds= filter(l:lines, 'v:val =~# ''' . l:pattern . '''')

        for l:found in l:founds
            let l:list= matchlist(l:found, l:pattern)
            let [l:key, l:value]= [l:list[1], l:list[3]]

            let l:result[l:key]= l:value
        endfor
    endfor

    return l:result
endfunction

function! s:prototype._make_pattern()
    let l:result= ''

    let l:result.= '\(' . join(self.keys(), '\|') . '\)'
    let l:result.= '\(' . join(self.assignments(), '\|') . '\)'
    let l:result.= '\(' . join(self.values(), '\|') . '\)'

    return l:result
endfunction

let &cpo= s:save_cpo
unlet s:save_cpo

