%{
#include "test_parser.tab.h"
#include <cstdio>
#include <iostream>
using namespace std;
%}

%%
\\section            { cout << "Matched SECTION\n"; return SECTION; }
\{                   { cout << "Matched LBRACE\n"; return LBRACE; }
\}                   { cout << "Matched RBRACE\n"; return RBRACE; }
[^{}\n]+             { yylval.str = strdup(yytext); std::cout << "Matched TEXT: " << yytext << "\n"; return TEXT; }
[ \t\n]+             { /* ignore whitespace */ }
%%

int yywrap() {
    return 1;
}
