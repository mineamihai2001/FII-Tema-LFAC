%{
#include <stdio.h>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
%}
%token ID TIP BGIN END ASSIGN NR RETURN CLASS PRIVATE PUBLIC IF WHILE FOR
%left '+'
%left '-'
%left '*'
%left '/'
%start progr
%%
progr: declaratii bloc {printf("program corect sintactic\n");}
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
      ; 

clasa : CLASS ID '{' corp_clasa '}'
      ;
corp_clasa : PRIVATE ':' declaratii PUBLIC ':' declaratii
           ;
/* bloc */
bloc : BGIN list END  
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

/* instructiune */
statement : ID ASSIGN e		 
          | ID '(' lista_apel ')'
          ;
/* de rezolvat conditiile */
loop : statement ';' condition ';' statement
     ;
condition : ID
          ;
e : NR
  | ID
  | ID '(' lista_apel ')'
  | e '+' e
  | e '*' e
  |'(' e ')'
  ;
lista_apel : e
           | lista_apel ',' e
           ;
%%
int yyerror(char * s){
printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv){
yyin=fopen(argv[1],"r");
yyparse();
} 
