#include "parser.tab.h"
#include "ast.h"
#include <fstream>
#include <iostream>

extern ASTNode* root;
extern FILE* yyin;
extern int yylex();
extern int yyparse();
extern int yydebug;
int main(int argc, char **argv) {
    yydebug = 1;
    if (argc != 3) {
        std::cerr << "Usage: " << argv[0] << " input.tex output.md" << std::endl;
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        std::cerr << "Error: Cannot open file " << argv[1] << std::endl;
        return 1;
    }

    int parseResult = yyparse();
    if (parseResult == 0 && root != nullptr) {
        std::cout << "Parsing successful. AST structure:" << std::endl;
        printAST(root);

        std::ofstream outFile(argv[2]);
        if (!outFile) {
            std::cerr << "Error: Cannot open " << argv[2] << " for writing" << std::endl;
            return 1;
        }

        traverseAST(root, outFile);
        std::cout << "Markdown output generated successfully in " << argv[2] << std::endl;
    } else {
        std::cerr << "Error: Parsing failed or AST root is null." << std::endl;
    }

    if (yyin) {
        fclose(yyin);
    }

    return 0;
}