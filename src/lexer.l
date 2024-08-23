%{
#include "parser.tab.h"
#include "ast.h"
#include <iostream>
using namespace std;
%}

%option noyywrap
%x VERBATIM_MODE  
%%
"\\documentclass"           { return DOCUMENTCLASS; }
"\\usepackage"              { return PACKAGE; }
"\\title"                   { return TITLE; }
"\\date"                    { return DATE; }
"\\begin{document}"         { return BEGIN_DOCUMENT; }
"\\end{document}"           { return END_DOCUMENT; }

"\\section"                 { return SECTION; }
"\\subsection"              { return SUBSECTION; }
"\\subsubsection"           { return SUBSUBSECTION; }
"\\textbf"                  { return TEXTBF; }
"\\textit"                  { return TEXTIT; }
"\\hrule"                   { return HRULE; }
"\\par"                     { return PAR; }
"\\href"                    { return HREF; }
\n                          { return NEWLINE; }

"\\includegraphics"         { return INCLUDEGRAPHICS; }
\[[^\]]*\]                  { yylval.str = strdup(yytext); return GRAPHICS_OPTIONS; }
"{"                         { return OPEN_BRACE; }
"}"                         { return CLOSE_BRACE; }
[^{}\\\[\]\n]+              { yylval.str = strdup(yytext); return TEXT; }

"\\begin{verbatim}" {
    BEGIN(VERBATIM_MODE);
    yylval.str = strdup("");
    return BEGIN_VERBATIM;
}

<VERBATIM_MODE>([^\\]|\\[^e]|\\e[^n]|\\en[^d]|\\end[^{])+"\\end{verbatim}" {
    std::string content(yytext);
    content = content.substr(0, content.length() - strlen("\\end{verbatim}"));

    // Remove leading \begin{verbatim}
    yylval.str = strdup(content.c_str());
    BEGIN(INITIAL);
    return VERBATIM_TEXT;
}

<VERBATIM_MODE>.|\n {
    // Accumulate verbatim text
    yylval.str = strdup(strcat(yylval.str, yytext));
}

.                           { /* ignore unrecognized characters */ }
%%
