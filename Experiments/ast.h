#include <string>
#include <fstream>
using namespace std;

enum NodeType {
    SECTION_NODE,
    TEXT_NODE // Added new node type for free text
};

struct Node {
    NodeType type;
    string content;
    Node* child;  // Pointer to child node
    Node* next;   // Pointer to sibling node
};

extern Node* root;

Node* createNode(NodeType type, const string& content);
void printAST(Node* node, int level = 1);
void traverseAST(Node* node, ofstream& outFile);
