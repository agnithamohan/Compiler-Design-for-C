int eleCount=50;
	
struct node 
{
        char name[20];
	char type[10][20];
	int tn; 	
	int key;
	char returntype[20];
	int parametertype[20];
	int addr;
	float fvalue;
	int scope[10];
	struct node *next;
	int arrDim; 
	char parameterList[20]; 

};

	
struct Cnode 
{
        char name[20];
	char type[20];
	int key;
	struct node *next;

};

struct hash 
{
	struct node *head;
        int count;
};

struct hash hashTable[50]; 
struct hash GhashTable[50]; 
struct hash chashTable[50];

struct node * createNode(int key, char *name, char *type, char *ret, char* param, int addr,int scope,int arrDim, char *parameterList) 
{
	struct node *newnode;
        newnode = (struct node *) malloc(sizeof(struct node));
	newnode->scope[0]=scope;
	newnode->key=key;
	newnode->tn=1;
        strcpy(newnode->name, name);
	strcpy(newnode->type[0], type);
	strcpy(newnode->returntype, ret);
	strcpy(newnode->parametertype, param);
	newnode->arrDim=arrDim; 
	strcpy(newnode->parameterList,parameterList); 
	newnode->addr=addr; 
        newnode->next = NULL;
        return newnode;
}

   

void insertToHash(int key, char *name, char *type, char *ret, char *param, int addr, int scope,int arrDim, char *parameterList) 
{	
	
        int hashIndex = key % eleCount;	
  	 if(searchInHash(key,name)==0)
  	    {
       		struct node *newnode = createNode(key, name, type,ret,param,addr,scope,arrDim,parameterList);	
		 if (!hashTable[hashIndex].head) 
		    {
          		 hashTable[hashIndex].head = newnode;
        		 hashTable[hashIndex].count = 1;
         		  return;
      		    }
 
      		 newnode->next = (hashTable[hashIndex].head);
       		 hashTable[hashIndex].head = newnode;
       		 hashTable[hashIndex].count++;
       		 return;
            } 
         else
  	   {
       		 struct node *myNode;
      	         myNode = hashTable[hashIndex].head;
       	         while (myNode != NULL) 
		  {
          	    if (strcmp(myNode->name,name)==0) 
			{
			  
			   int min=0; 
			   for(int z=0; z<myNode->tn; z++)
			 	if(myNode->scope[z]<=min)
				min=myNode->scope[z]; 
				if(scope<min)
			   {
		  	   strcpy(myNode->type[myNode->tn],type); 
			   myNode->scope[myNode->tn]=scope;
		 	   myNode->tn++; 
			    } 
			else 
			printf("\nRedeclaration of variable at line %d",lineno); 
			
               	        }
                    myNode = myNode->next;
                 }
	    }
}
 


void insertToGHash(int key, char *name, char *type, char *ret, char *param, int addr, int scope,int arrDim,char *parameterList) 
{	
	 
        int hashIndex = key % eleCount;	
  	 if(searchInGHash(key,name)==0)
  	    {
       		struct node *newnode = createNode(key, name, type,ret,param,addr,scope,arrDim,parameterList);	
		 if (!GhashTable[hashIndex].head) 
		    {
          		 GhashTable[hashIndex].head = newnode;
        		 GhashTable[hashIndex].count = 1;
         		  return;
      		    }
 
      		 newnode->next = (GhashTable[hashIndex].head);
       		 GhashTable[hashIndex].head = newnode;
       		 GhashTable[hashIndex].count++;
       		 return;
            } 
         else
  	   {
       		 struct node *myNode;
      	         myNode = GhashTable[hashIndex].head;
       	         while (myNode != NULL) 
		  {
          	    if (strcmp(myNode->name,name)==0) 
			{
			  
			   int min=0; 
			   for(int z=0; z<myNode->tn; z++)
			 	if(myNode->scope[z]<=min)
				min=myNode->scope[z]; 
				if(scope<min)
			   {
		  	   strcpy(myNode->type[myNode->tn],type); 
			   myNode->scope[myNode->tn]=scope;
		 	   myNode->tn++; 
			    } 
			
               	        }
                    myNode = myNode->next;
                 }
	    }
}



