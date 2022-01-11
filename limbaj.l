%{
#include <stdio.h>
#include "y.tab.h"
%}
%option noyywrap
%%
"@eq" {return EQ;}
"@neq" {return NEQ;}
"@g" {return GR;}
"@ge" {return GE;}
"@l" {return LS;}
"@le" {return LE;}
"print" {return PRINT;}
"print_tab()" {return PRINTTAB;}
"int"|"float"|"char" { yylval.string = strdup(yytext); return TIP;}
"return" {return RETURN;}
"class" {return CLASS;}
"private" {return PRIVATE;}
"public" {return PUBLIC;}
"if" {return IF;}
"while" {return WHILE;}
"for" {return FOR;}
"main()" {return MAIN;}
\"[_a-zA-Z ][_a-zA-Z0-9 ]*\" {yylval.nume = strdup(yytext); return STRING;}
[_a-zA-Z][_a-zA-Z0-9]* {yylval.nume=strdup(yytext); return ID;}
"=" {return ASSIGN;}
[0-9]+ {yylval.valoare = atoi(yytext); return NR;}
[ \t] ;
\n {yylineno++;}
. {return yytext[0];}
