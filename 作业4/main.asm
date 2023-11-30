extrn row:far
extrn display:far

stk segment

stk ends

data segment
        ;以下是表示21年的21个字符串
        db 	'1975','1976','1977','1978','1979','1980','1981','1982','1983'
        db	'1984','1985','1986','1987','1988','1989','1990','1991','1992'
        db 	'1993','1994','1995'
        
        ;以下是表示21年公司总收的21个dword型数据
        dd 	16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
        dd 	345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
        
        ;以下是表示21年公司雇员人数的21个word型数据
        dw 	3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
        dw 	11542,14430,15257,17800        
data ends

table segment
        db 21 dup('year summ ne ?? ')
table ends

code segment
        assume cs:code, ds:data, ss:stk
start:
        mov  cx, 21                     ;循环次数
        mov  bx, data                   ;将数据段DATA的地址存储在寄存器BX中
        mov  ds, bx                     ;将数据段寄存器DS设置为数据段的地址，这样程序可以访问数据段中的数据
        mov  bx, table                  ;将数据段TABLE的地址存储在寄存器BX中
        mov  es, bx                     ;将数据段TABLE的地址存储在段地址寄存器ES中
        xor  bx, bx                     ;清零
        xor  di, di                     ;清零
        call row                        ;调用存储数据过程
        mov  cx, 21                     ;循环次数
        call display                    ;调用显示数据过程
        mov  ah, 4ch                    ;功能号4CH:结束正在运行的程序，并返回DOS操作系统。
        int  21h                        ;中断
code ends
        end  start
