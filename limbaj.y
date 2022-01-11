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
      struct expr_info *expr_info;
}
%token MAIN ASSIGN RETURN CLASS PRIVATE PUBLIC IF WHILE FOR PRINT PRINTTAB EQ NEQ GR GE LS LE
%token <string> TIP
%token <valoare> NR
%token <nume> STRING
%token <nume> ID
%token <nume> OBJECT
%type <valoare> expr

%left '!'
%left '&' '|'
%left '-' '+'
%left '/' '*'

%start progr
%%
progr : declaratii bloc {printf("\n\n\n\t\t\tprogram corect sintactic\n\n\n");}
      ;

declaratii : declare_aux
	   | declaratii declare_aux
	   ;
declare_aux : declaratie ';'
              | declaratie_functie
              ;
declaratie : TIP ID { if (checkDeclared ($2) == -1)
                         declareGlobal ($2, $1); 
                      else { yyerror();
                         printf ("Variabila deja declarata\n");
                           }
                    }
           | TIP ID '(' lista_param ')' { if (checkFunctDeclared ($2) != -1)
                                          { yyerror();
                                             printf ("Functie deja declarata\n");
                                          }
                                       }
           | TIP ID '(' ')'
           | TIP ID '[' NR ']' {
                                 if (checkDeclared ($2) == -1)
                                    declareGlobal ($2, $1); 
                                 else { yyerror();
                                 printf ("Variabila deja declarata\n");
                                      }
                               }
           | TIP ID ASSIGN expr { 
                              if (checkDeclared ($2) == -1)
                                 {
                                    declareGlobal ($2, $1);
                                    assignInt($2, $4);
                                 } else { yyerror();
                                 printf ("Variabila deja declarata\n");
                                }
                                }
           | clasa           
           ;

declaratie_functie : TIP ID '(' lista_param ')' '{' list RETURN ID ';' '}' {
                                                                           if (checkFunctDeclared ($2) == -1)
                                                                                 createFunction($2, $1, $9);
                                                                           else { yyerror();
                                                                              printf ("Functie deja declarata\n");
                                                                                 }
                                                                       }
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
            
param : TIP ID {
               if (checkDeclared ($2) == -1)
               {
                  addParam($2, $1);
               } else { yyerror();
                        printf ("Variabila deja declarata\n");
                      }
               }
      | TIP ID '[' NR ']'
      ; 

clasa : CLASS OBJECT '{' corp_clasa '}' {createClass($2);}
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
                              } else assignInt($1, $3);
                           }
          | ID ASSIGN ID {
                           if(checkDeclared($1) == -1)
                           {
                              yyerror();
                              printf("Variabila nedeclarata\n");
                           } if(checkDeclared($3) == -1)
                           {
                              yyerror();
                              printf("Variabila nedeclarata\n");
                           } if(assignID($1, $3) == -1)
                           {
                              yyerror();
                              printf("Variabilele nu sunt de acelasi tip\n");
                           }
                         }
          | ID ASSIGN STRING { 
                              if(checkDeclared($1) == -1)
                              {
                                 yyerror();
                                 printf("Variabila nedeclarata\n");
                              } else { assignString($1, $3);}
                              }
          | ID '(' lista_apel ')'
          | ID ASSIGN ID '(' lista_apel ')' {
                                             if(checkFunctDeclared($3) == -1)
                                             {
                                                yyerror();
                                                printf("Functie nedeclarata");
                                             } else assignFunct($1, $3); 
                                            }
          | TIP ID { 
               if (checkDeclared ($2) == -1)
                         declare ($2, $1); 
               else { yyerror();
                         printf ("Variabila deja declarata\n");
                    }
             }
          | OBJECT ID {  }
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
                      if($$ == 1)
                        $$ = 0;
                      else $$ = 1;  
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

int yyerror(char * s){
printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv){
yyin=fopen(argv[1],"r");
yyparse();
} 
