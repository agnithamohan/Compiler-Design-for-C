%{ 
 	#include <stdio.h>
	extern int yylineno;
	
	#include<ctype.h>
	

%}


%nonassoc  ELSE 
%left '<' '>' '=' GE_OP LE_OP EQ_OP NE_OP 
%left  '+'  '-'
%left  '*'  '/' '%'

%token ID CONSTANT STRING 
%token INC_OP DEC_OP LE_OP GE_OP EQ_OP NE_OP 
%token AND_OP OR_OP 
%token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE VOID 
%token MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN SUB_ASSIGN 
%token IF ELSE FOR BREAK RETURN DEF
%token LEFT_OP RIGHT_OP
%start START 
%glr-parser

%%

START
	: global_declaration
	| START global_declaration
	| START define 
	;

global_declaration
	: function_definition
	| declaration 
	;

define 
	: DEF
	;

function_definition
	: type ID '(' argument_list ')' ';'
	| type ID '(' argument_list ')' '{' compound_statements '}' 
	;

type
	: type_specifier type 
	| INT
	| FLOAT
	| CHAR
	| VOID
	| DOUBLE
	;

argument_list 
	: type ID
	| type ID ',' argument_list  
	|
	;

type_specifier 
	: LONG 
	| SHORT 
	| SIGNED type_specifier
	| UNSIGNED type_specifier
	|
	;

declaration 
	: type identifier ';'
	| type initializer ';'
	;

identifier 
	: ID 
	| ID ',' identifier 
	| ID ',' initializer
	;

initializer
	: ID '=' CONSTANT 
	| ID '=' CONSTANT ',' initializer
	| ID '=' CONSTANT ',' identifier	
	;

compound_statements
	: '{' '}'
	;

compound_statements
	: '{' '}'
	| '{' statements '}'
	| '{' declaration '}'
	| '{' declaration statements '}'
	;

statements
	: stmt
	| statements stmt 
	;


stmt
	: compound_statements
	| expressions
	| if_else
	| for
	| jump_stmts
	;

expressions
	: ';'	
	| declaration
	| initializer
	| relational_expression ';'
	| arithmetic_expression	';'
	| assignment_expression ';'
;

if_else 
	: IF '(' expressions ')' stmt
	| IF '(' expressions ')' stmt ELSE stmt 
	|	
	;

for	
	: FOR '('arg1 ';' arg2 ';' arg3 ')' stmt 
	| FOR '('arg1 ';' arg2 ';' ')' stmt 
	;
 arg1
	:
	declaration 
	|initializer 
	;

arg2
	: relational_expression 
	| relational_expression AND_OP relational_expression
	| relational_expression OR_OP relational_expression
	;

arg3 
	: assignment_expression 
	;


jump_stmts
	: BREAK ';'
	| RETURN ';'
	| RETURN expressions ';'
	;

relational_expression 
	: LHS relational_operator RHS
	| relational_expression AND_OP relational_expression
	| relational_expression OR_OP relational_expression
	;

LHS
	: 
	ID
	| CONSTANT
	;

RHS	:
	ID
	| CONSTANT
	;

relational_operator
	:'<'
	|'>'
	| LE_OP
	| GE_OP			
	| EQ_OP
	| NE_OP
;



arithmetic_expression 
	:LHS arithmetic_operator RHS
	|ID '=' arithmetic_operator
	;

arithmetic_operator
	:'+'
	|'-'
	|'*'
	|'/'
	|'%'
;
	
assignment_expression
	: ID INC_OP
	| INC_OP ID
	| ID DEC_OP 
	| DEC_OP ID
	| ID assignment_operator CONSTANT
	| ID assignment_operator CONSTANT
;

assignment_operator 
	:'='
	| MUL_ASSIGN
	| DIV_ASSIGN
	| MOD_ASSIGN
	| ADD_ASSIGN
	| SUB_ASSIGN
;
	
%%

int main(int argc, char *argv[])
{
	if(!yyparse())
		printf("\nParsing complete\n");
	else
		printf("\nParsing failed\n");
	return 0;
}
extern char *yytext;
yyerror(char *s) {
	printf("\nLine %d : %s\n", (yylineno), s);
}  
