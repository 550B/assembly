code segment
        assume cs:code
start:
SUMM MACRO x1, x2, result
        mov ax, x1
        add ax, x2
        mov result, ax
        endm

        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
        mov bx, 123
        mov cx, 456
loop1:
        SUMM bx, cx, dx
        loop loop1
        call show
        mov  ah, 4ch
        int  21h

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
code ends
        end start