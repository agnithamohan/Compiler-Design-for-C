%{
#include "y.tab.h"
#include<string.h>
#include<stdio.h>
int lineno=1;
int comment_nesting = 0; 
%}
alpha [a-zA-Z_]
digit [0-9]
ID {alpha}({alpha}|{digit})*
WHITESPACE " "|"	"|"\n"



%%
"/*" { multicomment(); }
"//" { singlecomment(); }

#include[ ]?<{alpha}*.h> {}


"break"			{ return(BREAK); }
"char"			{
			yylval.ival = 1;
			 return(CHAR); }
"double"		{ 
			yylval.ival = 5;
			return(DOUBLE); }
"else"			{ return(ELSE); }
"float"			{
			yylval.ival = 3; 
			 return(FLOAT); }
"for"			{ return(FOR); }
"if"			{ return(IF); }
"while"                 { return WHILE; }
"do"			{ return DO; }
"int"			{ 
			yylval.ival = 2; 
			return(INT); }
"long"			{ 
			yylval.ival = 7; 
			return(LONG); }
"return"		{ 
			return(RETURN); }
"short"			{ 	yylval.ival = 6; 
			return(SHORT); }
"signed"		{  	yylval.ival = 30; 
				return(SIGNED); 
			}
"unsigned"		{  
			yylval.ival = 20; 
			return(UNSIGNED); }
"void"			{
			yylval.ival = 4; 
			return(VOID); }
 		

{ID} 	{	
	yylval.str=strdup(yytext); 		
			return ID;}

{digit}+		{ yylval.str=strdup(yytext);
			return INTEGER;}

{digit}*\.{digit}+	{yylval.str=strdup(yytext);
			return REAL;}





\"[^\n]*\" 	{yylval.str=strdup(yytext);
		return(STRING);
		}

"+="|"-="|"*="|"/="|"%="	{ 	yylval.str=strdup(yytext); 		return(ASSIGN_OP); }
"=="|"!="			{	yylval.str=strdup(yytext); 		 return(EQU_OP); }
"<="|">="|">"|"<"		{	yylval.str=strdup(yytext); 		 return(REL_OP); }
"+"|"-"				{ 	yylval.str=strdup(yytext); 		return(ADD_OP); }
"*"|"/"|"%"			{ 	yylval.str=strdup(yytext); 		return(MUL_OP); }
"++"|"--"			{ 	yylval.str=strdup(yytext); 		return(INCDEC_OP); }
"&&"        {	yylval.str=strdup(yytext); 		return(LAND);}
"||"        {	yylval.str=strdup(yytext); 		return(LOR);}
"=" 		{	yylval.str=strdup(yytext); 		 return('='); }
"{"			{ open1(); return('{'); }
"}"			{ close1(); return('}'); }
"("			{ return('('); }
")"			{ return(')'); }
"["			{ return('['); }
"]"			{ return(']'); }
";"			{//strcpy(type.key," ");
				//type.lno=0; 
				 return(';'); }
","			{ return(','); }
"."			{ return('.'); }
"?"			{ return('?'); }
":"			{ return(':'); }

{WHITESPACE}	{ if(yytext[0]=='\n') { lineno++; } };

. {printf("LEXICAL ERROR - %s : invalid character at line [%d]\n",yytext,lineno);}

%%

multicomment()
{
	char c, c1;
	while ((c = input()) != '*' && c != 0);
	c1=input();
	if(c=='*' && c1=='/')
	{
		c=0;
	}
	if (c != 0)
		putchar(c1);
}
singlecomment()
{
	char c;
	while(c=input()!='\n');
	if(c=='\n')
		c=0;
	if(c!=0)
		putchar(c);
}


int yywrap()
{
	return 1;
}
