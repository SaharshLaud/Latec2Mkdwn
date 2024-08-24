%{
#include "ast.h"
#include <stdio.h>
extern int yylex();
void yyerror(const char *s);
ASTNode *root = nullptr;
%}

%union {
    char *str;
    struct ASTNode *node;
}

%token SECTION SUBSECTION SUBSUBSECTION TEXTBF TEXTIT HRULE PAR BEGIN_VERBATIM END_VERBATIM HREF INCLUDEGRAPHICS
%token OPEN_BRACE CLOSE_BRACE TEXT NEWLINE GRAPHICS_OPTIONS VERBATIM_TEXT
%token DOCUMENTCLASS PACKAGE TITLE DATE BEGIN_DOCUMENT END_DOCUMENT
%type <node> document elements element section subsection subsubsection bold italics hrule paragraph verbatim hyperlink image
%type <node> docclass package title date begindoc enddoc unlist
%type <str> TEXT VERBATIM_TEXT  /* Added VERBATIM_TEXT here */
%token BEGINUL ENDUL ITEM
%%

document:
    elements { root = $1; }
    ;

elements:
    element { $$ = createNode(NODE_DOCUMENT, ""); addChild($$, $1); }
    | elements element { addChild($1, $2); $$ = $1; }
    | elements NEWLINE { ASTNode* newlineNode = createNode(NODE_PARAGRAPH, ""); addChild($1, newlineNode); $$ = $1; }
    | elements TEXT { ASTNode* textNode = createNode(NODE_TEXT, $2); addChild($1, textNode); $$ = $1; }
    ;

element:
    docclass
    | package
    | title
    | date
    | begindoc
    | enddoc
    | section
    | subsection
    | subsubsection
    | bold
    | italics
    | hrule
    | paragraph
    | verbatim
    | hyperlink
    | image
    | unlist
    ;

docclass:
    DOCUMENTCLASS OPEN_BRACE TEXT CLOSE_BRACE NEWLINE { $$ = createNode(NODE_DOCUMENTCLASS, $3); }
    ;

package:
    PACKAGE OPEN_BRACE TEXT CLOSE_BRACE NEWLINE { $$ = createNode(NODE_PACKAGE, $3); }
    ;

title:
    TITLE OPEN_BRACE TEXT CLOSE_BRACE NEWLINE { $$ = createNode(NODE_TITLE, $3); }
    ;

date:
    DATE OPEN_BRACE TEXT CLOSE_BRACE NEWLINE { $$ = createNode(NODE_DATE, $3); }
    ;

begindoc:
    BEGIN_DOCUMENT NEWLINE { $$ = createNode(NODE_BEGIN_DOC, ""); }
    ;

enddoc:
    END_DOCUMENT { $$ = createNode(NODE_END_DOC, ""); }
    ;

section:
    SECTION OPEN_BRACE TEXT CLOSE_BRACE { $$ = createNode(NODE_SECTION, $3); }
    ;

subsection:
    SUBSECTION OPEN_BRACE TEXT CLOSE_BRACE { $$ = createNode(NODE_SUBSECTION, $3); }
    ;

subsubsection:
    SUBSUBSECTION OPEN_BRACE TEXT CLOSE_BRACE { $$ = createNode(NODE_SUBSUBSECTION, $3); }
    ;

bold:
    TEXTBF OPEN_BRACE TEXT CLOSE_BRACE { $$ = createNode(NODE_BOLD, $3); }
    ;

italics:
    TEXTIT OPEN_BRACE TEXT CLOSE_BRACE { $$ = createNode(NODE_ITALICS, $3); }
    ;

hrule:
    HRULE { $$ = createNode(NODE_HRULE, ""); }
    ;

paragraph:
    PAR { $$ = createNode(NODE_PARAGRAPH, ""); }
    ;

verbatim:
    BEGIN_VERBATIM VERBATIM_TEXT { $$ = createNode(NODE_VERBATIM, $2); }
    ;


hyperlink:
    HREF OPEN_BRACE TEXT CLOSE_BRACE OPEN_BRACE TEXT CLOSE_BRACE { $$ = createNode(NODE_HYPERLINK, $6, $3); }
    ;

image:
    INCLUDEGRAPHICS GRAPHICS_OPTIONS OPEN_BRACE TEXT CLOSE_BRACE { $$ = createNode(NODE_IMAGE, "", $4); }
    | INCLUDEGRAPHICS OPEN_BRACE TEXT CLOSE_BRACE { $$ = createNode(NODE_IMAGE, "", $3); }

unlist: BEGINUL { $$ = createNode(NODE_BEGINUL, ""); }
        | ENDUL  { $$ = createNode(NODE_ENDUL, ""); }
        | ITEM TEXT   { $$ = createNode(NODE_ITEM, $2);  }
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
