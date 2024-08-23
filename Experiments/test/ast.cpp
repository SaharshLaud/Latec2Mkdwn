#include "ast.h"
#include <iostream>
using namespace std;
// Definition of createNode function with URL parameter
ASTNode* createNode(NodeType type, std::string content, std::string url) {
    return new ASTNode(type, content, url);
}

void addChild(ASTNode* parent, ASTNode* child) {
    if (parent != nullptr) {
        parent->children.push_back(child);
    }
}

void printMarkdown(ASTNode* node) {
    if (node == nullptr) return;

    switch (node->type) {
        case NODE_DOCUMENT:
            for (auto child : node->children) {
                printMarkdown(child);
            }
            break;
        case NODE_SECTION:
            std::cout << "# " << node->content;
            break;
        case NODE_SUBSECTION:
            std::cout << "## " << node->content;
            break;
        case NODE_SUBSUBSECTION:
            std::cout << "### " << node->content;
            break;
        case NODE_BOLD:
            std::cout << "**" << node->content << "**";
            break;
        case NODE_ITALICS:
            std::cout << "*" << node->content << "*";
            break;
        case NODE_HRULE:
            std::cout << "\n---\n";
            break;
        case NODE_PARAGRAPH:
            std::cout << "\n" ;
            break;
        case NODE_VERBATIM:
            std::cout << "```" << node->content << "```";
            break;
        case NODE_HYPERLINK:
            std::cout << "[" << node->content << "](" << node->url << ")";
            break;
        case NODE_IMAGE:
            std::cout << "![alt text]" << "(" << node->url << ")";
            break;
        case NODE_TEXT:
            std::cout << node->content;
            break;
        case NODE_DOCUMENTCLASS:
            break;
        case NODE_PACKAGE:
            break;
        case NODE_TITLE:
            break;
        case NODE_DATE:
            break;
        case NODE_BEGIN_DOC:
            break;
        case NODE_END_DOC:
            break;
        default:
            break;
    }

    if (node->next != nullptr) {
        printMarkdown(node->next);
    }
}
