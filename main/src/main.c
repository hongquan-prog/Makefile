#include "stdio.h"
#include "common.h"
#include "test.h"

int main()
{
    printf("main module\n");
    func();
    common();
    printf("lib name:%s\n",name());
    printf("2 + 3 = %d\n", add(2,3));
}