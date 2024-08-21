#include "ast.h"
#include <iostream>
#include <fstream>

using namespace std;

Node* root = nullptr;
Node* document_root = nullptr; // Root of the document content

Node* createNode(NodeType type, const string& content, const string& url) {
    Node* node = new Node;
    node->type = type;
    node->content = content;
    node->url = url;   // Set URL for hyperlinks
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

    cout << "Node Type= " << node->type << ", Content= " << node->content;
    if (node->type == HYPERLINK_NODE) {
        cout << ", URL= " << node->url; // Print URL for hyperlink nodes
    }

    
    cout << endl;

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
            case DOCUMENT_NODE:
                // Document node itself is not directly converted
                break;
            case PACKAGE_NODE:
                outFile << "";
                break;
            case TITLE_NODE:
                outFile << "";
                break;
            case DATE_NODE:
                outFile << "";
                break;
            case BEGIN_NODE:
                // Start of the document; node is not used directly
                break;
            case END_NODE:
                // End of the document; node is not used directly
                break;
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
                outFile << endl; // Paragraph separation
                break;
            case TEXT_NODE:
                outFile << node->content;
                break;
            case HYPERLINK_NODE:
                outFile << "[" << node->content << "](" << node->url << ")" << endl;
                break;
            case IMAGE_NODE:
                outFile << "![" << "alt text" << "](" << node->content << ")" << endl;
                break;
            case VERBATIM_NODE:
                outFile << "\n```" << endl;
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

