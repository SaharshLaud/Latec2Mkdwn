/* This is a test file that will be used to test various elements of the project for better understanding. */
/* This section contains parser Tokens and grammar rules. */

%{
#include <stdio.h>
#include <stdlib.h>
#include "ast.h"
#include <iostream>

using namespace std;
extern int yylex();
void yyerror(const char *s){cerr << "Error: " << s << endl;};

extern Node* root; // This is the root of our AST
%}

%union {
    char* str;
}

/* We need to define tokens to be able to use them in grammar rules. */
%token SECTION LBRACE RBRACE TEXT
%type <str> TEXT text
%type <str> section

%%
document:
        | document section
        | document TEXT /* Ignore any unmatched text */
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
        }
        ;

text: TEXT
     {
         $$ = $1;
     }
     ;
%%

