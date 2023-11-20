stk segment

stk ends

data segment
num     dw ?,?,?
msg     db "WHAT IS THE DATE?(MM DD YYYY)",07h, 0ah, 0dh, '$';响铃07h
data ends

code segment
        assume cs:code, ds:data, ss:stk
start:
        mov  ax, data   ;将数据段的地址存储在寄存器AX中
        mov  ds, ax     ;将数据段寄存器DS设置为数据段的地址，这样程序可以访问数据段中的数据
        mov  ax, stk    ;将栈段的地址存储在寄存器AX中
        mov  ss, ax     ;将栈段寄存器SS设置为栈段的地址，这样程序可以访问栈段中的数据

        lea  dx, msg    ;打印提示语
        mov  ah, 09h    ;将寄存器AH设置为09h，这是DOS的功能号，表示要执行字符串输出
        int  21h        ;触发DOS中断21h，以执行字符串输出操作，输出提示语

        mov  si,0       ;访问数组第0个元素
        call GetNum     ;调用GetNum，接收键入的月值
        mov  si,2       ;访问数组第1个元素
        call GetNum     ;调用GetNum，接收键入的日值
        mov  si,4       ;访问数组第2个元素
        call GetNum     ;调用GetNum，接收键入的年值
        mov  si,4       ;访问数组第2个元素
        call Disp       ;调用Disp显示年值
        mov  dx, "-"    ;输出短横线
        mov  ah, 02h    ;将寄存器AH设置为02h，这是DOS的功能号，表示要执行字符输出
        int  21h        ;触发DOS中断21h，以执行字符输出操作，输出短横线
        mov  si,0       ;访问数组第0个元素
        call Disp       ;调用Disp显示月值
        mov  dx, "-"    ;输出短横线
        mov  ah, 02h    ;将寄存器AH设置为02h，这是DOS的功能号，表示要执行字符输出
        int  21h        ;触发DOS中断21h，以执行字符输出操作，输出短横线
        mov  si,2       ;访问数组第1个元素
        call Disp       ;调用Disp显示日值

        mov  ah, 4ch    ;功能号4CH:结束正在运行的程序，并返回DOS操作系统。
        int  21h        ;中断

GetNum:                 ;读取数字过程
init:                   ;初始化
        xor  ax, ax     ;清零
        xor  bx, bx     ;清零
        xor  cx, cx     ;清零
        xor  dx, dx     ;清零
        mov  ah, 01h    ;读一个字符方式
        int  21h        ;中断
input:                  ;循环输入开始
        cmp  al, 30h    ;判断'0'
        jb   check      ;比0小，跳转
        cmp  al, 39h    ;判断'9'
        ja   check      ;比9大，跳转
        sub  al, 30h    ;ASCII处理
        shl  bx, 1      ;bx左移
        mov  cx, bx     ;赋值
        shl  bx, 1      ;bx左移
        shl  bx, 1      ;bx左移
        add  bx, cx     ;加和
        add  bl, al     ;加和
        mov  ah, 01h    ;读一个字符方式
        int  21h        ;中断
        jmp  input      ;循环输入结束
check:                  ;检查输入
        cmp  al, 0dh    ;输入回车
        je   save       ;跳转保存结果
        cmp  al, 20h    ;输入空格
        je   save       ;跳转保存结果
        cmp  al, "/"    ;输入/
        je   save       ;跳转保存结果
        jmp  init       ;输入错误，跳转初始化
save:                   ;保存结果
        mov  ax, bx     ;ax是结果
        mov  num[si], ax;存入数据段内存
        ret             ;用栈中的数据，修改IP的内容，从而实现近转移

Disp:                   ;显示数值过程
        xor  cx, cx     ;cx清空
        mov  bx, num[si];num放入bx
        mov  ax, bx     ;赋值
        mov  bx, 10     ;十进制
divide:                 ;进制转换
        xor  dx, dx     ;清空
        div  bx         ;除以10取余数，dx:ax / bx = ax......dx
        add  dl, 30h    ;ASCII转换
        push dx         ;商入栈
        inc  cx         ;数字位数+1
        cmp  ax, 0      ;商为0，结束
        jne  divide     ;商不为0，继续除
output:                 ;循环输出开始
        pop  dx         ;依次弹出结果
        mov  ah, 2      ;输出方式
        int  21h        ;中断
        loop output     ;循环输出结束
        ret             ;用栈中的数据，修改IP的内容，从而实现近转移
code ends
        end  start
