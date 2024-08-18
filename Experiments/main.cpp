#include <iostream>
#include <fstream>
#include <string>
#include "test_parser.tab.h"
#include "ast.h"

using namespace std;

extern FILE *yyin;

int main(int argc, char **argv) {
    if (argc != 3) {
        cerr << "Usage: " << argv[0] << " input.tex output.md" << endl;
        return 1;
    }

    FILE* input = fopen(argv[1], "r");
    if (!input) {
        perror("Input file error");
        return 1;
    }

    yyin = input;

    ofstream output(argv[2]);
    if (!output) {
        perror("Output file error");
        fclose(input);
        return 1;
    }

    yyparse();

    if (root) {
        cout << "AST structure:" << endl;
        printAST(root);
        traverseAST(root, output);
    } else {
        cerr << "Error: No AST created." << endl;
    }

    output.close();
    fclose(input);

    return 0;
}
