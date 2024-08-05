/* This is a test file that will be used to test various elements of the project for better understanding. */
/* This section contains parser Tokens and grammar rules. */

%{
#include <iostream>
using namespace std;
extern int yylex();
void yyerror(const char *s){cerr << "Error: " << s << endl;};
%}

/* We need to define tokens to be able to use them in grammar rules. */
%token BOLD SECTION ITALIC

%%
input:
    BOLD { cout << "Token = BOLD" << endl; }
    | SECTION    { cout << "Token = SECTION" << endl; }
    | ITALIC     { cout << "Token = ITALIC" << endl; }
    ;
%%

int main() {
    return yyparse();
}