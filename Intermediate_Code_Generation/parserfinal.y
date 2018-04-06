%token<ival> INT LONG FLOAT CHAR DOUBLE VOID SHORT SIGNED UNSIGNED
%token<str> INCDEC_OP ID INTEGER REAL STRING  REL_OP  MUL_OP  EQU_OP  LAND LOR
%token<str> ASSIGN_OP  ADD_OP
%token BREAK ELSE FOR IF RETURN WHILE DO
 
%union{
		int ival;
		char *str;		
	}
%type<ival> type_spec descriptor decn_spec
%type<str> consttype exp E3 E2 E1 E4 F T

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
int lnum=0;
int top=0; 
int label[20];
int ltop=0;
char st1[100][10];
char i_[2]="0";
char temp[2]="t";
char null[2]=" "; 

void if_1()
{
	lnum++;
	strcpy(temp,"t");
	strcat(temp,i_);
	printf("%s = not %s\n",temp,st1[top]);
 	printf("if %s goto L%d\n",temp,lnum);
	i_[0]++;
	label[++ltop]=lnum;	
	
}
void if_2()
{
	lnum++;
	printf("goto L%d\n",lnum);
	printf("L%d: \n",label[ltop--]);
	label[++ltop]=lnum;
}
void if_3()
{
	printf("L%d:\n",label[ltop--]);
}


void for_1()
{
	lnum++;
	label[++ltop]=lnum;
	printf("L%d:\n",lnum);
}
void for_2()
{
	lnum++;
	strcpy(temp,"t");
	strcat(temp,i_);
	printf("%s = not %s\n",temp,st1[top--]);
 	printf("if %s goto L%d\n",temp,lnum);
	i_[0]++;
	label[++ltop]=lnum;
	lnum++;
	printf("goto L%d\n",lnum);
	label[++ltop]=lnum;
	lnum++;
	printf("L%d:\n",lnum);	
	label[++ltop]=lnum;
}
void for_3()
{
	printf("goto L%d\n",label[ltop-3]);
	printf("L%d:\n",label[ltop-1]);
}
void for_4()
{
	printf("goto L%d\n",label[ltop]);
	printf("L%d:\n",label[ltop-2]);
	ltop-=4;
}


void while_1()
{
	lnum++;
	label[++ltop]=lnum;
	printf("L%d:\n",lnum);
}
void while_2()
{
	lnum++;
	strcpy(temp,"t");
	strcat(temp,i_);
	printf("%s = not %s\n",temp,st1[top--]);
 	printf("if %s goto L%d\n",temp,lnum);
	i_[0]++;
	label[++ltop]=lnum;
}
void while_3()
{
	int y=label[ltop--];
	printf("goto L%d\n",label[ltop--]);
	printf("L%d:\n",y);
}

void dowhile_1()
{
	lnum++;
	label[++ltop]=lnum;
	printf("L%d:\n",lnum);
}
void dowhile_2()
{
 	printf("if %s goto L%d\n",st1[top--],label[ltop--]);
}
void push(char *a)
{
	strcpy(st1[++top],a);
}
void codegen()
{
	strcpy(temp,"t");
	strcat(temp,i_);
	printf("%s = %s %s %s\n",temp,st1[top-2],st1[top-1],st1[top]);
	top-=2;
	strcpy(st1[top],temp);
	i_[0]++;
}

void codegen_assign()
{
	//printf("HII"); 
	printf(" %s = %s\n",st1[top-2],st1[top]);
	top-=2;
}

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
    | decr '='{strcpy(st1[++top],"=");}E1{codegen_assign();}
    ;   

decr
    : ID {		push($1); 
			int key=hash_func($1);

			
			insertToHash(key,$1,t(id),"NULL","NULL",addr,stack[index1-1],0,"NULL");
			insertToGHash(key,$1,t(id),"NULL","NULL",addr,stack[index1-1],0,"NULL");
			addr+=4; 	
	}
    | '(' decr ')'
    | ID b {	
			int key=hash_func($1);

			
			insertToHash(key,$1,t(id),"NULL","NULL",addr,stack[index1-1],aD,"NULL");
			insertToGHash(key,$1,t(id),"NULL","NULL",addr,stack[index1-1],aD,"NULL");
			aD=0; 
			addr+=4;}
    
    | func_decn
    ;

