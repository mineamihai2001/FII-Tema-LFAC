%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "symtab.h"

extern FILE* yyin;
extern char* yytext;
extern int yylineno;

expr_info* create_int_expr(int value);
expr_info* create_str_expr(char* value1);
expr_info* create_bool_expr(int value);
void free_expr(expr_info* expr);
void print_expr(expr_info* expr);
symtab* assign(int valoare, char* nume);
int print_var_info(symtab* id);
%}
%union {
      int valoare;
      char* string;
      char* nume;
}
%token TIP MAIN ASSIGN RETURN CLASS PRIVATE PUBLIC IF WHILE FOR PRINT PRINTTAB EQ NEQ GR GE LS LE
%token <valoare> NR
%token <nume> STRING
%token <nume> ID
%type <valoare> expr

%left '!'
%left '&' '|'
%left '-' '+'
%left '/' '*'

%start progr
%%
progr : declaratii bloc {printf("program corect sintactic\n");}
      ;

declaratii : declare_aux
	   | declaratii declare_aux
	   ;
declare_aux : declaratie ';'
              | declaratie_functie
              ;
declaratie : TIP ID { if (checkDeclared ($2) == -1)
                         declare ($2); 
                      else { yyerror();
                         printf ("Variabila deja declarata\n");
                           }
                    }
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
// lista_variabile : variabila
//                 | lista_variabile ',' variabila
//                 ;
// variabila : ID
//           ;
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
condition : expr 
          ;

/* instructiune */
statement : ID ASSIGN expr { 
                              if(checkDeclared($1) == -1)
                              {
                                 yyerror();
                                 printf("Variabila nedeclarata\n");
                              }
                              else createInt($1, $3);
                           }
          | ID ASSIGN ID {
                           if(checkDeclared($1) == -1)
                           {
                              yyerror();
                              printf("Variabila nedeclarata\n");
                           }
                           if(checkDeclared($3) == -1)
                           {
                              yyerror();
                              printf("Variabila nedeclarata\n");
                           }
                           if(assignID($1, $3) == -1)
                           {
                              yyerror();
                              printf("Variabilele nu sunt de acelasi tip\n");
                           }
                         }
         //  | ID ASSIGN STRING { ... }
          | ID ASSIGN 'new' ID '(' ')'
          | ID '(' lista_apel ')'
          | TIP ID { 
               if (checkDeclared ($2) == -1)
                         declare ($2); 
               else { yyerror();
                         printf ("Variabila deja declarata\n");
                    }
             }
          | PRINT '(' ID ')' { Print("", $3); }
          | PRINT '(' STRING ',' ID ')' { Print($3, $5); }
          | PRINTTAB {printTab();}
          ;
expr : NR {$$ = $1;}
     | ID {$$ = $1;}
     | ID '(' lista_apel ')'
     | expr '+' expr {
                      $$ = $1 + $3;     
                      }
     | expr '-' expr {
                      $$ = $1 - $3;     
                      }
     | expr '*' expr {
                      $$ = $1 * $3;     
                      }
     | expr '/' expr {
                      $$ = $1 / $3;     
                      }
     | expr '&' expr {
     				       $$ = $1 && $3;
     				       }
     | expr '|' expr {
     				       $$ = $1 || $3;
     				       }
     | '!' expr      {
                      $$ = !$$;  
                      }
     | expr EQ expr {
                        if($1 == $3)
                           $$ = 1;
                        else $$ = 0;
                      }
     | expr NEQ expr {
                        if($1 != $3)
                           $$ = 1;
                        else $$ = 0;
                      }
     | expr LE expr {
                        if($1 <= $3)
                           $$ = 1;
                        else $$ = 0;
                       }
     | expr LS expr {
                        if($1 < $3)
                           $$ = 1;
                        else $$ = 0;
                       }
      | expr GE expr {
                        if($1 >= $3)
                           $$ = 1;
                        else $$ = 0;
                       }
      | expr GR expr {
                        if($1 > $3)
                           $$ = 1;
                        else $$ = 0;
                       }
     |'(' expr ')'   {
                      $$ = $2;  
                      }
     ;
lista_apel : expr
           | lista_apel ',' expr
           ;
%%

symtab* assign(int value, char* nume)
{
   symtab* id = (symtab*)malloc(sizeof(symtab));
   id->valoare = value;
   return id;
}

int print_var_info(symtab* id)
{
   printf("ID %s with value:%d\n",id->nume, id->valoare);
   return id->valoare;
}

expr_info* create_bool_expr(int value)
{
   expr_info* expr = (expr_info*)malloc(sizeof(expr_info));
   expr->intvalue = 0;
   if(value)
      expr->intvalue = 1;
   expr->type = 1;
   return expr;   
}

expr_info* create_int_expr(int value)
{
   expr_info* expr = (expr_info*)malloc(sizeof(expr_info));
   expr->intvalue = value;
   expr->type = 1;
   return expr;
}

expr_info* create_str_expr(char* value1) 
{
   expr_info* expr = (expr_info*)malloc(sizeof(expr_info));
   expr->strvalue = (char*)malloc(sizeof(char)); 
   expr->strvalue = value1;
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
   printf("Exor %s with value:%d\n",expr->strvalue, expr->intvalue);
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
