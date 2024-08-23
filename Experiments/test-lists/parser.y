%{
#define YYDEBUG 1

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
%token BEGIN_ITEMIZE END_ITEMIZE BEGIN_ENUMERATE END_ENUMERATE ITEM

%type <node> document elements element section subsection subsubsection bold italics hrule paragraph verbatim hyperlink image
%type <node> docclass package title date begindoc enddoc newlines
%type <node> list list_items list_item item_content
%type <str> TEXT VERBATIM_TEXT

%%

document:
    elements { root = $1; }
    ;

elements:
    element { $$ = createNode(NODE_DOCUMENT, ""); addChild($$, $1); }
    | elements element { addChild($1, $2); $$ = $1; }
    | elements NEWLINE { $$ = $1; }
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
    | list
    | TEXT { $$ = createNode(NODE_TEXT, $1); }
    ;

list:
    BEGIN_ITEMIZE newlines list_items newlines END_ITEMIZE { $$ = createNode(NODE_UNORDERED_LIST, ""); addChild($$, $3); }
    | BEGIN_ENUMERATE newlines list_items newlines END_ENUMERATE { $$ = createNode(NODE_ORDERED_LIST, ""); addChild($$, $3); }
    ;

list_items:
    list_item { $$ = $1; }
    | list_items newlines list_item { addChild($1, $3); $$ = $1; }
    ;

list_item:
    ITEM newlines item_content newlines { $$ = createNode(NODE_LIST_ITEM, ""); addChild($$, $3); }
    ;

item_content:
    element { $$ = $1; }
    | item_content newlines element { addChild($1, $3); $$ = $1; }
    ;
newlines:
    /* empty */ { $$ = nullptr; }
    | NEWLINE { $$ = createNode(NODE_TEXT, ""); }
    | newlines NEWLINE { $$ = $1; }
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
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
