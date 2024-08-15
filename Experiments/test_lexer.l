/* This is a test file that will be used to test various elements of the project for better understanding. */
/* This section contains Flex definitions and rules. */


%{
#include "test_parser.tab.h"
#include <cstdio>
#include <iostream>
using namespace std;

%}

%%
\\section            {cout<<"Matched SECTION\n"; return SECTION;}
\{                   {cout<<"Matched LBRACE\n"; return LBRACE; }
\}                   {cout<<"Matched RBRACE\n"; return RBRACE; }
[^\s{}\n]+  { yylval.str = strdup(yytext); std::cout << "Matched TEXT: " << yytext << "\n"; return TEXT; }

[ ^\n]+   { /* ignore whitespace */ }
%%

int yywrap() {
    return 1;
}
