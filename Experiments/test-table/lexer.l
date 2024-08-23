%{
#include "parser.tab.h"
#include "ast.h"
#include <iostream>
#include <cstring>  // for strdup
using namespace std;
%}

%option noyywrap
%x VERBATIM_MODE TABLE_MODE
%%
"\\documentclass"           { cout << "Matched DOCUMENTCLASS\n"; return DOCUMENTCLASS; }
"\\usepackage"              { cout << "Matched PACKAGE\n"; return PACKAGE; }
"\\title"                   { cout << "Matched TITLE\n"; return TITLE; }
"\\date"                    { cout << "Matched DATE\n"; return DATE; }
"\\begin{document}"         { cout << "Matched BEGIN-DOC\n"; return BEGIN_DOCUMENT; }
"\\end{document}"           { cout << "Matched END-DOC\n"; return END_DOCUMENT; }

"\\section"                 { cout << "Matched SECTION\n"; return SECTION; }
"\\subsection"              { cout << "Matched SUBSECTION\n"; return SUBSECTION; }
"\\subsubsection"           { cout << "Matched SUBSUBSECTION\n"; return SUBSUBSECTION; }
"\\textbf"                  { cout << "Matched BOLD\n"; return TEXTBF; }
"\\textit"                  { cout << "Matched ITALIC\n"; return TEXTIT; }
"\\hrule"                   { cout << "Matched HLINE\n"; return HRULE; }
"\\par"                     { cout << "Matched PAR\n"; return PAR; }
"\\href"                    { cout << "Matched LINK\n"; return HREF; }
\n                          { cout << "Matched NEWLINE\n"; return NEWLINE; }

"\\includegraphics"         { cout << "Matched INCLUDEGRAPHICS\n"; return INCLUDEGRAPHICS; }
\[[^\]]*\]                  { cout << "Matched GRAPHICS_OPTIONS\n"; yylval.str = strdup(yytext); return GRAPHICS_OPTIONS; }
"{"                         { cout << "Matched OPEN_BRACE\n"; return OPEN_BRACE; }
"}"                         { cout << "Matched CLOSE_BRACE\n"; return CLOSE_BRACE; }
[^{}\\\[\]\n]+              { cout << "Matched TEXT\n"; yylval.str = strdup(yytext); return TEXT; }

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
    cout << "Matched VERBATIM content\n";
    BEGIN(INITIAL);
    return VERBATIM_TEXT;
}

<VERBATIM_MODE>.|\n {
    // Accumulate verbatim text
    yylval.str = strdup(strcat(yylval.str, yytext));
}

"\\begin{tabular}"          { cout << "Matched BEGIN_TABLE\n"; BEGIN(TABLE_MODE); return BEGIN_TABLE; }
<TABLE_MODE>"\\end{tabular}"  { cout << "Matched END_TABLE\n"; BEGIN(INITIAL); return END_TABLE; }
<TABLE_MODE>"\\hline"         { cout << "Matched HLINE\n"; return HLINE; }
<TABLE_MODE>"&"               { cout << "Matched CELL_SEPARATOR\n"; return CELL_SEPARATOR; }
<TABLE_MODE>"\\\\"            { cout << "Matched ROW_SEPARATOR\n"; return ROW_SEPARATOR; }
<TABLE_MODE>[^&\\\n]+         { cout << "Matched CELL_CONTENT\n"; yylval.str = strdup(yytext); return CELL_CONTENT; }
<TABLE_MODE>.                 { /* Ignore other characters in table mode */ }

.                           { /* ignore unrecognized characters */ }
%%