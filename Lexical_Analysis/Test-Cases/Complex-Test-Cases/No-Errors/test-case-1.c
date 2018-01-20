#include <stdio.h>

int count=0; 
int i, j; 
 
void find_prime(int n)
{
		for(i=2 ; i<=n ; i++)
	{
		count = 0;		
		for(j=1 ; j<=i ; j++) 
		{
			if(i%j==0)
				count++; 
		}
		
		if(count == 2)
			printf("\n %d is prime" , i); 
		else 
			printf("\n %d is composite", i); 

	}

}

void main()
{
	find_prime(10); 	
}
