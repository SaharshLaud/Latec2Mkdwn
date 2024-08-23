#ifndef AST_H
#define AST_H

#include <vector>
#include <string>
#include <fstream>


typedef enum NodeType {
    NODE_TEXT,
    NODE_DOCUMENT,
    NODE_SECTION,
    NODE_SUBSECTION,
    NODE_SUBSUBSECTION,
    NODE_BOLD,
    NODE_ITALICS,
    NODE_HRULE,
    NODE_PARAGRAPH,
    NODE_VERBATIM,
    NODE_HYPERLINK,
    NODE_IMAGE,
    NODE_DOCUMENTCLASS,
    NODE_PACKAGE,
    NODE_TITLE,
    NODE_DATE,
    NODE_BEGIN_DOC,
    NODE_END_DOC
} NodeType;

typedef struct ASTNode {
    NodeType type;
    std::string content;
    std::string url; // Optional URL for nodes like HYPERLINK and IMAGE
    std::vector<ASTNode*> children;
    ASTNode* next;

    // Constructor updated to include optional URL parameter with default value
    ASTNode(NodeType t, std::string c = "", std::string u = "") 
        : type(t), content(c), url(u), next(nullptr) {}
} ASTNode;

// Function prototype updated to handle optional URL parameter
ASTNode* createNode(NodeType type, std::string content, std::string url = "");

// Function prototypes for other operations
void addChild(ASTNode* parent, ASTNode* child);
void traverseAST(ASTNode* node, std::ofstream& outFile);
void printAST(ASTNode* node, int depth = 0);

#endif // AST_H
