stk segment

stk ends

data segment
    num dw ?
data ends

code segment
    assume cs:code, ss:stk, ds:data
start:
    mov ax, data    ;数据段基址
    mov ds, ax      ;赋值给基址寄存器

;---------------------------------------------------------------
;   输入部分

    push bp         ;入栈
    mov bp, sp      ;栈顶指针
    push bx         ;bx入栈
    push cx         ;cx入栈
    push dx         ;dx入栈
init:               ;初始化
    xor ax, ax      ;清零
    xor bx, bx      ;清零
    xor cx, cx      ;清零
    xor dx, dx      ;清零
    mov ah, 1       ;读一个字符方式
    int 21h         ;中断
input:              ;循环输入开始
    cmp al, 30h     ;判断'0'
    jb check        ;比0小，跳转
    cmp al, 39h     ;判断'9'
    ja check        ;比9大，跳转
    sub al, 30h     ;ASCII处理
    shl bx, 1       ;bx左移
    mov cx, bx      ;赋值
    shl bx, 1       ;bx左移
    shl bx, 1       ;bx左移
    add bx, cx      ;加和
    add bl, al      ;加和
    mov ah, 1       ;读一个字符方式
    int 21h         ;中断
    jmp input       ;循环输入结束
check:              ;检查输入
    cmp al, 0dh     ;输入回车
    je save         ;跳转保存结果
    jmp init        ;输入错误，跳转初始化
save:               ;保存结果
    mov ax, bx      ;ax是结果
    pop dx          ;出栈
    pop cx          ;出栈
    pop bx          ;出栈
    pop bp          ;出栈

;   输入部分结束
;---------------------------------------------------------------

    mov num, ax     ;存入数据段内存
    push num        ;入栈
    
;---------------------------------------------------------------
;   输出部分

    push bp         ;入栈
    mov bp, sp      ;栈顶指针
    push ax         ;ax入栈
    push bx         ;bx入栈
    push cx         ;cx入栈
    push dx         ;dx入栈
    xor cx, cx      ;cx清空
    mov bx, [bp+4]  ;num放入bx
    mov ax, bx      ;赋值
    mov bx, 10      ;十进制
divide:             ;进制转换
    xor dx, dx      ;清空
    div bx          ;除以10取余数，dx:ax / bx = ax......dx
    add dl, 30h     ;ASCII转换
    push dx         ;商入栈
    inc cx          ;数字位数+1
    cmp ax, 0       ;商为0，结束
    jne divide      ;商不为0，继续除
output:             ;循环输出开始
    pop dx          ;依次弹出结果
    mov ah, 2       ;输出方式
    int 21h         ;中断
    loop output     ;循环输出结束

    pop dx          ;dx出栈
    pop cx          ;cx出栈
    pop bx          ;bx出栈
    pop ax          ;ax出栈
    pop bp          ;bp出栈

;   输出部分结束
;---------------------------------------------------------------

    mov ah, 4ch
    int 21h
code ends
       end start
