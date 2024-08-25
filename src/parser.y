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

%token SECTION SUBSECTION SUBSUBSECTION BOLD ITALIC HLINE PAR BEGINCODE END_VERBATIM LINK PIC
%token OPENBRACE CLOSEBRACE TEXT NEWLINE OPTION CODE
%token DOCCLASS PACKAGE TITLE DATE BEGINDOC ENDDOC
%type <node> document elements element section subsection subsubsection bold italics hrule paragraph verbatim hyperlink image
%type <node> docclass package title date begindoc enddoc unlist
%type <str> TEXT CODE  /* Added CODE here */
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
    DOCCLASS OPENBRACE TEXT CLOSEBRACE NEWLINE { $$ = createNode(NODE_DOCCLASS, $3); }
    ;

package:
    PACKAGE OPENBRACE TEXT CLOSEBRACE NEWLINE { $$ = createNode(NODE_PACKAGE, $3); }
    ;

title:
    TITLE OPENBRACE TEXT CLOSEBRACE NEWLINE { $$ = createNode(NODE_TITLE, $3); }
    ;

date:
    DATE OPENBRACE TEXT CLOSEBRACE NEWLINE { $$ = createNode(NODE_DATE, $3); }
    ;

begindoc:
    BEGINDOC NEWLINE { $$ = createNode(NODE_BEGINDOC, ""); }
    ;

enddoc:
    ENDDOC { $$ = createNode(NODE_ENDDOC, ""); }
    ;

section:
    SECTION OPENBRACE TEXT CLOSEBRACE { $$ = createNode(NODE_SECTION, $3); }
    ;

subsection:
    SUBSECTION OPENBRACE TEXT CLOSEBRACE { $$ = createNode(NODE_SUBSECTION, $3); }
    ;

subsubsection:
    SUBSUBSECTION OPENBRACE TEXT CLOSEBRACE { $$ = createNode(NODE_SUBSUBSECTION, $3); }
    ;

bold:
    BOLD OPENBRACE TEXT CLOSEBRACE { $$ = createNode(NODE_BOLD, $3); }
    ;

italics:
    ITALIC OPENBRACE TEXT CLOSEBRACE { $$ = createNode(NODE_ITALICS, $3); }
    ;

hrule:
    HLINE { $$ = createNode(NODE_HRULE, ""); }
    ;

paragraph:
    PAR { $$ = createNode(NODE_PARAGRAPH, ""); }
    ;

verbatim:
    BEGINCODE CODE { $$ = createNode(NODE_VERBATIM, $2); }
    ;


hyperlink:
    LINK OPENBRACE TEXT CLOSEBRACE OPENBRACE TEXT CLOSEBRACE { $$ = createNode(NODE_HYPERLINK, $6, $3); }
    ;

image:
    PIC OPTION OPENBRACE TEXT CLOSEBRACE { $$ = createNode(NODE_IMAGE, "", $4); }
    | PIC OPENBRACE TEXT CLOSEBRACE { $$ = createNode(NODE_IMAGE, "", $3); }

unlist: BEGINUL { $$ = createNode(NODE_BEGINUL, ""); }
        | ENDUL  { $$ = createNode(NODE_ENDUL, ""); }
        | ITEM TEXT   { $$ = createNode(NODE_ITEM, $2);  }
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
