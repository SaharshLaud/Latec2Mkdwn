%{
#include "parser.tab.h"
%}

%%
[0-9]+    { yylval.num = atoi(yytext); return NUMBER; }
\+        { return PLUS; }
[ \t\n]   { /* ignore whitespace */ }
.         { return yytext[0]; }
%%

int yywrap() {
    return 1;
}
