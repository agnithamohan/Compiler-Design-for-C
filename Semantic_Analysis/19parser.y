%token<ival> INT LONG FLOAT CHAR DOUBLE VOID SHORT SIGNED UNSIGNED
%token<str> ID INTEGER REAL STRING
%token BREAK ELSE FOR IF RETURN  
%token ASSIGN_OP REL_OP ADD_OP MUL_OP INCDEC_OP EQU_OP  LAND LOR
%union{
		int ival;
		char *str;		
	}
%type<ival> type_spec descriptor decn_spec
%type<str> consttype exp

%{

#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<ctype.h>
int lineno;
#include "sym_const19.c"
int stack[100];
int index1=0;
int current_scope=0; 
//int g=0; 
int i=1; 
int end[100]; 
int aD=0;

char *t(int a); 
char *ret_type(int key, char *name);
char *returnparametertype(int key, char *name);

 
extern int comment_nesting;
int id=0; 
int flag = 0; 
int addr=100; 
char func_check[100][10];
int func_num=0; 
char const_type[10]; 
%}

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%right ASSIGN_OP '='
%left LOR
%left LAND
%left EQU_OP 
%left REL_OP 
%left ADD_OP 
%left MUL_OP 
%left INCDEC_OP  
%start start

%%

start
    :ext
    |start ext
    ;

ext
    :func_def
    |decn
    ;

decn 
    : decn_spec init_decr_list ';' 
    ;

decn_spec
    : type_spec   {	id=$1; }
    | descriptor type_spec {id=$1+$2; } 
    ;


type_spec
    : VOID
    | CHAR
    | SHORT
    | INT  
    | LONG 
    | FLOAT 
    | DOUBLE
    ;

descriptor
    :SIGNED
    |UNSIGNED
    |LONG
    |SHORT
    ; 

init_decr_list 
    : init_decr
    | init_decr_list ',' init_decr
    ;

init_decr
    : decr
    | decr '=' exp 
    | decr '=' STRING  {int key=hash_func($3);
			if(searchIncHash(key,$3)==0)
			insertTocHash(key,$3,"String");}
    ;   

decr
    : ID {		int key=hash_func($1);
			//if(searchInHash(key,$1)==0)
			
			insertToHash(key,$1,t(id),"NULL","NULL",addr,stack[index1-1],0,"NULL");
			insertToGHash(key,$1,t(id),"NULL","NULL",addr,stack[index1-1],0,"NULL");
			addr+=4; 	
	}
    | '(' decr ')'
    | ID b {		//aD=0; 
			int key=hash_func($1);
			//printf("%d", aD); 
			
			insertToHash(key,$1,t(id),"NULL","NULL",addr,stack[index1-1],aD,"NULL");
			insertToGHash(key,$1,t(id),"NULL","NULL",addr,stack[index1-1],aD,"NULL");
			aD=0; 
			addr+=4;}
    
    | func_decn
    ;

b  :'[' INTEGER ']' b   { //printf("HI");
				aD++; } 
    |  
    ;

func_decn
    : ID'(' type_spec ID ')'  
    | ID'(' ')' 
    ;

func_def 
    : decn_spec ID'('  ')' cmpnd_stmt { 
			int key=hash_func($2);
			//if(searchInHash(key,$2)==0)
			insertToHash(key,$2,"function",t($1),"NULL",addr,stack[index1-1],0,"NULL");
			insertToGHash(key,$2,"function",t($1),"NULL",addr,stack[index1-1],0,"NULL");
			addr+=4; 	
			if(strcmp(t($1),func_check[func_num-1])!=0)
			{
				printf("\nType Mismatch at line:%d", lineno); 


			}
			
		
	}
    | decn_spec ID'(' type_spec ID ')'  {int key=hash_func($5); 
			// printf("current %d  valll%d",current_scope,stack[index1-1]); 
			insertToHash(key,$5,t($4),"NULL","NULL",addr,current_scope,0,"NULL");
			insertToGHash(key,$5,t($4),"NULL","NULL",addr,current_scope,0,"NULL");
			}cmpnd_stmt {
			
			 int key=hash_func($2);
			 
			if(searchInHash(key,$2)==0)
			insertToHash(key,$2,"function",t($1),t($4),addr,stack[index1-1],0,$5);
			insertToGHash(key,$2,"function",t($1),t($4),addr,stack[index1-1],0,$5);
			addr+=4; 	
			if(strcmp(t($1),func_check[func_num-1])!=0)
			{
				printf("\nType Mismatch at line:%d", lineno); 


			}
			
	}

    
    ;


