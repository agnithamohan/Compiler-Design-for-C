int count=0; 
int i, j; 
 
void find_prime(int n)
{
    int flag;
		for(i=2 ; i<=n ; i++)
	{
		count = 0;		
		for(j=1 ; j<=i ; j++) 
		{
			if(i%j==0)
				count++; 
		}
		
		if(count == 2)
		   flag = 1;
		else 
			flag = 0;

	}

}
void main()
{
	find_prime(10); 	
}
