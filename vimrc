au BufNewFile *.cpp exec ":call SetTitle()"
au BufNewFile *.c exec ":call SetTitle()"

func SetTitle()
  call setline(1, "/*********************************************************")
    call append(line("."), "# File Name: ".expand("%"))
    call append(line(".")+1, "# Author: Vincent Yang")
    call append(line(".")+2, "# Mail: mengxian0913@gmail.com")
    call append(line(".")+3, "# Created Time: " .strftime("%c"))
    call append(line(".")+4, "*********************************************************/")
    call append(line(".")+5, "")
    if &filetype == 'cpp'
      call append(line(".")+6, "#pragma GCC optimize(\"O3\")")
      call append(line(".")+7, "#include <bits/stdc++.h>")
      call append(line(".")+8, "using namespace std;")
      call append(line(".")+9, "#define int long long")
      call append(line(".")+10, "#define ff first")
      call append(line('.')+11, "#define ss second")
      call append(line(".")+12, "#define fastIO cin.tie(nullptr)->sync_with_stdio(false);")
      call append(line(".")+13, "#define INF 0x7FFFFFFF")
      call append(line(".")+14, "#define pb push_back")
      call append(line(".")+15, "#define all(aa) aa.begin(),aa.end()")
      call append(line(".")+16, "#define MOD 1e9+7")
      call append(line(".")+17, "")
      call append(line(".")+18, "void solve(){")
      call append(line(".")+19, "    ")
      call append(line(".")+20, "}")
      call append(line(".")+21, "")
      call append(line(".")+22, "signed main(){")
      call append(line(".")+23, "    fastIO")
      call append(line(".")+24, "    solve();")
      call append(line(".")+25, "    return 0;")
      call append(line(".")+26, "}")
    endif
    au BufNewFile * normal G
endfunc


" 語法識別
syntax enable

" 顯示行數
set number

" 支援 256 色
set t_Co=256

" 終端機背景色 : dark / light
set background=light

" 內建風格 ( 縮寫指令 colo )
" 輸入 colorscheme 空一格，再按 Tab 可以依次預覽 : 
" blue / darkblue / default / delek / desert / eldlord
" evening / industry / koehler / morning / murphy / pable
" peachpuff / ron / shine / slate / torte / zollner

colorscheme molokai

" 搜尋，高亮標註
set hlsearch

" 配置檔案路徑，讓 find 指令更好用
set path=.,/usr/include,,**

" ts = tabstop
set ts=4 "縮排 4 格

" tab 替換成空格
set expandtab

" 自動縮排 ｜ autoindent / smartindent / cindent
set autoindent " 跟上一行的縮進一致

" --- ↑ ---  一般配置 --- ↑ ---

inoremap ;; <ESC>


" 執行程式
nmap <F5> :call CompileRun()<CR>
func! CompileRun()
        exec "w"
if &filetype == 'python'
            exec "!time python3 %"
elseif &filetype == 'java'
            exec "!javac %"
            exec "!time java %<"
elseif &filetype == 'sh'
            :!time bash %
endif
    endfunc


" --- ↑ ---  快捷鍵配置 --- ↑ ---

" JSON 文字格式化 
" command! JSONFormat :execute '%!python -m json.tool' 

command! JSONFormat :execute '%!python -m json.tool'
\ | :execute '%!python -c "import re,sys;chr=__builtins__.__dict__.get(\"unichr\", chr);sys.stdout.write(re.sub(r\"\\\\u[0-9a-f]{4}\", lambda x: chr(int(\"0x\" + x.group(0)[2:], 16)).encode(\"utf-8\"), sys.stdin.read()))"'
\ | :set ft=javascript
\ | :1

" XML 文字格式化
command! XMLFormat :execute '%!xmllint --format -'

" 常用的文字替代
command! Br2line :execute '%s/<br>/---/g'

" --- ↑ ---  命令行配置 --- ↑ ---


set viminfo='1000,<500
set formatoptions=tcqrn1
set expandtab
set noshiftround


" Cursor motion
set scrolloff=3
set backspace=indent,eol,start
set matchpairs+=<:> " use % to jump between pairs
runtime! macros/matchit.vim

" Move up/down editor lines
nnoremap j gj
nnoremap k gk

" Allow hidden buffers
set hidden

" Rendering
set ttyfast

" Status bar
set laststatus=2

set number ruler hlsearch
set cindent
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set tabstop=4
set shiftwidth=4
set mouse=a
set ruler
set history=100

set encoding=utf-8
syntax on
set ai
set smartindent
set backspace=2
set ic
set number


:inoremap ( ()<Left>
:inoremap ) <c-r>=ClosePair(')')<CR>
:inoremap { {}<Left>
:inoremap } <c-r>=ClosePair('}')<CR>
:inoremap [ []<Left>
:inoremap ] <c-r>=ClosePair(']')<CR>
:inoremap " <c-r>=DQuote()<CR>
:inoremap ' <c-r>=SQuote()<CR>
:inoremap <BS> <c-r>=RemovePairs()<CR>
" 将回车键映射为BracketIndent函数
:inoremap <CR> <c-r>=BracketIndent()<CR>


func! ClosePair(char)
    if getline('.')[col('.') - 1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endfunc

"自动补全双引号
func! DQuote()
    if getline('.')[col('.') - 1] == '"'
        return "\<Right>"
    else
		if getline('.')[col('.') - 2] == '"'
			return '"'
		else
			return "\"\"\<Left>"
    endif
endfunc
"自动补全单引号
func! SQuote()
    if getline('.')[col('.') - 1] == "'"
        return "\<Right>"
    else
		if getline('.')[col('.') - 2] == "'"
			return "'"
		else
	        return "''\<Left>"
    endif
endfunc

" 按BackSpace键时判断当前字符和前一字符是否为括号对或一对引号，如果是则两者均删除，并保留BackSpace正常功能
func! RemovePairs()
	let l:line = getline(".") " 取得当前行
	let l:current_char = l:line[col(".")-1] " 取得当前光标字符
	let l:previous_char = l:line[col(".")-2] " 取得光标前一个字符

	if (l:previous_char == '"' || l:previous_char == "'") && l:previous_char == l:current_char
		return "\<delete>\<bs>"
	elseif index(["(", "[", "{"], l:previous_char) != -1
		" 将光标定位到前括号上并取得它的索引值
		execute "normal! h"
		let l:front_col = col(".")
		" 将光标定位到后括号上并取得它的行和索引值
		execute "normal! %"
		let l:line1 = getline(".")
		let l:back_col = col(".")
		" 将光标重新定位到前括号上
		execute "normal! %"
		" 当行相同且后括号的索引比前括号大1则匹配成功
		if l:line1 == l:line && l:back_col == l:front_col + 1
			return "\<right>\<delete>\<bs>"
		else
			return "\<right>\<bs>"
		end
	else
	  	return "\<bs>"
	end
endfunc

" 在大括号内换行时进行缩进
func! BracketIndent()
	let l:line = getline(".")
	let l:current_char = l:line[col(".")-1]
	let l:previous_char = l:line[col(".")-2]

	if l:previous_char == "{" && l:current_char == "}"
		return "\<cr>\<esc>\ko"
	else
		return "\<cr>"
	end
endfunc


map <C-A> ggVG"+Y

