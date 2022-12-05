let s:bg = '#131517'
let s:fg = '#3e4b59'
let s:statusfg = "#0f1419"

let s:base0 = '#e6e1cf'
let s:base1 = '#e6e1cf'
let s:base2 = '#3e4b59'
let s:base3 = '#e6e1cf'
let s:base00 = '#14191f'
let s:base01 = '#14191f'
let s:base02 = '#0f1419'
let s:base023 = '#0f1419'
let s:base03 = '#e6b673'
let s:yellow = '#e7b673'
let s:orange = '#ff7734'
let s:red = '#f07178'
let s:magenta = '#948c67'
let s:blue = '#1d5875'
let s:cyan = s:blue
let s:green = '#6e963c'

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}
let s:p.normal.left = [ [ s:statusfg, s:blue ], [ s:fg, s:bg ] ]
let s:p.normal.middle = [ [ s:fg, s:bg ] ]
let s:p.normal.right = [ [ s:fg, s:bg ], [ s:fg, s:bg ] ]

let s:p.inactive.left =  [ [ s:statusfg, s:bg ], [ s:fg, s:bg ] ]
let s:p.insert.left = [ [ s:statusfg, s:green ], [ s:fg, s:bg ] ]
let s:p.replace.left = [ [ s:statusfg, s:red ], [ s:fg, s:bg ] ]
let s:p.visual.left = [ [ s:statusfg, s:magenta ], [ s:fg, s:bg ] ]

let s:p.tabline.tabsel = [ [ s:base02, s:base03 ] ]
let s:p.tabline.left = [ [ s:base3, s:base00 ] ]
let s:p.tabline.middle = [ [ s:base2, s:base02 ] ]
let s:p.tabline.right = [ [ s:base2, s:base00 ] ]

let s:p.normal.error = [ [ s:base03, s:red ] ]
let s:p.normal.warning = [ [ s:base023, s:yellow ] ]

let g:lightline#colorscheme#bland#palette = lightline#colorscheme#fill(s:p)
