/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    MAIN = 258,
    ASSIGN = 259,
    RETURN = 260,
    CLASS = 261,
    PRIVATE = 262,
    PUBLIC = 263,
    IF = 264,
    WHILE = 265,
    FOR = 266,
    PRINT = 267,
    PRINTTAB = 268,
    EQ = 269,
    NEQ = 270,
    GR = 271,
    GE = 272,
    LS = 273,
    LE = 274,
    TIP = 275,
    NR = 276,
    STRING = 277,
    ID = 278
  };
#endif
/* Tokens.  */
#define MAIN 258
#define ASSIGN 259
#define RETURN 260
#define CLASS 261
#define PRIVATE 262
#define PUBLIC 263
#define IF 264
#define WHILE 265
#define FOR 266
#define PRINT 267
#define PRINTTAB 268
#define EQ 269
#define NEQ 270
#define GR 271
#define GE 272
#define LS 273
#define LE 274
#define TIP 275
#define NR 276
#define STRING 277
#define ID 278

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 19 "limbaj.y"

      int valoare;
      char* string;
      char* nume;

#line 109 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
