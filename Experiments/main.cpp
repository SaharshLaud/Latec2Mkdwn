#include <iostream>
#include <fstream>
#include <string>
#include "test_parser.tab.h"
#include "ast.h"
using namespace std;
//input file stream defined in lexer
extern FILE *yyin;

int main(int argc, char **argv)
{
    FILE* input = fopen(argv[1], "r");
    if(!input)
    {
        perror("Input file error");
        return 1;
    }

    yyin = input;

    ofstream output(argv[2]);
    if(!output)
    {
        perror("Output file error");
        fclose(input);
        return 1;
    }

    yyparse();

    //Print AST on console
    cout<<"AST structure:"<<endl;
    printAST(root);

    //Traverse AST and write it to output file
    traverseAST(root, output);
    output.close();
    fclose(input);

    return 0;

}