%{
	#include <stdio.h>

        #include <string.h>
 
        #include <stdlib.h>
	//int searchInHash(int key, char *name) ; 
	int top=-1;
	char a[100], err_id_str[20][10];
	int co_paranthesis=0, co_curly=0 , co_square=0 , co_comment=0 , co_quotes=0 , mul_line_comment=0 ;
 	int cc_paranthesis=0, cc_curly=0 , cc_square=0 , cc_comment=0 , err_comment=0 ;
 	int mismatch_paranthesis = 0 , mismatch_curly = 0 , mismatch_square = 0 , err_id=0 , no_of_errors=0; 
	 
%}
alpha [a-zA-Z]

digit [0-9]

keyword "printf"|"scanf"|"int"|"float"|"if"|"break"|"case"|"char"|"const"|"main"|"default"|"do"|"double"|"else"|"enum"|"float"|"for"|"goto"|"if"|"int"|"long"|"register"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while"

operator "+"|"-"|"*"|"/"|"%"|"++"|"--"|"="|"<"|">"|"&&"|"||"|"|"|"&"|"!" 

spl_symbols ";"

quotes ["]






%%
\n

#include[ ]?<{alpha}*.h> { 
	printf("\n\n\t%-30s is a Pre-processor directive\n",yytext); 
	 
}

,
" "
\t

"void main()"|"int main()" {
 printf("\n\t%-30s is the main function\n",yytext); 
	 
}



{alpha}({alpha}|{digit}|[_])*\(({alpha}|{digit}|[_]|[ ])*\) {

 printf("\n\t%-30s is a user defined function\n",yytext);
} 

"//".* {
	printf("\n\t%-30s is single line comment\n",yytext);
}

"/*"([^*]|\*+[^*/])*+"*/" {
     printf("\n\t%-30s is multi line comment\n",yytext);
}

{keyword} {
	
	printf("\n\t%-30s is a Keyword\n",yytext);
	int key=hash_func(yytext);
	if(searchInHash(key,yytext)==0)
	insertToHash(key,yytext,"keyword"); 	

}

{spl_symbols} {
	printf("\n\t%-30s is a Special Symbol\n",yytext);
	int key=hash_func(yytext);
	if(searchInHash(key,yytext)==0)
	insertToHash(key,yytext,"special symbol"); 	

}

{digit}+{alpha}+|{alpha}*{digit}*@{alpha}*{digit}*|%{alpha}{alpha}+ {
	strcpy(err_id_str[err_id],yytext);
	err_id++; 
}	

"(" {
	printf("\n\t%-30s is a Special Symbol\n",yytext);
	co_paranthesis++; 
	int key=hash_func(yytext);
	if(searchInHash(key,yytext)==0)
	insertToHash(key,yytext,"special symbol"); 	
	top++; 
	a[top]='('; 
}

"{" {
	printf("\n\t%-30s is a Special Symbol\n",yytext);
	co_curly++;
	int key=hash_func(yytext);
	if(searchInHash(key,yytext)==0)
	insertToHash(key,yytext,"special symbol"); 
	top++; 
	a[top]='{'; 
}

"[" {
	printf("\n\t%-30s is a Special Symbol\n",yytext);
	co_square++;
	int key=hash_func(yytext);
	if(searchInHash(key,yytext)==0)
	insertToHash(key,yytext,"special symbol"); 
	top++; 
	a[top]='['; 
}

")" {
	printf("\n\t%-30s is a Special Symbol\n",yytext);
	cc_paranthesis++; 
	if(a[top]!='(')
	  {
          mismatch_paranthesis=1; 
	}
	else
	   {top--;}
	int key=hash_func(yytext);
	if(searchInHash(key,yytext)==0)
	insertToHash(key,yytext,"special symbol"); 
}


"}" {
	printf("\n\t%-30s is a Special Symbol\n",yytext);
	cc_curly++;
	if(a[top]!='{')
	  {
          mismatch_curly=1;
	}
	else
	   {top--;}
	int key=hash_func(yytext);
	if(searchInHash(key,yytext)==0)
	insertToHash(key,yytext,"special symbol"); 
}

"]" {
	printf("\n\t%-30s is a Special Symbol\n",yytext);
	cc_square++;
	if(a[top]!='[')
	  {
          mismatch_square=1;
	}
	else
	   {top--;}
	int key=hash_func(yytext);
	if(searchInHash(key,yytext)==0)
	insertToHash(key,yytext,"special symbol"); 
}

{quotes} {
	printf("\n\t%-30s is a Special Symbol\n",yytext);
	co_quotes++; 
	int key=hash_func(yytext);
	if(searchInHash(key,yytext)==0)
	insertToHash(key,yytext,"special symbol"); 	

}

"/*" {  co_comment++;
	if(mul_line_comment==0)
	{mul_line_comment++;}
	else
	{err_comment=1;}

}

"*/" {  cc_comment++;
	if(mul_line_comment==1)
	{mul_line_comment--;}
	else
	{err_comment=1;}
}

{operator} {
	printf("\n\t%-30s is an Operator\n",yytext);
	int key=hash_func(yytext);	
	if(searchInHash(key,yytext)==0)	
	insertToHash(key,yytext,"operator"); 	
	}

