%token BREAK CHAR  DOUBLE ELSE FLOAT FOR IF INT LONG RETURN SHORT SIGNED UNSIGNED VOID
%token ID CONSTANT STRING ASSIGN_OP REL_OP ADD_OP MUL_OP INCDEC_OP EQU_OP  LAND LOR

%{
#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>

 int lineno;
extern int comment_nesting;

int flag = 0; 
extern void display();
extern void cdisplay();
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
    : type_spec 
    | type_spec decn_spec
    ;


type_spec
    : VOID
    | CHAR
    | SHORT
    | INT
    | LONG
    | FLOAT
    | DOUBLE
    | SIGNED
    | UNSIGNED
    ;

init_decr_list 
    : init_decr
    | init_decr_list ',' init_decr
    ;

init_decr
    : decr
    | decr '=' exp
    | decr '=' STRING
    ;   

decr
    : ID 
    | '(' decr ')'
    | func_decn
    ;

func_decn
    : ID'(' decn_spec_list ')' 
    | ID'(' ')' 
    ;

func_def 
    : decn_spec ID'('  ')' cmpnd_stmt
    | decn_spec ID'(' def_spec_list ')' cmpnd_stmt
    ;


decn_spec_list
    : decn_spec_list ',' decn_spec 
    | decn_spec
    ;

def_spec_list
    :var_decn 
    | def_spec_list ',' var_decn
    ;
var_decn
    :decn_spec ID
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
    | exp ';'
    ;

exp
    : ID ASSIGN_OP exp 
    | ID'=' exp 
    | exp EQU_OP exp
    | exp REL_OP exp
    | exp ADD_OP exp
    | exp MUL_OP exp
    | exp LAND exp
    | exp LOR exp
    | exp INCDEC_OP
    | INCDEC_OP exp
    | '(' exp ')'
    | ID
    | CONSTANT 
    | func_call
    ; 

func_call
    : ID'(' ')'
    | ID'(' exp_list ')'
    ;

exp_list
    : exp_list ',' exp
    | exp
    ;



if_else_stmt 
    : IF '(' exp ')' stmt  %prec LOWER_THAN_ELSE 
    | IF '(' exp ')' stmt ELSE stmt 
    ;



for_loop_stmt
    : FOR '(' exp_stmt exp_stmt ')' stmt
    | FOR '(' exp_stmt exp_stmt exp ')' stmt
    ;

jump_stmt
    : BREAK ';'
    | RETURN ';'
    | RETURN exp 
    ;

%%

int yyerror()
{
    flag = 1;
    printf("PARSING ERROR at Line Number - %d\n",lineno);
    return (1);
}

main()
{

    yyparse();
    if(comment_nesting!=0)
        printf("LEXICAL ERROR : Unterminated Comment\n");

  	
    if(!flag)
    {
        printf("\nParsing successful!\n");
    }

	display();	
	cdisplay();
}

