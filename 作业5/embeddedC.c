#include <stdio.h>
int main()
{
  int num1 = 10, num2 = 15;
  __asm__ __volatile__("add %%ebx, %%eax"
                        :"=a"(num1)				// output
                        :"a"(num1), "b"(num2)	// input
                        );
  printf("num1 + num2 = %d\n",num1);
  return 0;
}