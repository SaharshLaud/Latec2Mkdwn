#include "ast.h"
#include <iostream>
#include <fstream>

using namespace std;

/**
 * @brief Array of node type names used to map node type to its name while printing the AST Tree structure.
 */
const char* nodeTypeNames[] = {
    "TEXT",
    "START",
    "SECTION",
    "SUBSECTION",
    "SUBSUBSECTION",
    "BOLD",
    "ITALICS",
    "HRULE",
    "NEWLINE",
    "VERBATIM",
    "HYPERLINK",
    "IMAGE",
    "DOCUMENTCLASS",
    "PACKAGE",
    "TITLE",
    "DATE",
    "BEGINDOC",
    "ENDDOC",
    "BEGINUL",
    "ENDUL",
    "ITEM"
};

/**
 * @brief Definition of createNode function with URL parameter
 * @return A pointer to the newly created AST node.
 */
ASTNode* createNode(NodeType type, std::string content, std::string url) {
    return new ASTNode(type, content, url);
}


/**
 * @brief Definition of addChild function
 * @param parent The parent node to which the child will be added.
 * @param child The child node to add.
 */
void addChild(ASTNode* parent, ASTNode* child) {
    if (parent != nullptr) {
        parent->children.push_back(child);
    }
}

/**
 * @brief Definition of printAST function.
 */
void printAST(ASTNode* node, int depth) {
    if (node == nullptr) return;
    
    for (int i = 0; i < depth; i++)
    {
         if(node->type==NODE_ITEM) cout << " -- ";
         else cout << " - ";

    }
    
    std::cout << "Node: " << nodeTypeNames[node->type] << ", Content: " << node->content;
    if (!node->url.empty()) cout << ", URL: " << node->url;
    cout << endl;
    
    for (auto child : node->children) 
    {
        printAST(child, depth + 1);
    }
    
    if (node->next != nullptr)
    {
        printAST(node->next, depth);
    }
}

/**
 * @brief Definition of traverseAST function.
 */
void traverseAST(ASTNode* node, std::ofstream& outFile) 
{
    if (node == nullptr) return;
    switch (node->type) 
    {
        case NODE_DOCUMENT:
            for (auto child : node->children) 
            {
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
        case NODE_ITEM:
            outFile << "- " << node->content;
            break;
        case NODE_TEXT:
            outFile << node->content;
            break;
        case NODE_DOCCLASS:
            break;
        case NODE_PACKAGE:
            break;
        case NODE_TITLE:
            break;
        case NODE_DATE:
            break;
        case NODE_BEGINDOC:
            break;
        case NODE_ENDDOC:
            break;
        case NODE_BEGINUL:
            break;
        case NODE_ENDUL:
            break;
        default:
            break;
        
    }
    if (node->next != nullptr) 
    {
        traverseAST(node->next, outFile);
    }
}