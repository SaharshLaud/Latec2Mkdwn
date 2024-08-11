//This header file is used to define the functions and structures for Node of Abstract Syntax Tree

#include <string>

//This header will handle input as tex file and output as md file
#include <fstream> 
using namespace std;

//Here we will have the different types of node for various latex elements
enum NodeType{ SECTION_NODE }; 

//Here we are actually defining a node of a particular element type
struct Node {
    NodeType type;
    string content;
    Node* next;
};

extern Node* root;

//Function prototypes that will be used in AST traversal and print
Node* createNode(NodeType type, const string& content);
void printAST(Node* node, int level = 0);

//Traverse AST and write output to md file
void traverseAST(Node* node, ofstream& outFile); 