struct node * createCNode(int key, char *name, char *type)
{
	struct Cnode *newnode;
        newnode = (struct Cnode *) malloc(sizeof(struct Cnode));
	newnode->key=key;
        strcpy(newnode->name, name);
	strcpy(newnode->type, type);
        newnode->next = NULL;
        return newnode;
}
     
    
int searchInHash(int key, char *name)
{
	int hashIndex = key % eleCount, flag = 0;
	struct node *myNode;
        myNode = hashTable[hashIndex].head;
        if (!myNode) 
	  {
	    return flag;   
          }
        while (myNode != NULL) 
	  {
            if (strcmp(myNode->name,name)==0) 
		{
		   flag = 1;
             	   break;
                }
            myNode = myNode->next;
          }
        return flag;
}

     

int searchInGHash(int key, char *name)
{
	int hashIndex = key % eleCount, flag = 0;
	struct node *myNode;
        myNode = GhashTable[hashIndex].head;
        if (!myNode) 
	  {
	    return flag;   
          }
        while (myNode != NULL) 
	  {
            if (strcmp(myNode->name,name)==0) 
		{
		   flag = 1;
             	   break;
                }
            myNode = myNode->next;
          }
        return flag;
}

     

void deleteValues(int del)
{

	struct node *myNode; 
	
	
        for (int i = 0; i < eleCount; i++) {

            if (hashTable[i].count == 0)

                continue;

            myNode = hashTable[i].head;

            if (!myNode)

                continue;

         
          
            while (myNode != NULL) {
		
		if(myNode->tn==1 && myNode->scope[0]==del)
		{
			//display();
			deleteFromHash(myNode->key , myNode->name);  
			//display();
		}
		else 
		{
                for(int z=0; z<myNode->tn;z++)
		{
          		if(myNode->scope[z]==del)
			{
				//shift and delete 	
				myNode->tn--; 
			}
		}
		if (myNode->tn==0) 
			{/*delete the node */}
		}
                myNode = myNode->next;

            }

        }

}

    void display() {

        struct node *myNode;

        
	    printf("\n\n                                  SYMBOL TABLE");

	    printf("\n\n\n");
            printf("\t|---------------------------------------------------------------------------------------------------------------|\n");

	    printf("\t|       |               |          |              |               |               |               |        |\n");
            
            printf("\t| Key   |     Name      |Type      |   returntype | parametertype |  arrDim      |   Scope       |   tn    | PList\n");

            printf("\t|---------------------------------------------------------------------------------------------------------------|\n");
	   
           // printf("\t|                                       |                                |\n");


        for (int i = 0; i < eleCount; i++) {

            if (hashTable[i].count == 0)

                continue;

            myNode = hashTable[i].head;

            if (!myNode)

                continue;

         
          
            while (myNode != NULL) {

                printf("\t|%-7d", myNode->key);

                printf("|%-6s", myNode->name);

		 printf("\t\t|%-10s", myNode->type[0]);

		 printf("|\t%-10s", myNode->returntype);

		 printf("|\t%-10s", myNode->parametertype);

		 printf("|\t%-10d", myNode->arrDim);

		printf("|\t%-10d", myNode->scope[0]);

		printf("|\t%-4d|", myNode->tn);

		 printf("|\t%-10s", myNode->parameterList);
            printf("\n\t|-----------------------------------------------------------------------------------------------------------|\n");

          

                myNode = myNode->next;

            }

        }

        return;

    }


	int hash_func(char val[20])
	{
	int sum=0;
	for(int i=0; i<strlen(val);i++)
	{
		sum+=val[i]; 
	}
	//sum%=50;
	
	return sum; 
	}

 void insertTocHash(int key, char *name, char *type) {
	
        int hashIndex = key % eleCount;

        struct node *newnode = createCNode(key, name, type);

       
      


  if (!chashTable[hashIndex].head) {

            chashTable[hashIndex].head = newnode;

            chashTable[hashIndex].count = 1;

            return;

        }




        
        newnode->next = (chashTable[hashIndex].head);

    

        chashTable[hashIndex].head = newnode;

        chashTable[hashIndex].count++;

        return;


    }

     

    
    int searchIncHash(int key, char *name) {

        int hashIndex = key % eleCount, flag = 0;
	

        struct node *myNode;

        myNode = chashTable[hashIndex].head;

        if (!myNode) {


        	return flag;    
	
        }

        while (myNode != NULL) {

            if (strcmp(myNode->name,name)==0) {


                flag = 1;

                break;

            }

            myNode = myNode->next;

        }

     
        return flag;

    }

     

    void cdisplay() {

        struct Cnode *myNode;

        
	
	    printf("\n\n                                 CONSTANT TABLE");

	    printf("\n\n\n");
            printf("\t|------------------------------------------------------------------------|\n");

	    printf("\t|                                       |                                |\n");
            
            printf("\t|         Constant                      |  	Type                     |\n");

            printf("\t|------------------------------------------------------------------------|\n");
	   
            //printf("\t|                                       |                                |\n");


        for (int i = 0; i < eleCount; i++) {

            if (chashTable[i].count == 0)

                continue;

            myNode = chashTable[i].head;

            if (!myNode)

                continue;

         
          
            while (myNode != NULL) {

                printf("\t|\t%-30s", myNode->name);

                printf("\t|\t%-25s|\n", myNode->type);
            printf("\t|------------------------------------------------------------------------|\n");

          

                myNode = myNode->next;

            }

        }

        return;

    }

