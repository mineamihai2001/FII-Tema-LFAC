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
    TIP = 258,
    MAIN = 259,
    ASSIGN = 260,
    RETURN = 261,
    CLASS = 262,
    PRIVATE = 263,
    PUBLIC = 264,
    IF = 265,
    WHILE = 266,
    FOR = 267,
    PRINT = 268,
    PRINTTAB = 269,
    EQ = 270,
    NEQ = 271,
    GR = 272,
    GE = 273,
    LS = 274,
    LE = 275,
    NR = 276,
    STRING = 277,
    ID = 278
  };
#endif
/* Tokens.  */
#define TIP 258
#define MAIN 259
#define ASSIGN 260
#define RETURN 261
#define CLASS 262
#define PRIVATE 263
#define PUBLIC 264
#define IF 265
#define WHILE 266
#define FOR 267
#define PRINT 268
#define PRINTTAB 269
#define EQ 270
#define NEQ 271
#define GR 272
#define GE 273
#define LS 274
#define LE 275
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
