%{
#include <stdio.h>
#include <stdlib.h>
#include "ast.h"
#include <iostream>
#include <cstring>

using namespace std;
extern int yylex();
void yyerror(const char *s) { cerr << "Error: " << s << endl; }

extern Node* root; // This is the root of our AST
Node* current_node = nullptr; // Keep track of the current node
%}

%union {
    char* str;
}


/* Define tokens */
%token <str> SECTION SUBSECTION SUBSUBSECTION ITALIC BOLD HLINE LBRACE RBRACE TEXT PAR
%type <str> text section subsection subsubsection italic bold hline par


%%
document:
        | document section
        | document subsection
        | document subsubsection
        | document italic
        | document bold
        | document hline
        | document par
        | document TEXT
        {
            Node* node = createNode(TEXT_NODE, $2); // Create a text node
            if (!root) {
                root = node;
                current_node = root;
            } else {
                current_node->next = node;
                current_node = current_node->next;
            }
            free($2); // Free the allocated memory for text
        }
        ;

section: SECTION LBRACE text RBRACE
        {
            Node* node = createNode(SECTION_NODE, $3);
            if (!root) {
                root = node;
                current_node = root;
            } else {
                current_node->next = node;
                current_node = current_node->next;
            }
            free($3); // Free the allocated memory for text
        }
        ;

subsection: SUBSECTION LBRACE text RBRACE
        {
            Node* node = createNode(SUBSECTION_NODE, $3);
            if (current_node) {
                addChild(current_node, node);
            } else {
                root = node;
                current_node = root;
            }
            free($3); // Free the allocated memory for text
        }
        ;

subsubsection: SUBSUBSECTION LBRACE text RBRACE
        {
            Node* node = createNode(SUBSUBSECTION_NODE, $3);
            if (current_node) {
                addChild(current_node, node);
            } else {
                root = node;
                current_node = root;
            }
            free($3); // Free the allocated memory for text
        }
        ;

italic: ITALIC LBRACE text RBRACE
        {
            Node* node = createNode(ITALIC_NODE, $3);
            if (current_node) {
                addChild(current_node, node);
            } else {
                root = node;
                current_node = root;
            }
            free($3); // Free the allocated memory for text
        }
        ;

bold: BOLD LBRACE text RBRACE
        {
            Node* node = createNode(BOLD_NODE, $3);
            if (current_node) {
                addChild(current_node, node);
            } else {
                root = node;
                current_node = root;
            }
            free($3); // Free the allocated memory for text
        }
        ;

hline: HLINE
        {
            Node* node = createNode(HLINE_NODE, "");
            if (current_node) {
                addChild(current_node, node);
            } else {
                root = node;
                current_node = root;
            }
        }
        ;

par: PAR
        {
            Node* node = createNode(PARA_NODE, ""); // Create a paragraph node
            if (!root) {
                root = node;
                current_node = root;
            } else {
                current_node->next = node;
                current_node = current_node->next;
            }
        }
        ;


text: TEXT
     {
         $$ = $1;
     }
    | TEXT PAR
     {
         $$ = $1;
     }
     ;

%%