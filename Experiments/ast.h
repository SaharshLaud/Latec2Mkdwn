#ifndef AST_H
#define AST_H

#include <string>
#include <vector>
#include <fstream>

using namespace std;

enum NodeType {
    SECTION_NODE,
    TEXT_NODE,
    SUBSECTION_NODE,
    SUBSUBSECTION_NODE,
    ITALIC_NODE,
    BOLD_NODE,
    HLINE_NODE,
    PARA_NODE,
    DOCUMENT_NODE,
    PACKAGE_NODE,
    TITLE_NODE,
    DATE_NODE,
    BEGIN_NODE,
    END_NODE,
    HYPERLINK_NODE,  // New node type for hyperlinks
};

struct Node {
    NodeType type;
    string content;
    string url;          // URL for hyperlink nodes or path for img nodes
    vector<Node*> children;  // Vector to hold child nodes
    Node* next;              // Pointer to sibling node
};

extern Node* root;

Node* createNode(NodeType type, const string& content, const string& url = "");
void addChild(Node* parent, Node* child);
void printAST(Node* node, int level = 1);
void traverseAST(Node* node, ofstream& outFile);

#endif
