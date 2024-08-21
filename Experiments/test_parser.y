%{
#include <stdio.h>
#include <stdlib.h>
#include "ast.h"
#include <iostream>
#include <cstring>

using namespace std;
extern int yylex();
void yyerror(const char *s) { cerr << "Error: " << s << endl; }

extern Node* root; // This is the root of our AST
Node* current_node = nullptr; // Keep track of the current node
Node* last_node = nullptr;    // To link the next sibling nodes
// Declare extractImagePath function
std::string extractImagePath(const char* imageToken);
%}

%union {
    char* str;
}

%token <str> SECTION SUBSECTION SUBSUBSECTION ITALIC BOLD HLINE LBRACE RBRACE TEXT PAR DOCUMENT PACKAGE TITLE DATE HYPERLINK VERBATIM
%type <str> text section subsection subsubsection italic bold hline par doc package title date begin hyperlink code image
%token <str> BEGIN_DOC END_TAG BEGIN_TAG END_DOC IMAGE


%%

document:
        | document doc
        | document package
        | document title
        | document date
        | document begin
        | document section
        | document subsection
        | document subsubsection
        | document italic
        | document bold
        | document hline
        | document par
        | document hyperlink
        | document code
        | document image
        | document TEXT

        {
            Node* node = createNode(TEXT_NODE, $2);
            if (!root) {
                root = node;
                current_node = root;
            } else {
                current_node->next=node;
                current_node = current_node->next;
            }
            last_node = node;
            free($2); // Free the allocated memory for text
        }
        ;

doc: DOCUMENT LBRACE text RBRACE
        {
            Node* node = createNode(DOCUMENT_NODE, $3);
            if (!root) {
                root = node;
                current_node = root;
            } else {
                current_node->next=node;
                current_node = current_node->next;
            }
            last_node = node; // Update last_node to the newly created node
            free($3); // Free the allocated memory for text
        }
        ;

package: PACKAGE LBRACE text RBRACE
        {
            Node* node = createNode(PACKAGE_NODE, $3);
            if (!root) {
                root = node;
                current_node = root;
            } else {
                current_node->next=node;
                current_node = current_node->next;
            }
            last_node = node; // Update last_node to the newly created node

            free($3); // Free the allocated memory for text
        }
        ;

title: TITLE LBRACE text RBRACE
        {
            Node* node = createNode(TITLE_NODE, $3);
            if (!root) {
                root = node;
                current_node = root;
            } else {
                current_node->next=node;
                current_node = current_node->next;
            }
            last_node = node; // Update last_node to the newly created node

            free($3); // Free the allocated memory for text
        }
        ;

date: DATE LBRACE text RBRACE
        {
            Node* node = createNode(DATE_NODE, $3);
            if (!root) {
                root = node;
                current_node = root;
            } else {
                current_node->next=node;
                current_node = current_node->next;
            }
            last_node = node; // Update last_node to the newly created node

            free($3); // Free the allocated memory for text
        }
        ;

begin: BEGIN_DOC
        {
            Node* node = createNode(BEGIN_NODE, "");
            if (!root) {
                root = node;
                current_node = root;
            } else {
                current_node->next=node;
                current_node = current_node->next;
            }
            last_node = node; // Update last_node to the newly created node

        }
        |
        END_DOC
        {
            Node* node = createNode(END_NODE, "");
            if (current_node) {
                current_node->next = node;
                current_node = current_node->next;
            } else {
                last_node->next = node;
            }
            last_node = node; // Update last_node to the newly created node

        }
        ;


section: SECTION LBRACE text RBRACE
        {
            Node* node = createNode(SECTION_NODE, $3);
            if (!root) {
                root = node;
                current_node = root;
            } else {
                current_node->next=node;
                current_node = current_node->next;
            }
            last_node = node; // Update last_node to the newly created node

            free($3); // Free the allocated memory for text
        }
        ;

subsection: SUBSECTION LBRACE text RBRACE
        {
            Node* node = createNode(SUBSECTION_NODE, $3);
            if (current_node) {
                addChild(current_node, node);
            } else {
                current_node->next=node;
                current_node = current_node->next;
            }
            last_node = node; // Update last_node to the newly created node

            free($3); // Free the allocated memory for text
        }
        ;

subsubsection: SUBSUBSECTION LBRACE text RBRACE
        {
            Node* node = createNode(SUBSUBSECTION_NODE, $3);
            if (current_node) {
                addChild(current_node, node);
            } else {
                current_node->next=node;
                current_node = current_node->next;
            }
            last_node = node; // Update last_node to the newly created node

            free($3); // Free the allocated memory for text
        }
        ;

italic: ITALIC LBRACE text RBRACE
        {
            Node* node = createNode(ITALIC_NODE, $3);
            if (current_node) {
                addChild(current_node, node);
            } else {
                current_node->next=node;
                current_node = current_node->next;
            }
            last_node = node; // Update last_node to the newly created node

            free($3); // Free the allocated memory for text
        }
        ;

bold: BOLD LBRACE text RBRACE
        {
            Node* node = createNode(BOLD_NODE, $3);
            if (current_node) {
                addChild(current_node, node);
            } else {
                current_node->next=node;
                current_node = current_node->next;
            }
            last_node = node; // Update last_node to the newly created node

            free($3); // Free the allocated memory for text
        }
        ;

hline: HLINE
        {
            Node* node = createNode(HLINE_NODE, "");
            if (current_node) {
                addChild(current_node, node);
            } else {
                current_node->next=node;
                current_node = current_node->next;
            }
            last_node = node; // Update last_node to the newly created node

        }
        ;

par: PAR
        {
            Node* node = createNode(PARA_NODE, ""); // Create a paragraph node
            if (!root) {
                root = node;
                current_node = root;
            } else {
                current_node->next=node;
                current_node = current_node->next;
            }
            last_node = node; // Update last_node to the newly created node

        }
        ;

hyperlink: HYPERLINK LBRACE text RBRACE LBRACE text RBRACE
        {
            Node* node = createNode(HYPERLINK_NODE, $6, $3);
            if (current_node) {
                addChild(current_node, node);
            } else {
                current_node->next=node;
                current_node = current_node->next;
            }
            last_node = node; // Update last_node to the newly created node

            free($6);
            free($3);
        }
        ;

code: BEGIN_TAG LBRACE VERBATIM RBRACE
    {
        Node* node = createNode(VERBATIM_NODE, "```"); // Start verbatim node
        if (!root) {
            root = node;
            current_node = root;
        } else {
            current_node->next = node;
            current_node = current_node->next;
        }
    }
   
    | END_TAG LBRACE VERBATIM RBRACE
    {
        Node* node = createNode(VERBATIM_NODE, "```"); // End verbatim node
    
        if (current_node) {
            addChild(current_node, node);
            current_node = node->next; // Move to the next node
        }
    }     
    ;
image: IMAGE
        {
            // Extract path from the image token
            std::string imagePath = extractImagePath($1); // Implement this function to parse the path from the token
            Node* node = createNode(IMAGE_NODE, imagePath);
            if (current_node) {
                current_node->next = node;
                current_node = current_node->next;
            } else {
                last_node->next = node;
            }
            last_node = node;
            free($1); // Free the allocated memory for image token
        }
        ;
text: TEXT
     {
         $$ = $1;
     }
    | TEXT PAR
     {
         $$ = $1;
     }

%%

std::string extractImagePath(const char* imageToken) 
{
    std::string token(imageToken);
    size_t startPos = token.find("{") + 1;
    size_t endPos = token.find("}");
    return token.substr(startPos, endPos - startPos);
}