cmpnd_stmt
    :'{' stmt_list '}'
    |'{''}'
    ;

stmt_list
    :stmt_list stmt
    |stmt
    ;



stmt
    : cmpnd_stmt
    | exp_stmt
    | for_loop_stmt
    | if_else_stmt
    | jump_stmt
    | decn
    | error ';'
    ;



exp_stmt
    : ';'
    | ID ASSIGN_OP exp ';' {  	int key=hash_func($1);
				int k=hash_func($3);
				check(stack[index1-1], $1 , key);
				if(searchInHash(key,$1)==0)
				{printf("\nUndeclared variable at line:%d", lineno); }
			  
				/*if(strcmp(ret_type(key,$1),ret_type(k,$3))!=0)
				{
					printf("TypeMismatch at line:%d",lineno);
				}*/


			  }
    | ID'=' exp ';'       {  	int key=hash_func($1);
				int k=hash_func($3);
				check(stack[index1-1], $1 , key);
				if(searchInHash(key,$1)==0)
				{printf("\nUndeclared variable at line:%d", lineno); }

                         /*    if(strcmp(ret_type(key,$1),"string")!=0)
				{
					printf("TypeMismatch at line:%d",lineno);
				}  */

			    }
    | exp INCDEC_OP ';'
    | INCDEC_OP exp ';'
    | func_call
   ;

exp
    : exp REL_OP exp   
    | exp EQU_OP exp 
    | exp ADD_OP exp 
    | exp MUL_OP exp
    | exp LAND exp
    | exp LOR exp
    | exp INCDEC_OP
    | INCDEC_OP exp
    | '(' exp ')'
    | ID	{  	   //    $$=$1;

				 int key=hash_func($1);
				if(searchInHash(key,$1)==0)
				{printf("\nUndeclared variable at line:%d", lineno); }
				else 
				{check(stack[index1-1], $1 , key);}
				
			    }
    | consttype {	
			
			int key=hash_func($1);
			if(searchIncHash(key,$1)==0)
			insertTocHash(key,$1,"Constant");}
    | func_call
    | STRING {
			int key=hash_func($1);
			if(searchIncHash(key,$1)==0)
			insertTocHash(key,$1,"String");}
    
	
    ; 

consttype
    :INTEGER   { strcpy(const_type,"int"); }
    |REAL     { strcpy(const_type,"float"); }
    ;

func_call
    : ID'(' ')'		   {  	int key=hash_func($1);
				if(searchInHash(key,$1)==0)
				{printf("\nUndeclared function at line:%d", lineno); }
				if(strcmp(returnparametertype(key,$1),"void")!=0)
				{printf("\nType mismatch at line:%d", lineno); }
			    }
    | ID'(' ID ')'         { 
				int key=hash_func($1);
				if(searchInHash(key,$1)==0)
				{printf("\nUndeclared function at line:%d", lineno); }
				else 
				{
				int k=hash_func($3);
				if(strcmp(returnparametertype(key,$1),ret_type(k,$3))!=0)
				{printf("\nType mismatch at line:%d", lineno); }
			
			  }
			  }
    | ID'(' consttype ')' { 
				int key=hash_func($1);
				if(searchInHash(key,$1)==0)
				{printf("\nUndeclared function at line:%d", lineno); }
				else 
				{
				if(strcmp(returnparametertype(key,$1),const_type)!=0)
				{printf("\nType mismatch at line:%d", lineno); }
				}			  
			}
    |
    ;


if_else_stmt 
    : IF '(' exp ')' stmt  %prec LOWER_THAN_ELSE 
    | IF '(' exp ')' stmt ELSE stmt 
    ;



for_loop_stmt
    : FOR '(' exp_stmt exp_stmt ')' stmt
    | FOR '(' exp_stmt exp ';' exp ')' stmt
    ;

