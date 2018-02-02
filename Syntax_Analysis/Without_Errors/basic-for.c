/*program to calculate factorial of  
	a positive integer */


#include <stdio.h>


void main()
{
    int num, i, value = 1;

    printf("Enter a positive integer: ");
    scanf("%d", &num);

    
    for(i = 1; i <= num; ++i)
    {
        value *= i;
    }

    printf("Facorial of %d is %d", num,value); // prints calculated factorial  

    return 0;
}

