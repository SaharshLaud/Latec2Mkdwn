%{
#include <stdio.h>
#include <stdlib.h>
#include "ast.h"
#include <iostream>

using namespace std;
extern int yylex();
void yyerror(const char *s) { cerr << "Error: " << s << endl; }

extern Node* root; // This is the root of our AST
%}

%union {
    char* str;
}

/* Define tokens */
%token <str> SECTION LBRACE RBRACE TEXT
%type <str> text section

%%
document:
        | document section
        | document TEXT
        {
            Node* node = createNode(TEXT_NODE, $2); // Create a text node
            if (!root) {
                root = node;
            } else {
                Node* current = root;
                while (current->next) {
                    current = current->next;
                }
                current->next = node;
            }
            free($2); // Free the allocated memory for text
        }
        ;

section: SECTION LBRACE text RBRACE
        {
            Node* node = createNode(SECTION_NODE, $3);
            if (!root) {
                root = node;
            } else {
                Node* current = root;
                while (current->next) {
                    current = current->next;
                }
                current->next = node;
            }
            printf("# %s\n", $3);
            free($3); // Free the allocated memory for text
        }
        ;

text: TEXT
     {
         $$ = $1;
     }
     ;

%%

