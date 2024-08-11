/* This is a test file that will be used to test various elements of the project for better understanding. */
/* This section contains Flex definitions and rules. */


%{
#include "test_parser.tab.h"
#include <cstdio>
%}

%%
\\section      { return SECTION; }
[ ^\n]+   { /* ignore whitespace */ }
.         { return yytext[0]; }
%%

int yywrap() {
    return 1;
}
