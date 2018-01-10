/*program to calculate sum of first 
	n positive integers */


#include <stdio.h>


void main()
{
    int num, i, sum = 0;

    printf("Enter a positive integer: ");
    scanf("%d", &num);

    
    for(i = 1; i <= num; ++i)
    {
        sum += i;
    }

    printf("Sum = %d", sum); // prints calculated sum 

    return 0;
}