int chash_func(char val[20])
{
	int sum=0;
	for(int i=0; i<strlen(val);i++)
	{
		sum+=val[i]; 
	}
	sum%=50;
	
	return sum; 
}


void deleteFromHash(int key , char *name ) {
        int hashIndex = key % eleCount, flag = 0;
        struct node *temp, *myNode;
        myNode = hashTable[hashIndex].head;
        if (!myNode) {
                printf("Given data is not present in hash Table!!\n");
                return;
        }
        temp = myNode;
        while (myNode != NULL) {
                /* delete the node with given key */
                if (myNode->key == key && myNode->name==name) {
                        flag = 1;
                        if (myNode == hashTable[hashIndex].head)
                                hashTable[hashIndex].head = myNode->next;
                        else
                                temp->next = myNode->next;

                        hashTable[hashIndex].count--;
                        free(myNode);
                        break;
                }
                temp = myNode;
                myNode = myNode->next;
        }
       /* if (flag)
                printf("Data deleted successfully from Hash Table\n");
        else
                printf("Given data is not present in hash Table!!!!\n");*/
        return;
  }


 void Gdisplay() {

        struct node *myNode;

        
	    printf("\n\n                            G     SYMBOL TABLE");

	    printf("\n\n\n");
            printf("\t|------------------------------------------------------------------------------------------------- |\n");

	    printf("\t|       |               |          |              |               |               |                |    \n");
            
            printf("\t| Key   |     Name      |Type      |   returntype | parameterList |  arrDim       |   Scope        | \n");

            printf("\t|--------------------------------------------------------------------------------------------------|\n");
	   
           // printf("\t|                                       |                                |\n");


        for (int i = 0; i < eleCount; i++) {

            if (GhashTable[i].count == 0)

                continue;

            myNode = GhashTable[i].head;

            if (!myNode)

                continue;

         
          
            while (myNode != NULL) {

                printf("\t|%-7d", myNode->key);

                printf("|%-6s", myNode->name);

		 printf("\t\t|%-10s", myNode->type[0]);

		 printf("|\t%-10s", myNode->returntype);

		 printf("|\t%-10s", myNode->parameterList);

		 printf("|\t%-10d", myNode->arrDim);

		printf("|\t%-10d", myNode->scope[0]);

		//printf("|\t%-4d|", myNode->tn);

		
            printf("\n\t|--------------------------------------------------------------------------------------------------|\n");

          

                myNode = myNode->next;

            }

        }

        return;

    }



