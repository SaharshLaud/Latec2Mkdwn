#include "ast.h"
#include <iostream>
#include <fstream>

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

void printAST(ASTNode* node, int depth) {
    if (node == nullptr) return;
    
    for (int i = 0; i < depth; i++) std::cout << " - ";
    
    std::cout << "Node Type: " << node->type << ", Content: " << node->content;
    if (!node->url.empty()) std::cout << ", URL: " << node->url;
    std::cout << std::endl;
    
    for (auto child : node->children) {
        printAST(child, depth + 1);
    }
    
    if (node->next != nullptr) {
        printAST(node->next, depth);
    }
}


void traverseAST(ASTNode* node, std::ofstream& outFile) {
    if (node == nullptr) return;
    switch (node->type) {
        case NODE_DOCUMENT:
            for (auto child : node->children) {
                traverseAST(child, outFile);
            }
            break;
        case NODE_SECTION:
            outFile << "# " << node->content;
            break;
        case NODE_SUBSECTION:
            outFile << "## " << node->content;
            break;
        case NODE_SUBSUBSECTION:
            outFile << "### " << node->content;
            break;
        case NODE_BOLD:
            outFile << "**" << node->content << "**";
            break;
        case NODE_ITALICS:
            outFile << "*" << node->content << "*";
            break;
        case NODE_HRULE:
            outFile << "\n---\n";
            break;
        case NODE_PARAGRAPH:
            outFile << "\n" ;
            break;
        case NODE_VERBATIM:
            outFile << "```" << node->content << "```";
            break;
        case NODE_HYPERLINK:
            outFile << "[" << node->content << "](" << node->url << ")";
            break;
        case NODE_IMAGE:
            outFile << "![alt text]" << "(" << node->url << ")";
            break;
        case NODE_TEXT:
            outFile << node->content;
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

        case NODE_TABLE:
            if (!node->tableData.empty()) {
                // Output table header
                outFile << "| ";
                for (const auto& cell : node->tableData[0]) {
                    outFile << cell << " | ";
                }
                outFile << "\n|";
                for (size_t i = 0; i < node->tableData[0].size(); ++i) {
                    outFile << "---|";
                }
                outFile << "\n";

                // Output table body
                for (size_t i = 1; i < node->tableData.size(); ++i) {
                    outFile << "| ";
                    for (const auto& cell : node->tableData[i]) {
                        outFile << cell << " | ";
                    }
                    outFile << "\n";
                }
            }
            break;


        default:
            break;
        
    }
    if (node->next != nullptr) {
        traverseAST(node->next, outFile);
    }
}