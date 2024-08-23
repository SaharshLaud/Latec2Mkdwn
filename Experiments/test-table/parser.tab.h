/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
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
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

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

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif
/* "%code requires" blocks.  */
#line 20 "parser.y"

    #include <vector>
    #include <string>

#line 54 "parser.tab.h"

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    SECTION = 258,                 /* SECTION  */
    SUBSECTION = 259,              /* SUBSECTION  */
    SUBSUBSECTION = 260,           /* SUBSUBSECTION  */
    TEXTBF = 261,                  /* TEXTBF  */
    TEXTIT = 262,                  /* TEXTIT  */
    HRULE = 263,                   /* HRULE  */
    PAR = 264,                     /* PAR  */
    BEGIN_VERBATIM = 265,          /* BEGIN_VERBATIM  */
    END_VERBATIM = 266,            /* END_VERBATIM  */
    HREF = 267,                    /* HREF  */
    INCLUDEGRAPHICS = 268,         /* INCLUDEGRAPHICS  */
    OPEN_BRACE = 269,              /* OPEN_BRACE  */
    CLOSE_BRACE = 270,             /* CLOSE_BRACE  */
    TEXT = 271,                    /* TEXT  */
    NEWLINE = 272,                 /* NEWLINE  */
    GRAPHICS_OPTIONS = 273,        /* GRAPHICS_OPTIONS  */
    VERBATIM_TEXT = 274,           /* VERBATIM_TEXT  */
    DOCUMENTCLASS = 275,           /* DOCUMENTCLASS  */
    PACKAGE = 276,                 /* PACKAGE  */
    TITLE = 277,                   /* TITLE  */
    DATE = 278,                    /* DATE  */
    BEGIN_DOCUMENT = 279,          /* BEGIN_DOCUMENT  */
    END_DOCUMENT = 280,            /* END_DOCUMENT  */
    BEGIN_TABLE = 281,             /* BEGIN_TABLE  */
    END_TABLE = 282,               /* END_TABLE  */
    HLINE = 283,                   /* HLINE  */
    CELL_SEPARATOR = 284,          /* CELL_SEPARATOR  */
    ROW_SEPARATOR = 285,           /* ROW_SEPARATOR  */
    CELL_CONTENT = 286             /* CELL_CONTENT  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
