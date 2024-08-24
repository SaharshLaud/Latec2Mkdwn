# Directories
SRC_DIR = src
BUILD_DIR = build
TEST_DIR = tests
TEST_FILE = $(TEST_DIR)/testfile/section.tex

# Executable
EXEC = $(BUILD_DIR)/converter

# Compiler flags
CXXFLAGS = -Isrc -I$(BUILD_DIR) -std=c++11

# Building main executable
$(EXEC): $(BUILD_DIR)/lex.yy.c $(BUILD_DIR)/parser.tab.c
	g++ -o $(EXEC) $(CXXFLAGS) $(SRC_DIR)/main.cpp $(SRC_DIR)/ast.cpp $(BUILD_DIR)/lex.yy.c $(BUILD_DIR)/parser.tab.c -lfl

# Generating lexer file
$(BUILD_DIR)/lex.yy.c: $(SRC_DIR)/lexer.l
	flex $(SRC_DIR)/lexer.l

# Generating parser files
$(BUILD_DIR)/parser.tab.c $(BUILD_DIR)/parser.tab.h: $(SRC_DIR)/parser.y
	bison -d $(BUILD_DIR)/parser.tab.c $(SRC_DIR)/parser.y

# Running executable with input and output files
run: $(EXEC)
	./run.sh input.tex output.md

# Cleaning generated files
clean:
	rm -f $(EXEC) $(BUILD_DIR)/lex.yy.c $(BUILD_DIR)/parser.tab.c $(BUILD_DIR)/parser.tab.h output.md

# Libraries
LIBS = -lgtest -lgtest_main -pthread

# Testing executable
TEST_EXEC = $(BUILD_DIR)/gtester

# Gtest source file
TEST_SRC = $(TEST_DIR)/gtester.cpp

# Building the test executable
$(TEST_EXEC): $(BUILD_DIR)/lex.yy.c $(BUILD_DIR)/parser.tab.c $(SRC_DIR)/ast.cpp
	g++ -o $(TEST_EXEC) $(CXXFLAGS) $(TEST_SRC) $(SRC_DIR)/ast.cpp $(BUILD_DIR)/lex.yy.c $(BUILD_DIR)/parser.tab.c $(LIBS)

# Runing gtests
test: $(TEST_EXEC)
	$(TEST_EXEC) $(TEST_FILE)
