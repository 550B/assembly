#include <stdio.h>
extern int sum(int a, int b);
int main() 
{   
    int c = sum(1, 2);
    printf("1 + 2 = %d", c);
    return 0;
}