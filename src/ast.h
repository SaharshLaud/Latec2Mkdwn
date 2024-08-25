#ifndef AST_H
#define AST_H

#include <vector>
#include <string>
#include <fstream>

/**
 * @brief Enumeration used for various types of nodes in AST.
 */
typedef enum NodeType
{
    NODE_TEXT,            /**< Text Node */
    NODE_DOCUMENT,        /**< Document start node */
    NODE_SECTION,         /**< Section node */
    NODE_SUBSECTION,      /**< Subsection node */
    NODE_SUBSUBSECTION,   /**< Subsubsection node*/
    NODE_BOLD,            /**< Bold text node */
    NODE_ITALICS,         /**< Italic text node */
    NODE_HRULE,           /**< Horizontal line node */
    NODE_PARAGRAPH,       /**< Paragraph node */
    NODE_VERBATIM,        /**< Code node */
    NODE_HYPERLINK,       /**< Hyperlink node */
    NODE_IMAGE,           /**< Image node */
    NODE_DOCCLASS,        /**< Document class node */
    NODE_PACKAGE,         /**< Package inclusion node */
    NODE_TITLE,           /**< Document title node */
    NODE_DATE,            /**< Document date node */
    NODE_BEGINDOC,        /**< Begin Document node */
    NODE_ENDDOC,          /**< End Document node */
    NODE_BEGINUL,         /**< Begin Unordered list node */
    NODE_ENDUL,           /**< End Unordered list node */
    NODE_ITEM             /**< List item node */
} NodeType;

/**
 * @brief Structure used for AST nodes.
 */
typedef struct ASTNode 
{
    NodeType type;                    /**< The type of the node */
    std::string content;              /**< The content of the node */
    std::string url;                  /**< Optional URL or PATH for nodes like HYPERLINK and IMAGE */
    std::vector<ASTNode*> children;   /**< The children of this node */
    ASTNode* next;                    /**< The next sibling node */

    /**
     * @brief Constructor for ASTNode.
     * @param t The type of the node.
     * @param c The content of the node (default: empty string).
     * @param u The URL of the node (optional, default: empty string).
     */
    ASTNode(NodeType t, std::string c = "", std::string u = "") 
        : type(t), content(c), url(u), next(nullptr) {}
} ASTNode;

/**
 * @brief Function to create a new AST node.
 * @param type The type of the node.
 * @param content The content of the node.
 * @param url Optional URL or PATH for nodes like HYPERLINK and IMAGE.
 * @return A pointer to the newly created AST node.
 */
ASTNode* createNode(NodeType type, std::string content, std::string url = "");

/**
 * @brief Fucntion that adds a child node to a parent node.
 * @param parent The parent node.
 * @param child The child node to be added.
 */
void addChild(ASTNode* parent, ASTNode* child);

/**
 * @brief Function to traverse the AST and write the corresponding Markdown output to a file.
 * @param node The root node of the AST.
 * @param outFile The output file stream to write the Markdown content.
 */
void traverseAST(ASTNode* node, std::ofstream& outFile);

/**
 * @brief Function to print the AST structure to the console.
 * @param node The root node of the AST.
 * @param depth The current depth level in the AST (default: 0).
 */
void printAST(ASTNode* node, int depth = 0);

#endif // AST_H