{alpha}({alpha}|{digit})* {
	printf("\n\t%-30s is an Identifier\n",yytext); 
	int key=hash_func(yytext);
	if(searchInHash(key,yytext)==0)
	insertToHash(key,yytext,"identifier"); 	

}
{digit} {
	printf("\n\t%-30s is a Constant\n",yytext); 
	int key=hash_func(yytext);
	if(searchInHash(key,yytext)==0)
	insertToHash(key,yytext,"constant"); 	

}
	
\"(\\.|[^"\\])*\" {
	printf("\n\t%-30s is a String\n",yytext); 
	int key=hash_func(yytext);
	if(searchInHash(key,yytext)==0)
	insertToHash(key,yytext,"string"); 	

}
%%
    

/*---------------------------------------------------------------*/

	
     

    struct hash *hashTable = NULL;

    int eleCount = 0;

     

    struct node {

        
        char name[20];
	char type[20];
	int key;

        struct node *next;

    };

     

    struct hash {

        struct node *head;

        int count;

    };

     

    struct node * createNode(int key, char *name, char *type) {

        struct node *newnode;

        newnode = (struct node *) malloc(sizeof(struct node));

	newnode->key=key;
        strcpy(newnode->name, name);
	strcpy(newnode->type, type);

        newnode->next = NULL;

        return newnode;

    }

     

    void insertToHash(int key, char *name, char *type) {
	
        int hashIndex = key % eleCount;

        struct node *newnode = createNode(key, name, type);

       
      


  if (!hashTable[hashIndex].head) {

            hashTable[hashIndex].head = newnode;

            hashTable[hashIndex].count = 1;

            return;

        }




        
        newnode->next = (hashTable[hashIndex].head);

    

        hashTable[hashIndex].head = newnode;

        hashTable[hashIndex].count++;

        return;


    }

     

    
    int searchInHash(int key, char *name) {

        int hashIndex = key % eleCount, flag = 0;
	

        struct node *myNode;

        myNode = hashTable[hashIndex].head;

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

     

    void display() {

        struct node *myNode;

        int i;

	    printf("\n\n\n");
            printf("\t|------------------------------------------------------------------------|\n");

	    printf("\t|                                       |                                |\n");
            
            printf("\t|         Name                          |  	Type                     |\n");

            printf("\t|------------------------------------------------------------------------|\n");
	   
            printf("\t|                                       |                                |\n");


        for (i = 0; i < eleCount; i++) {

            if (hashTable[i].count == 0)

                continue;

            myNode = hashTable[i].head;

            if (!myNode)

                continue;

         
          
            while (myNode != NULL) {

                printf("\t|\t%-30s", myNode->name);

                printf("\t|\t%-15s\n", myNode->type);
            printf("\t|------------------------------------------------------------------------|\n");

          

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
	sum%=50;
	
	return sum; 
	}


void main(int argc[], char **argv[])
{

	//yyin=fopen("test.c","r"); 
	int n; 
	eleCount=50;
	 hashTable = (struct hash *) calloc(50, sizeof(struct hash)); 
	
	yylex();
	
	printf("\n\n\n\n\t\t\t\t\t   ERRORS");
	printf("\n\t__________________________________________________________________________\n"); 

	if(co_paranthesis!=cc_paranthesis)
	{no_of_errors++;
	printf("\n\t%d)---------------------UNMATCHED ( !!!-------------\n",no_of_errors);}
	if(co_curly!=cc_curly)
	{no_of_errors++;
	printf("\n\t%d)---------------------UNMATCHED { !!!-------------\n",no_of_errors);}
 	if(co_square!=cc_square)
	{no_of_errors++;
	printf("\n\t%d)---------------------UNMATCHED [ !!!-------------\n",no_of_errors);}
	if(co_quotes%2!=0)
	{no_of_errors++;
	printf("\n\t%d)---------------------UNMATCHED QUOTES !!!-------------\n",no_of_errors);}
	if(co_comment!=cc_comment)
	{no_of_errors++;
	printf("\n\t%d)---------------------UNMATCHED MULTI_LINE COMMENT!!!-------------\n",no_of_errors);}
	if(err_comment==1)
	{no_of_errors++;
	printf("\n\t%d)---------------------NESTED MULTI_LINE COMMENT!!!-------------\n",no_of_errors);}	
	if(mismatch_paranthesis==1) 
	{no_of_errors++;
	printf("\n\t%d)---------------------MISMATCHED PARANTHESES!!!-------------\n",no_of_errors);}	
	if(mismatch_curly==1) 
	{no_of_errors++;
	printf("\n\t%d)---------------------MISMATCHED CURLY BRACES!!!-------------\n",no_of_errors);}	
	if(mismatch_square==1) 
	{no_of_errors++;
	printf("\n\t%d)---------------------MISMATCHED SQUARE BRACES!!!-------------\n",no_of_errors);}	
	if(err_id>0)
	{
	for (int i =0 ; i< err_id ; i++)
	{	
		no_of_errors++;
		printf("\n\t%d)---------------------INVALID IDENTIFIER!!![-%s]-------------\n",no_of_errors,err_id_str[i]);	
	}	
	}
	if(no_of_errors==0)
		printf("\n\tNO LEXICAL ERRORS!"); 
	
	printf("\n\n\n\n\t\t\t\t\tSYMBOL TABLE");
	printf("\n\t__________________________________________________________________________"); 

	
	display();

	printf("%d%d",co_comment, cc_comment); 
	
}
     

int yywrap()
{
	return 1; 
}


  
