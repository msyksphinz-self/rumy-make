#include <stdio.h>

extern void test2();

void test1 ()
{
  printf("Hello Test1\n");
}

int main ()
{
  test1();
  test2();
}
