# Build the executable
converter: lex.yy.c parser.tab.c
	g++ -o converter main.cpp ast.cpp lex.yy.c parser.tab.c -lfl

# Generate lexer file
lex.yy.c: lexer.l
	flex lexer.l

# Generate parser files
parser.tab.c parser.tab.h: parser.y
	bison -d parser.y

# Run the executable with input and output files
run: converter
	./converter input.tex

# Clean up generated files
clean:
	rm -f converter lex.yy.c parser.tab.c parser.tab.h output.md


# git status
# git add .
# git commit -m "Extending functionality to identify and convert section to header"
# git push origin main
