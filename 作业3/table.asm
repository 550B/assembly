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
        dw 	11542,14430,45257,17800        
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
row:                                    ;每一行循环开始
        mov  bp, cx                     ;当前次数赋值栈基址指针寄存器
        sub  bp, 21                     ;做差，结果<=0
        neg  bp                         ;取反，得一行中第几个索引
        push cx                         ;入栈，防止过程中改变数值
        mov  si, 0                      ;三种数据起始地址
;------------------0123-----------------;处理第0123字节
        shl  bp, 1                      ;*2
        shl  bp, 1                      ;*2
        mov  cx, 4                      ;年份的4个字节
year:                                   ;年份字节循环开始
        mov  dx, [si+bp]                ;从DATA取到字符
        mov  es:[di], dx                ;存入TABLE对应位置
        inc  si                         ;DATA下一位
        inc  di                         ;TABLE下一位
        loop year                       ;年份字节循环结束
;------------------4--------------------;处理第4字节
        mov  dl, " "                    ;存入空格
        mov  byte ptr es:[di], dl       ;写入一个字节
;------------------5678-----------------;处理第5678字节
        add  si, 80                     ;挪到总收入处
        inc  di                         ;TABLE下一位
        mov  dx, word ptr [si+bp]       ;从DATA取到低位字型数据
        mov  word ptr es:[di], dx       ;存入TABLE对应位置
        add  si, 2                      ;挪到高位
        add  di, 2                      ;TABLE对应高位
        mov  dx, word ptr [si+bp]       ;从DATA取到高位字型数据
        mov  word ptr es:[di], dx       ;存入TABLE对应位置
;------------------9--------------------;处理第9字节
        inc  di                         ;TABLE下一位
        inc  di                         ;TABLE下一位
        mov  dl, " "                    ;存入空格
        mov  byte ptr es:[di], dl       ;写入一个字节
;------------------AB-------------------;处理第AB字节
        shr  bp, 1                      ;/2
        add  si, 82                     ;挪到雇员人数处
        inc  di                         ;TABLE下一位
        mov  dx, word ptr [si+bp]       ;从DATA取到字型数据
        mov  word ptr es:[di], dx       ;存入TABLE对应位置
;------------------C--------------------;处理第12字节
        inc  di                         ;TABLE下一位
        inc  di                         ;TABLE下一位
        inc  di                         ;TABLE下一位
        xor  dx, dx                     ;寄存器DX清空
        mov  dl, " "                    ;存入空格
        mov  byte ptr es:[di], dl       ;写入一个字节
;------------------DE-------------------;处理第DE字节
        shl  bp, 1                      ;*2
        mov  ax, [si-84+bp]             ;寄存器AX中存放被除数的低16位
        mov  dx, [si-82+bp]             ;寄存器DX中存放被除数的高16位
        shr  bp, 1                      ;/2
        div  word ptr [si+bp]           ;除数是16位，做双字除法，结果在寄存器AX中
        mov  es:[di], ax                ;写入人均收入
;------------------F--------------------;处理第15字节
        inc  di                         ;TABLE下一位
        inc  di                         ;TABLE下一位
        mov  dl, " "                    ;存入空格
        mov  byte ptr es:[di], dl       ;写入一个字节

        pop  cx                         ;恢复循环次数
        cmp  cx, 1                      ;比较是否是最后一行
        je   finish                     ;是，结束
        inc  di                         ;不是，进入下一行
        loop row                        ;每一行循环结束
finish:                                 ;结束位置
        mov  ah, 4ch                    ;功能号4CH:结束正在运行的程序，并返回DOS操作系统。
        int  21h                        ;中断
code ends
        end  start
