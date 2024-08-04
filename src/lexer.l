%{
#include "parser.tab.h"
%}

%%
\\textbf       { return BOLD; }
[ ^\n]+   { /* ignore whitespace */ }
.         { return yytext[0]; }
%%

int yywrap() {
    return 1;
}
