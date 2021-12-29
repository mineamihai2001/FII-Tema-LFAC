%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "symtab.h"

extern FILE* yyin;
extern char* yytext;
extern int yylineno;

expr_info* create_int_expr(int value);
expr_info* create_str_expr(char* value1, char* value2);
void free_expr(expr_info* expr);
void print_expr(expr_info* expr);
%}
%union {
      int intval;
      char* strval;
      struct expr_info* expr_ptr;
}
%token TIP MAIN ASSIGN RETURN CLASS PRIVATE PUBLIC IF WHILE FOR ID
%token <strval> STRING
%token <intval> NR
// %token <strval> ID 
%type <expr_ptr> expr
%type <expr_ptr> statement

%left '-' '+'
%left '/' '*'

%start progr
%%
progr : declaratii bloc {printf("program corect sintactic\n");}
      ;

declaratii : declarare_aux
	   | declaratii declarare_aux
	   ;
declarare_aux : declaratie ';'
              | declaratie_functie
              ;
declaratie : TIP lista_variabile
           | TIP ID '(' lista_param ')'
           | TIP ID '(' ')'
           | TIP ID '[' NR ']'
           | clasa           
           ;
declaratie_functie : TIP ID '(' lista_param ')' '{' list return_id '}'
                   | TIP ID '(' ')' '{' list return_id '}'
                   ;
return_id : RETURN ID ';'
          ;
lista_variabile : variabila
                | lista_variabile ',' variabila
                ;
variabila : ID
          ;
lista_param : param
            | lista_param ','  param 
            ;
            
param : TIP ID
      | TIP ID '[' NR ']'
      ; 

clasa : CLASS ID '{' corp_clasa '}'
      ;
corp_clasa : PRIVATE ':' declaratii PUBLIC ':' declaratii
           | declaratii PUBLIC ':' declaratii
           ;
/* bloc */
bloc : MAIN '{' list '}'  
     ;
     
/* lista instructiuni */
list :  statement ';' 
     | list statement ';'
     | IF '(' condition ')' '{' list '}'
     | list IF '(' condition ')' '{' list '}'
     | WHILE '(' condition ')' '{' list '}'
     | list WHILE '(' condition ')' '{' list '}'
     | FOR '(' loop ')' '{' list '}'
     | list FOR '(' loop ')' '{' list '}'
     ;
/* [[[[[de rezolvat conditiile]]]]] */
loop : statement ';' condition ';' statement
     ;
condition : ID
          ;

/* instructiune */
statement : ID ASSIGN expr {print_expr($3);}
          | ID '(' lista_apel ')'
          ;
expr : NR {$$ = create_int_expr($1);}
     | ID 
     | ID '(' lista_apel ')'
     | expr '+' expr {
                      $$ = create_int_expr($1->intvalue + $3->intvalue);
                      free_expr($1);
                      free_expr($3);     
                      }
     | expr '-' expr {
                      $$ = create_int_expr($1->intvalue - $3->intvalue);
                      free_expr($1);
                      free_expr($3);     
                      }
     | expr '*' expr {
                      $$ = create_int_expr($1->intvalue * $3->intvalue);
                      free_expr($1);
                      free_expr($3);     
                      }
     | expr '/' expr {
                      $$ = create_int_expr($1->intvalue / $3->intvalue);
                      free_expr($1);
                      free_expr($3);     
                      }
     |'(' expr ')' 
     ;
lista_apel : expr
           | lista_apel ',' expr
           ;
%%

expr_info* create_int_expr(int value)
{
   expr_info* expr = (expr_info*)malloc(sizeof(expr_info));
   expr->intvalue = value;
   expr->type = 1;
   return expr;
}

expr_info* create_str_expr(char* value1, char* value2) 
{
   expr_info* expr = (expr_info*)malloc(sizeof(expr_info));
   int len2 = value2 ? strlen(value2) : 0;
   expr->strvalue = (char*) malloc(sizeof(char)*(strlen(value1) + len2 +1)); 
   strcpy(expr->strvalue, value1);
   if(value2)
   {
      strcat(expr->strvalue, value2);
   }
   expr->type = 2;
   return expr;
		
}

void free_expr(expr_info* expr)
{
  if(expr->type == 2)
  {
     free(expr->strvalue);
  }
  free(expr);
}


void print_expr(expr_info* expr)
{
   printf("Int expr with value:%d\n",expr->intvalue);
   // if(expr->type == 1) 
   // {
	// printf("Int expr with value:%d\n",expr->intvalue);
   // }
   // else
   // {
	// printf("Str expr with value:%s\n", expr->strvalue);	
   // }	

}

int yyerror(char * s){
printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv){
yyin=fopen(argv[1],"r");
yyparse();
} 
