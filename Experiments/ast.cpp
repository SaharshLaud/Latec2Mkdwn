#include "ast.h"
#include <iostream>
#include <fstream>

using namespace std;

Node* root = nullptr;

Node* createNode(NodeType type, const string& content) {
    Node* node = new Node;
    node->type = type;
    node->content = content;
    node->next = nullptr;
    node->children.clear(); // Initialize children vector
    return node;
}

void addChild(Node* parent, Node* child) {
    if (parent) {
        parent->children.push_back(child);
    }
}

void printAST(Node* node, int level) {
    if (node == nullptr) return;

    for (int i = 0; i < level; i++) {
        cout << " - "; // Indentation for hierarchy
    }

    cout << "Node Type= " << node->type << ", Content= " << node->content << endl;

    for (Node* child : node->children) {
        printAST(child, level + 1);
    }

    // Recursively print siblings
    if (node->next) {
        printAST(node->next, level);
    }
}

void traverseAST(Node* node, ofstream& outFile) {
    while (node) {
        switch (node->type) {
            case SECTION_NODE:
                outFile << "# " << node->content << endl;
                break;
            case SUBSECTION_NODE:
                outFile << "## " << node->content << endl;
                break;
            case SUBSUBSECTION_NODE:
                outFile << "### " << node->content << endl;
                break;
            case ITALIC_NODE:
                outFile << "*" << node->content << "*" << endl;
                break;
            case BOLD_NODE:
                outFile << "**" << node->content << "**" << endl;
                break;
            case HLINE_NODE:
                outFile << "\n---\n" << endl;
                break;
            case PARA_NODE:
                outFile << " " << endl;
                break;
            case TEXT_NODE:
                outFile << node->content;
                break;
            default:
                break;
        }

        // Traverse children first
        for (Node* child : node->children) {
            traverseAST(child, outFile);
        }

        // Move to next sibling
        node = node->next;
    }
}

