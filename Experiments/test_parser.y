/* This is a test file that will be used to test various elements of the project for better understanding. */
/* This section contains parser Tokens and grammar rules. */

%{
#include <cstdio>
#include <cstdlib>
#include "ast.h"
#include <iostream>

using namespace std;
extern int yylex();
void yyerror(const char *s){cerr << "Error: " << s << endl;};

extern Node* root; // This is the root of our AST
%}

/* We need to define tokens to be able to use them in grammar rules. */
%token SECTION

%%
document:
    section
;
section:
    SECTION    { root = createNode(SECTION_NODE, "# This is a Section");}
    ;
%%
