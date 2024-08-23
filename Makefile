# Directories
SRC_DIR = src
BUILD_DIR = build
TEST_DIR = tests

# Executable
EXEC = $(BUILD_DIR)/converter

# Compiler flags
CXXFLAGS = -Isrc -I$(BUILD_DIR)


# Build the executable
$(EXEC): $(BUILD_DIR)/lex.yy.c $(BUILD_DIR)/parser.tab.c
	g++ -o $(EXEC) $(CXXFLAGS) $(SRC_DIR)/main.cpp $(SRC_DIR)/ast.cpp $(BUILD_DIR)/lex.yy.c $(BUILD_DIR)/parser.tab.c -lfl

# Generate lexer file
$(BUILD_DIR)/lex.yy.c: $(SRC_DIR)/lexer.l
	flex -o $@ $<

# Generate parser files
$(BUILD_DIR)/parser.tab.c $(BUILD_DIR)/parser.tab.h: $(SRC_DIR)/parser.y
	bison -d -o $(BUILD_DIR)/parser.tab.c $(SRC_DIR)/parser.y

# Run the executable with input and output files
run: $(EXEC)
	./run.sh input.tex output.md

# Clean up generated files
clean:
	rm -f $(EXEC) $(BUILD_DIR)/lex.yy.c $(BUILD_DIR)/parser.tab.c $(BUILD_DIR)/parser.tab.h output.md

.PHONY: all clean run
