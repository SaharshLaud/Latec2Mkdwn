%{
#include "parser.tab.h"
#include "ast.h"
#include <iostream>
using namespace std;
%}

%option noyywrap
%x VERBATIM_MODE  
%%
"\\documentclass"           { return DOCCLASS; }
"\\usepackage"              { return PACKAGE; }
"\\title"                   { return TITLE; }
"\\date"                    { return DATE; }
"\\begin{document}"         { return BEGINDOC; }
"\\end{document}"           { return ENDDOC; }

"\\section"                 { return SECTION; }
"\\subsection"              { return SUBSECTION; }
"\\subsubsection"           { return SUBSUBSECTION; }

"\\textbf"                  { return BOLD; }
"\\textit"                  { return ITALIC; }

"\\hrule"                   { return HLINE; }
"\\par"                     { return PAR; }
"\\href"                    { return LINK; }
\n                          { return NEWLINE; }


"\\begin{itemize}\n"        { return BEGINUL; }
"\\end{itemize}\n"          { return ENDUL; }

"\\item"                    {return ITEM; }


"\\includegraphics"         { return PIC; }
\[[^\]]*\]                  { yylval.str = strdup(yytext); return OPTION; }
"{"                         { return OPENBRACE; }
"}"                         { return CLOSEBRACE; }
[^{}\\\[\]\n]+              { yylval.str = strdup(yytext); return TEXT; } 

"\\begin{verbatim}" {
    BEGIN(VERBATIM_MODE);
    yylval.str = strdup("");
    return BEGINCODE;
}

<VERBATIM_MODE>(?:[^\\]|\\.)*"\\end{verbatim}" {
    std::string content(yytext);
    content = content.substr(0, content.length() - strlen("\\end{verbatim}"));

    yylval.str = strdup(content.c_str());
    BEGIN(INITIAL);
    return CODE;
}

<VERBATIM_MODE>.|\n {
    yylval.str = strdup(strcat(yylval.str, yytext));
}
.                           { /** ignore unrecognized characters */ }
%%
