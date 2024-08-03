%{
#include <iostream>
extern int yylex();
void yyerror(const char *s);
%}

%union {
    int num;
}

%token <num> NUMBER
%token PLUS

%type <num> expr term

%%
input:
    expr { std::cout << "Addition = " << $1 << std::endl; }
    ;

expr:
    expr PLUS term { $$ = $1 + $3; }
    | term         { $$ = $1; }
    ;

term:
    NUMBER { $$ = $1; }
    ;
%%

int main() {
    return yyparse();
}

void yyerror(const char *s) {
    std::cerr << "Error: " << s << std::endl;
}
