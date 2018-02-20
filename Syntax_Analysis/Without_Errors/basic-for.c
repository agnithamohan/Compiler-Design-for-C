/*program to calculate factorial of  
	a positive integer */


#include <stdio.h>


void main()
{
    int num, i, value = 1;

    num=10; 
    
    for(i = 1; i <= num; ++i)
    {
        value *= i;
    }

    
    return 0;
}
