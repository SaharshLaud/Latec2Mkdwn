%{
#include "test_parser.tab.h"
#include <cstdio>
#include <iostream>
using namespace std;
%}

%%

\\href               { cout << "Matched HYPERLINK\n"; return HYPERLINK; }
\\begin              { cout << "Matched BEGIN-TAG\n"; return BEGIN_TAG; }
\\end                { cout << "Matched END-TAG\n"; return END_TAG; }

\\documentclass      { cout << "Matched DOCUMENT CLASS\n"; return DOCUMENT; }
\\usepackage         { cout << "Matched PACKAGE\n"; return PACKAGE;}
\\title              { cout << "Matched TITLE\n"; return TITLE;}
\\date               { cout << "Matched DATE\n"; return DATE;}

\\section            { cout << "Matched SECTION\n"; return SECTION; }
\\subsection         { cout << "Matched SUBSECTION\n"; return SUBSECTION; }
\\subsubsection      { cout << "Matched SUBSUBSECTION\n"; return SUBSUBSECTION; }
\\textit             { cout << "Matched ITALIC TEXT\n"; return ITALIC; }
\\textbf             { cout << "Matched BOLD TEXT\n"; return BOLD; }
\\hrule              { cout << "Matched HORIZONTAL LINE TEXT\n"; return HLINE; }
\\par                { cout << "Matched PARAGRAPH\n"; yylval.str = strdup(yytext); return PAR; }
\{                   { cout << "Matched LBRACE\n"; return LBRACE; }
\}                   { cout << "Matched RBRACE\n"; return RBRACE; }
[^{}\n]+             { yylval.str = strdup(yytext); std::cout << "Matched TEXT: " << yytext << "\n"; return TEXT; }
%%

int yywrap() {
    return 1;
}
