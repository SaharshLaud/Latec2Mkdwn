#include "ast.h"
#include <iostream>
#include <fstream>
using namespace std;

// Defining root as global variable and initializing to null pointer
Node* root = nullptr;

// Function definition of createNode
Node* createNode(NodeType type, const string& content) 
{
    Node* node = new Node;
    node->type = type;
    node->content = content;
    node->next = nullptr;
    return node;
}

// Function definition of printAST
void printAST(Node* node, int level)
{
    // base case
    if (node == nullptr) return;

    // Adding spaces for tree level along with level number
    for (int i = 0; i < level; i++) 
    {
        if(i+1 == level) cout << i<<" ";
        else cout<< " ";
    }

    // Printing node type and content
    cout << "Node Type= " << node->type << ", Content= " << node->content << endl;

    // Recursive call to print next nodes
    printAST(node->next, level + 1);
}

// Function definition of traverseAST
void traverseAST(Node* node, ofstream& outFile)
{
    while (node) 
    {
        if (node->type == SECTION_NODE) 
        {
            outFile << "# " << node->content << endl;
        }
        else if (node->type == TEXT_NODE) 
        {
            // Handle unmatched text
            outFile << node->content << endl;
        }
        node = node->next;
    }
}
