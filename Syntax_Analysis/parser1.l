%{
	#include <stdio.h>

        #include <string.h>
 
        #include <stdlib.h>

	#include "y.tab.h"
	
	int yylineno;
	
%}
alpha [a-zA-Z]

digit [0-9]

%%

\n    { yylineno++; }

"//".* {}

"/*"([^*]|\*+[^*/])*+[\n]+"*/" {}

" "

\t

#include[ ]?<{alpha}*.h> {}

#define[ ]({alpha}+|{alpha}({alpha}|{digit})*)[ ]({digit}+[.]?{digit}*|\"{alpha}*\") {return DEF;}

"int"	     		{return INT;}

"float"			{return FLOAT;}

"if"			{return IF;}

"break"			{return BREAK;}

"char" 			{return CHAR;}

"double"		{return DOUBLE;}

"else"			{return ELSE;}

"for"			{return FOR;}

"long"			{return LONG;}

"return" 		{return RETURN;}

"short"			{return SHORT;}

"signed"		{return SIGNED;}

"unsigned"		{return UNSIGNED;}

"void"			{return VOID;}

"{"			{return ('{');}

"}"			{return ('}');}

"("			{return ('(');}


")"			{return (')');}

"["			{return ('[');}

"]"			{return (']');}

";"			{return (';');}

":"			{return (':');}

"," 			{return (',');}

{digit}*		{return CONSTANT;}

{digit}*\.{digit}+	{return CONSTANT;} 

0[xX][0-9a-fA-F]+	{return CONSTANT;}

'0'[0-7]+		{return CONSTANT;}

[+-]?[digit]+[.]?[digit]*([eE][+-]?[digit]+)?			{return CONSTANT;}


"+"			{return ('+');}

"-"			{return ('-');}

"*"			{return ('*');}

"/"			{return ('/');}

"="			{return ('=');}

"<"			{return ('<');}

">"			{return ('>');}

"++"			{  return INC_OP; }

"--"			{  return DEC_OP; }

"<="			{  return LE_OP; }

">="			{  return GE_OP; }

"=="			{  return EQ_OP; }

"!="			{  return NE_OP; }

"&&"			{  return AND_OP; }

"||"			{ return OR_OP; }

"*="			{  return MUL_ASSIGN; }

"/="			{  return DIV_ASSIGN; }

"%="			{  return MOD_ASSIGN; }

"+="			{  return ADD_ASSIGN; }

"-=" 			{ return SUB_ASSIGN; }

{alpha}({alpha}|{digit})* { return ID;}

\"(\\.|[^"\\])*\" {return STRING;}


{digit}+{alpha}+|{alpha}*{digit}*@{alpha}*{digit}*|%{alpha}{alpha}+ {
	
	printf("INVALID IDENTIFIER \" %s \" at Line %d", yytext, yylineno);  
}	

%%

int yywrap()
{
	return 1; 
}


  
