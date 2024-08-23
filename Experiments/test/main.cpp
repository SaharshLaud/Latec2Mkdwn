#include "parser.tab.h"
#include "ast.h"
#include <fstream>
#include <iostream>

extern ASTNode* root;
extern FILE* yyin;
extern int yydebug;

int main(int argc, char **argv) {
    yydebug = 1;  // Enable debug output

    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            std::cerr << "Error: Cannot open file " << argv[1] << std::endl;
            return 1;
        }
    }

    int parseResult = yyparse();
    std::cout << "Parse result: " << parseResult << std::endl;

    if (parseResult == 0 && root != nullptr) {  // Parsing was successful and root is not null
        std::ofstream outfile("output.md");
        if (!outfile) {
            std::cerr << "Error: Cannot open output.md for writing" << std::endl;
            return 1;
        }
       
        std::streambuf *coutbuf = std::cout.rdbuf();
        std::cout.rdbuf(outfile.rdbuf());
        printMarkdown(root);
        std::cout.rdbuf(coutbuf);
        std::cout << "Markdown output generated successfully." << std::endl;
    } else {
        std::cerr << "Error: Parsing failed or AST root is null." << std::endl;
    }

    if (yyin) {
        fclose(yyin);
    }

    return 0;
}