jump_stmt
    : BREAK ';'
    | RETURN ';'	{ 	strcpy(func_check[func_num],"void");
					
				func_num++; 
				 }
    | RETURN REAL ';'{ 		strcpy(func_check[func_num],"float");
				func_num++; 
				 }
    | RETURN INTEGER ';'{ 	strcpy(func_check[func_num],"int");
				func_num++; 
				 }
    | RETURN ID ';' {
			int key=hash_func($2);
			check(stack[index1-1], $2 , key);
			strcpy(func_check[func_num],ret_type(key,$2));
			func_num++;  }
    ;

%%

int yyerror()
{
    flag = 1;
    printf("PARSING ERROR at Line Number - %d\n",lineno);
    return (1);
}

char *ret_type(int key, char *name)
{
	 int hashIndex = key % eleCount, flag = 0;
	
		    char *rt = malloc(15);
        struct node *myNode;

        myNode = hashTable[hashIndex].head;

        if (!myNode) {


        	return flag;    
	
        }

        while (myNode != NULL) {

            if (strcmp(myNode->name,name)==0) {


                flag = 1; 
		strcpy(rt,myNode->type);

                break;

            }

            myNode = myNode->next;

        }

     
	if(flag==0)
	{
		printf("Undeclared variable at line%d:", lineno);  
	}
        return rt;



}

char *returnparametertype(int key, char *name)
{
	 int hashIndex = key % eleCount, flag = 0;
	
		    char *rt = malloc(15);
        struct node *myNode;

        myNode = hashTable[hashIndex].head;

        if (!myNode) {


        	return flag;    
	
        }

        while (myNode != NULL) {

            if (strcmp(myNode->name,name)==0) {


                flag = 1; 
		strcpy(rt,myNode->parametertype);

                break;

            }

            myNode = myNode->next;

        }

     
	if(flag==0)
	{
		printf("Parameter list mismatch at line:%d", lineno);  
	}
        return rt;



}

char *t(int a)
{
 
	    char *ty = malloc(15);	
	 
	switch(a) 
	{
		case 1: {strcpy(ty, "char");
			 return ty;
			}
		case 2:{strcpy(ty,"int");
			return ty;
			}
		
		case 3:{strcpy(ty,"float");
			return ty;
			}
		
		case 4:{strcpy(ty,"void");
			return ty;
			}
		
		case 5:{strcpy(ty,"double");
			return ty;
			}
		
		case 6:{strcpy(ty,"short");
			return ty;
			}
		
		case 7:{strcpy(ty,"long");
			return ty;
			}
		
		case 12:{strcpy(ty,"long double");
			return ty;
			}
		
		case 21:{strcpy(ty,"unsigned char");
			return ty;
			}	
		
		case 22:{strcpy(ty,"unsigned int");
			return ty;
			}
		
		case 26:{strcpy(ty,"unsigned short");
			return ty;
			}	
		
		case 27:{strcpy(ty,"unsigned long");
			return ty;
			}	
		
		case 31:{strcpy(ty,"signed char");
			return ty;
			}	

	}

}


void open1()
{
	//g++;
	stack[index1]=i;
	current_scope=i; 
	i++;
	index1++;
	return;
}
void close1()
{

	//g--; 	
	index1--;
	//end[stack[index1]]=1;
	//display(); 
	deleteValues(stack[index1]); 
	//display(); 
	stack[index1]=0;
	return;
}

void check(int currScope, char* name , int key)
{
	int hashIndex = key % eleCount, flag = 0;
	struct node *myNode;
        myNode = hashTable[hashIndex].head;
       
        while (myNode != NULL) 
	  {
            if (strcmp(myNode->name,name)==0) 
		{
		  int min=myNode->scope[0];
		  for(int z=0;z<myNode->tn;z++)
			{
			   if(myNode->scope[z]<=min)
				min=myNode->scope[z]; 
			}
		 if(currScope<min)  
			printf("Undeclared variable at line:%d", lineno); 
                }
            myNode = myNode->next;
          }
       
}


void main()
{
	//printf("STACKKK %d", stack[0]); 
    yyparse();
    if(comment_nesting!=0)
      {  printf("LEXICAL ERROR : Unterminated Comment\n");}

  	
    if(!flag)
    {
        printf("\nParsing successful!\n");
    }

	//display();	
	Gdisplay(); 	
	cdisplay();
return ;
}

	

