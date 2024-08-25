#include "parser.tab.h"
#include "ast.h"
#include <fstream>
#include <iostream>
using namespace std;

extern ASTNode* root;
extern FILE* yyin;
extern int yylex();
extern int yyparse();

/**
 * @brief This is the entry point of the program.
 * 
 * Here we are parsing by reading an input LaTeX file and generating an AST.
 * The AST is then traversed to produce a corresponding Markdown file.
 * In case any file opening error or parsing error occurs then it is also handled.
 */

int main(int argc, char **argv) 
{
    if(argc != 3) 
    {
        cerr<<"Format: "<<argv[0]<<" input.tex output.md"<<endl;
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if(!yyin) 
    {
        cerr<<"Error: Cannot open file "<<argv[1]<<endl;
        return 1;
    }

    int finalparse = yyparse();
    if(finalparse == 0 && root != nullptr) 
    {
        cout<<"Parsing has been successful. AST structure:"<<endl;
        printAST(root);

        ofstream outFile(argv[2]);
        if(!outFile)
        {
            cerr<<"Error: Cannot open "<<argv[2]<<" for writing"<<endl;
            return 1;
        }

        traverseAST(root, outFile);
        cout<<"Markdown output generated successfully in "<<argv[2]<<endl;
    } 
    else 
    {
      cerr<<"Error: Either Parsing has failed or root of AST is null."<<endl;
    }

    if(yyin) 
    {
        fclose(yyin);
    }

    return 0;
}