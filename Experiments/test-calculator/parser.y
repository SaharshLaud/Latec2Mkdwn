%{
#include <iostream>
using namespace std;
extern int yylex();
void yyerror(const char *s){cerr << "Error: " << s << endl;};
%}

%token BOLD

%%
input:
    BOLD { cout << "Token = BOLD" << endl; }
    ;
%%

int main() {
    return yyparse();
}