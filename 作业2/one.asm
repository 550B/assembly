data segment
        msg  db "The 9*9 table:", 0ah, 0dh, '$'
        num  dw ?,?,?,? ;声明一个字（16位）数组num，该数组有四个元素，但初始化为问号?，表示这些值将在程序运行时被填充
        res  db ?,?,?,? ;声明一个字节（8位）数组
data ends

code segment
        assume cs:code, ds:data
start:
        mov  cx, 9      ;外圈循环次数
        mov  ax, data   ;将数据段的地址存储在寄存器AX中
        mov  ds, ax     ;将数据段寄存器DS设置为数据段的地址，这样程序可以访问数据段中的数据

        lea  dx, msg    ;打印提示语
        mov  ah, 09h    ;将寄存器AH设置为09h，这是DOS的功能号，表示要执行字符串输出
        int  21h        ;触发DOS中断21h，以执行字符串输出操作，输出提示语
loop1:
        mov  [num], cx  ;存放乘数
        push cx         ;保存外层计数
        push cx         ;乘数进栈
loop2:
        ;显示乘数
        mov  dx, [num]  ;将num数组的第一个元素（乘数）加载到寄存器DX中
        add  dx, 30h    ;转换到ASCII
        mov  ah, 02h    ;将寄存器AH设置为2，表示要执行字符输出操作
        int  21h        ;触发DOS中断21h，以输出当前乘数

        ;显示x号
        mov  dl, 78h    ;将DL寄存器设置为78h，表示要输出字符'x'
        mov  ah, 02h    ;将寄存器AH设置为2，表示要执行字符输出操作
        int  21h        ;触发DOS中断21h，以输出'x'

        ;显示第二个乘数
        mov  [num+1], cx;存放第二个乘数
        push cx         ;第二个乘数进栈
        mov  dx, cx     ;将第二个乘数加载到寄存器DX中
        add  dx, 30h    ;转换到ASCII
        mov  ah, 02h    ;将寄存器AH设置为2，表示要执行字符输出操作
        int  21h        ;触发DOS中断21h，以输出第二个乘数

        ;显示=号
        mov  dl, 3dh    ;将DL寄存器设置为3dh，表示要输出字符'='
        mov  ah, 02h    ;将寄存器AH设置为2，表示要执行字符输出操作
        int  21h        ;触发DOS中断21h，以输出'='

        ;计算两数相乘的结果，并显示
        pop  dx         ;取出第二个乘数
        pop  ax         ;取出第一个乘数
        push ax         ;第一个乘数再次进栈，在下次内层循环中推出再次使用
        mul  dx         ;相乘，结果在AX中

        mov  bx, 10     ;准备除以10
        mov  si, 2      ;循环2次，最大到十位 (乘法表最大为81,所以最大到十位)
toDec:                  ;把各位转换为数值，如AX中的81，转换为8,1存在内存中
        mov  dx, 0      ;清空DX寄存器
        div  bx         ;除10法得到各个位上的数值
        mov  [res+si], dl;余数为该位上的值，第一次循环为个位，第二次为十位，存到内存中
        dec  si         ;计数器自减
        cmp  ax, 0      ;商是否为0，为0算法结束
        ja   toDec      ;跳转，继续处理下一位
output:                 ;输出内存中存放的转换数值数
        inc  si         ;计数器自增
        mov  dl, [res+si];结果移动到DX寄存器低八位
        add  dl, 30h    ;转为ASCII码
        mov  ah, 02h    ;将寄存器AH设置为2，表示要执行字符输出操作
        int  21h        ;触发DOS中断21h，以输出分解后的数码
        cmp  si, 2      ;将计数器与2比较
        jb   output     ;跳转，把所有结果数码输出

        mov  dl, 09h    ;把水平制表栏移动到DX寄存器低八位
        mov  ah, 02h    ;将寄存器AH设置为2，表示要执行字符输出操作
        int  21h        ;触发DOS中断21h，以输出水平制表栏

        loop loop2      ;内层循环结束

        mov  dx, 0ah    ;把换行移动到DX寄存器低八位
        mov  ah, 02h    ;将寄存器AH设置为2，表示要执行字符输出操作
        int  21h        ;触发DOS中断21h，以输出换行
        pop  cx         ;内层计数
        pop  cx         ;还原外层计数
        loop loop1      ;外层循环结束

        mov ah, 4ch
        int 21h
code ends
        end start
