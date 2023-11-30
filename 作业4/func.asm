public row
public display

code segment
        assume cs:code
row proc far                            ;每一行循环开始；存储数据过程
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
        call space                      ;调用存储空格过程
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
        call space                      ;调用存储空格过程
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
        call space                      ;调用存储空格过程
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
        call space                      ;调用存储空格过程
        pop  cx                         ;恢复循环次数
        cmp  cx, 1                      ;比较是否是最后一行
        je   finish                     ;是，结束
        inc  di                         ;不是，进入下一行
        loop row                        ;每一行循环结束
finish:                                 ;结束位置
        ret                             ;存储数据过程结束
row endp                                ;存储数据过程结束
display proc far                        ;每一行循环开始；显示数据过程
        push cx                         ;入栈，防止过程中改变数值
        mov  bp, cx                     ;当前次数赋值栈基址指针寄存器
        sub  bp, 21                     ;做差，结果<=0
        neg  bp                         ;取反，得行索引
        mov  si, 0                      ;列索引
        mov  ax, 10h                    ;行字节数
        mul  bp                         ;乘行索引
        mov  bp, ax                     ;行索引用寄存器BP存放
;------------------01234----------------;处理第01234字节
        mov  cx, 5                      ;做五次，包括空格
y:                                      ;五个字节循环开始
        mov  dx, es:[si+bp]             ;TABLE中数据给到
        mov  ah, 2                      ;输出方式
        int  21h                        ;中断
        inc  si                         ;DATA下一位
        loop y                          ;五个字节循环结束
;------------------5678-----------------;处理第5678字节
        mov  ax, word ptr es:[si+bp]    ;按顺序，低位给到寄存器AX
        inc  si                         ;指针后移
        inc  si                         ;指针后移
        mov  dx, word ptr es:[si+bp]    ;高位给到寄存器DX
        call show1                      ;调用显示双字过程
;------------------9--------------------;处理第9字节
        inc  si                         ;指针后移
        inc  si                         ;指针后移
        mov  dx, es:[si+bp]             ;数据给到寄存器DX
        mov  ah, 2                      ;输出方式
        int  21h                        ;中断
;------------------AB-------------------;处理第AB字节
        inc  si                         ;指针后移
        mov  dx, word ptr es:[si+bp]    ;数据给到寄存器DX
        call show                       ;调用显示过程
;------------------C--------------------;处理第12字节
        inc  si                         ;指针后移
        inc  si                         ;指针后移
        mov  dx, word ptr es:[si+bp]    ;数据给到寄存器DX
        mov  ah, 2                      ;输出方式
        int  21h                        ;中断
;------------------DE-------------------;处理第DE字节
        inc  si                         ;指针后移
        mov  dx, word ptr es:[si+bp]    ;数据给到寄存器DX
        call show                       ;调用显示过程
;------------------F--------------------;处理第15字节
        inc  si                         ;指针后移
        inc  si                         ;指针后移
        mov  dx, word ptr es:[si+bp]    ;数据给到寄存器DX
        mov  ah, 2                      ;输出方式
        int  21h                        ;中断
;------------------<--------------------;输出行末尾提示符
        mov  dx, "<"                    ;行末尾提示符
        mov  ah, 2                      ;输出方式
        int  21h                        ;中断
        mov  dx, 0ah                    ;换行
        mov  ah, 2                      ;输出方式
        int  21h                        ;中断
        pop  cx                         ;恢复当前循环次数
        loop display                    ;每一行循环结束
        ret                             ;显示数据过程结束
display endp                            ;显示数据过程结束
show1:                                  ;显示双字过程
        xor  cx, cx                     ;清空
        xor  di, di                     ;清空
        xor  bx, bx                     ;清空
divide1:                                ;进制转换
        mov  di, 10                     ;十进制
        call divdw                      ;解决除法溢出问题
        add  di, 30h                    ;ASCII转换
        push di                         ;余数进栈
        inc  cx                         ;数字位数+1
        cmp  dx, 0                      ;高位商为0，向下判断
        jne  divide1                    ;高位商不为0，继续除
        cmp  ax, 0                      ;低位商也为0，结束
        jne  divide1                    ;低位商不为0，继续除
output1:                                ;循环输出开始
        pop  dx                         ;依次弹出结果
        mov  ah, 2                      ;输出方式
        int  21h                        ;中断
        loop output1                    ;循环输出结束
        ret                             ;显示双字过程结束
show:                                   ;显示过程
        xor  cx, cx                     ;清空
        mov  bx, dx                     ;赋值
        mov  ax, bx                     ;赋值
        mov  bx, 10                     ;十进制
divide:                                 ;进制转换
        xor  dx, dx                     ;清空
        div  bx                         ;除以10取余数，dx:ax / bx = ax......dx
        add  dl, 30h                    ;ASCII转换
        push dx                         ;商入栈
        inc  cx                         ;数字位数+1
        cmp  ax, 0                      ;商为0，结束
        jne  divide                     ;商不为0，继续除
output:                                 ;循环输出开始
        pop  dx                         ;依次弹出结果
        mov  ah, 2                      ;输出方式
        int  21h                        ;中断
        loop output                     ;循环输出结束
        ret                             ;显示过程结束
divdw:                                  ;解决除法溢出问题
        push bx                         ;寄存器BX存储低16位
        mov  bx, ax 	                ;bx=L
        mov  ax, dx	                    ;ax=H
        mov  dx, 0 	                    ;dx=0作为高16位
        div  di                         ;双字除法
        push ax 	                    ;int(H/N)*65536入栈
        mov  ax, bx	                    ;ax=L
        div  di                         ;双字除法
        mov  di, dx                     ;余数,DX余数作为高16位
        pop  dx                         ;结果的高16位
        pop  bx                         ;寄存器BX存储低16位
        ret                             ;过程结束
space:                                  ;存储空格
        mov  dl, " "                    ;存入空格
        mov  byte ptr es:[di], dl       ;写入一个字节
        ret                             ;结束
code ends
        end
