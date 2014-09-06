let s:suite= themis#suite('baumkuchen')
let s:assert= themis#helper('assert')

function! s:suite.It_instantiates_a_new_object()
    let b= baumkuchen#of()

    call s:assert.is_dict(b)

    call s:assert.equals(b.ranges(), [])
    call s:assert.equals(b.keys(),   [])
    call s:assert.equals(b.assignments(), [])
    call s:assert.equals(b.values(), [])
    call s:assert.equals(b.skips(),  [])
endfunction

function! s:suite.It_instantiates_a_new_object_with_configuration()
    let b= baumkuchen#of({
    \   'ranges': [[1, 5]],
    \   'keys':   ['key1', 'key2', 'key3'],
    \   'assignments': ['='],
    \   'values': ['\w\+'],
    \   'skips':  ['\s'],
    \})

    call s:assert.is_dict(b)

    call s:assert.equals(b.ranges(), [[1, 5]])
    call s:assert.equals(b.keys(),   ['key1', 'key2', 'key3'])
    call s:assert.equals(b.assignments(), ['='])
    call s:assert.equals(b.values(), ['\w\+'])
    call s:assert.equals(b.skips(),  ['\s'])
endfunction

function! s:suite.It_configure_step_by_step()
    let b= baumkuchen#of()

    let b= baumkuchen#of({
    \   'ranges': [[1, 5]],
    \   'keys':   ['key1', 'key2', 'key3'],
    \   'assignments': ['='],
    \   'values': ['\w\+'],
    \   'skips':  ['\s'],
    \})

    call b.ranges([[1, 5]])
    call b.keys(['key1', 'key2', 'key3'])
    call b.assignments(['='])
    call b.values(['\w\+'])
    call b.skips(['\s'])

    call s:assert.equals(b.ranges(), [[1, 5]])
    call s:assert.equals(b.keys(),   ['key1', 'key2', 'key3'])
    call s:assert.equals(b.assignments(), ['='])
    call s:assert.equals(b.values(), ['\w\+'])
    call s:assert.equals(b.skips(),  ['\s'])
endfunction

function! s:suite.It_gets_a_dictionary_from_buffer()
    let b= baumkuchen#of({
    \   'ranges': [[1, 3], [-3, -1]],
    \   'keys':   ['\w\+'],
    \   'assignments': [':'],
    \   'values': ['\d\+'],
    \   'skips':  ['\s'],
    \})

    call setline(1, readfile('t/fixtures/text.txt'))

    let values= b.map('%')

    call s:assert.is_dict(values)
    call s:assert.length_of(keys(values), 6)

    call s:assert.has_key(values, 'one')
    call s:assert.has_key(values, 'two')
    call s:assert.has_key(values, 'three')

    call s:assert.has_key(values, 'eight')
    call s:assert.has_key(values, 'nine')
    call s:assert.has_key(values, 'ten')

    call s:assert.equals(values.one, '1')
    call s:assert.equals(values.two, '2')
    call s:assert.equals(values.three, '3')

    call s:assert.equals(values.eight, '8')
    call s:assert.equals(values.nine, '9')
    call s:assert.equals(values.ten, '10')
endfunction