b  :'[' INTEGER ']' b   { 
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

			insertToHash(key,$2,"function",t($1),"NULL",addr,stack[index1-1],0,"NULL");
			insertToGHash(key,$2,"function",t($1),"NULL",addr,stack[index1-1],0,"NULL");
			addr+=4; 	
			if(strcmp(t($1),func_check[func_num-1])!=0)
			{
				printf("\nType Mismatch at line:%d", lineno); 


			}
			
		
	}
    | decn_spec ID'(' type_spec ID ')'  {int key=hash_func($5); 
 
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
    | for
    | if
    | while
    | dowhile
    | jump_stmt
    | decn
    | error ';'
    ;




exp_stmt
    : ';'
    | E4
    | E3
    | func_call
   ;


exp
    : 
    | E1
    | E2
    | E3
    | E4
    | func_call
    ; 

consttype
    :INTEGER   { strcpy(const_type,"int"); }
    |REAL     { strcpy(const_type,"float"); }
    ;

func_call
    : ID'(' ')'		   {  	int key=hash_func($1);
				if(searchInHash(key,$1)==0)
				{printf("\n1Undeclared function at line: %d", lineno); }
				if(strcmp(returnparametertype(key,$1),"void")!=0)
				{printf("\nType mismatch at line:%d", lineno); }
			    }
    | ID'(' ID ')'         { 
				int key=hash_func($1);
				if(searchInHash(key,$1)==0)
				{printf("\n2Undeclared function at line:%d", lineno); }
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
				{printf("\n3Undeclared function at line:%d", lineno); }
				else 
				{
				if(strcmp(returnparametertype(key,$1),const_type)!=0)
				{printf("\nType mismatch at line:%d", lineno); }
				}			  
			}
    |
    ;

E1 : E1 ADD_OP{strcpy(st1[++top],$2);} T {codegen();} 
   | T
   ;

E2 : E1  EQU_OP{strcpy(st1[++top],$2);} E1 {codegen();}  
   | E1  REL_OP{strcpy(st1[++top],$2);} E1 {codegen();} 	
   ; 

E3 : INCDEC_OP ID{
				push($2);
				if(strcmp($1,"++")==0)				
					strcpy(st1[++top],"+");
				else 
					strcpy(st1[++top],"-");
				push("1"); 
		         	int key=hash_func($2);
				if(searchInHash(key,$2)==0)
				{printf("\n4Undeclared variable at line:%d", lineno); }
				else 
				{check(stack[index1-1], $2 , key);}
				codegen(); 
				
			    }
   | ID ADD_OP consttype{	
				push($1); 

				strcpy(st1[++top],$2);			
				push($3);  	   
				 int key=hash_func($1);
				if(searchInHash(key,$1)==0)
				{printf("\n5Undeclared variable at line:%d", lineno); }
				else 
				{check(stack[index1-1], $1 , key);}

				int k=hash_func($3);
				if(searchIncHash(k,$3)==0)
				insertTocHash(k,$3,"Constant");
				codegen(); 			
			}
				
			    
   | ID ASSIGN_OP consttype   {  	  push($1); 

				strcpy(st1[++top],$2);			
				push($3);  	   
				 
				 push($3);  	   
				 int key=hash_func($1);
				if(searchInHash(key,$1)==0)
				{printf("\n6Undeclared variable at line:%d", lineno); }
				else 
				{check(stack[index1-1], $1 , key);}

			int k=hash_func($3);
			if(searchIncHash(k,$3)==0)
			insertTocHash(k,$3,"Constant");
			codegen(); 
			}
				
			    
   | ID ASSIGN_OP ID   {  	 
				push($1); 
				 	
				strcpy(st1[++top],$2);			
				push($3);  	   
				

				 int key=hash_func($1);
				if(searchInHash(key,$1)==0)
				{printf("\n7Undeclared variable at line:%d", lineno); }
				else 
				{check(stack[index1-1], $1 , key);}
                               
				 int k=hash_func($3);
				if(searchInHash(k,$3)==0)
				{printf("\n8Undeclared variable at line:%d", lineno); }
				else 
				{check(stack[index1-1], $3 , k);}
							codegen(); 
			
				
			    }
    |ID INCDEC_OP {		push($1);	
				if(strcmp($2,"++")==0)				
					strcpy(st1[++top],"+");
				else 
					strcpy(st1[++top],"-");
				push("1"); 				
				int key=hash_func($1);
				if(searchInHash(key,$1)==0)
				{printf("\n9Undeclared variable at line:%d", lineno); }
				else 
				{check(stack[index1-1], $2 , key);}
							codegen(); 			
				
			    }
	;
 
T  : T MUL_OP {strcpy(st1[++top],$2);	} F{ codegen(); }
   | F
   ;

F  : '(' E1 ')'   
   | ID {			push($1);

		 	 int key=hash_func($1);
				if(searchInHash(key,$1)==0)
				{printf("\n10Undeclared variable at line:%d", lineno); }
				else 
				{check(stack[index1-1], $1 , key);	 }
				
			    }
   | consttype	 {	
			push($1);
			int key=hash_func($1);
			if(searchIncHash(key,$1)==0)
			insertTocHash(key,$1,"Constant");}
   | STRING  {strcpy(st1[++top],"=");
			int key=hash_func($1);
			if(searchIncHash(key,$1)==0)
			insertTocHash(key,$1,"String");
			codegen_assign(); }
   ;

E4	:ID{push($1);} '='{strcpy(st1[++top],"=");} E1  {  	   	 
				
				

				 int key=hash_func($1);
				if(searchInHash(key,$1)==0)
				{printf("\n15Undeclared variable at line:%d", lineno); }
				else 
				{check(stack[index1-1], $1 , key);}
				codegen_assign(); 
				}
	;
	
 if
	: IF '(' exp ')' {if_1();} cmpnd_stmt {if_2();} else
	;


else    : ELSE cmpnd_stmt {if_3();}
	| 
	;


for	: FOR '(' E4 {for_1();} ';' E2 {for_2();}';' E3 {for_3();} ')' cmpnd_stmt {for_4();}
	;


while   : WHILE {while_1();}'(' E2 ')' {while_2();} cmpnd_stmt {while_3();}
	;

dowhile : DO {dowhile_1();} cmpnd_stmt WHILE '(' E2 ')' {dowhile_2();} ';'


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

	stack[index1]=i;
	current_scope=i; 
	i++;
	index1++;
	return;
}
void close1()
{

	 	
	index1--;
	
	deleteValues(stack[index1]); 
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
	
    yyparse();
    if(comment_nesting!=0)
      {  printf("LEXICAL ERROR : Unterminated Comment\n");}

  	
    if(!flag)
    {
        printf("\nParsing successful!\n");
    }

	
	Gdisplay(); 	
	cdisplay();
return ;
}

	

