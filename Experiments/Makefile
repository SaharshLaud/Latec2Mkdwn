# Build the executable
converter: lex.yy.c test_parser.tab.c
	g++ -o converter main.cpp ast.cpp lex.yy.c test_parser.tab.c -lfl

# Generate lexer file
lex.yy.c: test_lexer.l
	flex test_lexer.l

# Generate parser files
test_parser.tab.c test_parser.tab.h: test_parser.y
	bison -d test_parser.y

# Run the executable with input and output files
run: converter
	./converter input.tex output.md

# Clean up generated files
clean:
	rm -f converter lex.yy.c test_parser.tab.c test_parser.tab.h output.md
