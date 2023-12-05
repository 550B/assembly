#include <stdio.h>
int main()
{
  int x = 5, five_times_x = 0;
  asm ("leal (%1,%1,4), %0"
       : "=r" (five_times_x)
       : "r" (x) 
      );
  printf("five_times_x = %d\n",five_times_x);
  return 0;
}