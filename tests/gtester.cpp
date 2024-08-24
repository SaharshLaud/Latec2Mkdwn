#include <gtest/gtest.h>
#include "ast.h"
#include "parser.tab.h"
#include <fstream>

extern ASTNode* root;
extern FILE* yyin;
extern int yyparse();

void parse_string(const std::string& input) {
    yyin = fmemopen((void*)input.c_str(), input.length(), "r");
    yyparse();
    fclose(yyin);
}

void get_markdown_output(const std::string& filename) {
    std::string outputDir = "tests/";

    std::string outputPath = outputDir + "/" + filename;
    std::ofstream outFile(outputPath);
    if (!outFile) {
        std::cerr << "Error: Cannot open " << outputPath << " for writing" << std::endl;
        return;
    }
    traverseAST(root, outFile);
    outFile.close();
}

std::string read_file(const std::string& filename) {
    std::string filePath = "tests/" + filename;
    std::ifstream file(filePath);
    if (!file) {
        std::cerr << "Error: Cannot open file";
        return "";
    }
    std::stringstream buffer;
    buffer << file.rdbuf();
    return buffer.str();
}



// Test for creating a node
TEST(ASTTest, CreateNodeTest) {
    ASTNode* node = createNode(NODE_SECTION, "Test Section");
    EXPECT_EQ(node->type, NODE_SECTION);
    EXPECT_EQ(node->content, "Test Section");
    EXPECT_EQ(node->url, "");
    delete node;
}

// Test for Section
TEST(FeatureTest, Section) {
    parse_string("\\section{Introduction}");
    get_markdown_output("gtest_output.md");
    EXPECT_EQ(read_file("gtest_output.md"), "# Introduction");
}

// Test for Subsection
TEST(FeatureTest, Subsection) {
    parse_string("\\subsection{Methodology}");
    get_markdown_output("gtest_output.md");
    EXPECT_EQ(read_file("gtest_output.md"), "## Methodology");
}

// Test for Subsubsection
TEST(FeatureTest, Subsubsection) {
    parse_string("\\subsubsection{Detailed Approach}");
    get_markdown_output("gtest_output.md");
    EXPECT_EQ(read_file("gtest_output.md"), "### Detailed Approach");
}

// Test for Bold
TEST(FeatureTest, BoldText) {
    parse_string("\\textbf{Hello}");
    get_markdown_output("gtest_output.md");
    EXPECT_EQ(read_file("gtest_output.md"), "**Hello**");
}

// Test for Italic
TEST(FeatureTest, ItalicText) {
    parse_string("\\textit{World}");
    get_markdown_output("gtest_output.md");
    EXPECT_EQ(read_file("gtest_output.md"), "*World*");
}

// Test for Horizontal Line
TEST(FeatureTest, HorizontalLine) {
    parse_string("\\hrule");
    get_markdown_output("gtest_output.md");
    EXPECT_EQ(read_file("gtest_output.md"), "\n---\n");
}

// Test for Paragraph
TEST(FeatureTest, Paragraph) {
    parse_string("\\par");
    get_markdown_output("gtest_output.md");
    EXPECT_EQ(read_file("gtest_output.md"), "\n");
}

// Test for Code Verbatim
TEST(FeatureTest, CodeVerbatim) {
    parse_string("\\begin{verbatim}int main() { return 0; }\\end{verbatim}");
    get_markdown_output("gtest_output.md");
    EXPECT_EQ(read_file("gtest_output.md"), "```int main() { return 0; }```");
}

// Test for Hyperlink
TEST(FeatureTest, Hyperlink) {
    parse_string("\\href{https://example.com}{Example}");
    get_markdown_output("gtest_output.md");
    EXPECT_EQ(read_file("gtest_output.md"), "[Example](https://example.com)");
}

// Test for Images
TEST(FeatureTest, Image) {
    parse_string("\\includegraphics{image.jpg}");
    get_markdown_output("gtest_output.md");
    EXPECT_EQ(read_file("gtest_output.md"), "![alt text](image.jpg)");
}

int main(int argc, char **argv) {
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}