#
# Mini-C compiler iteration 1
# - do 'make test' and read the rule to see a complete
#   example execution (note: this ONLY works on a computer
#   that has an X86-64 CPU (Intel, AMD); a Mac probably needs
#   slightly different assembly code output from our compiler
# - do 'make clean' to remove all generated files
#

# make variables (all caps) that define the compiler to use (CC)
# and the option flags to give it (CFLAGS). Built-in rules for 
# compiling C programs use these variables.
CFLAGS = -I. -Wall -Wno-unused-function -g
CC = gcc

# default target rule must come first, so we just make it depend on
# our compiler rule
all: mycc

# yacc nice opts: -d -t -v
y.tab.c: parser.y
	yacc -d parser.y

# lex nice opts: -d -T
lex.yy.c: scanner.l y.tab.c
	lex scanner.l

# our compiler target: links the scanner and 
# parser into a single executable named 'mycc'
mycc: lex.yy.o y.tab.o
	gcc -o mycc y.tab.o lex.yy.o

clean: 
	rm -f lex.yy.c a.out y.tab.c y.tab.h *.o mycc t.s

test: mycc
	./mycc test.c > t.s
	gcc t.s
	./a.out

# this does not work, lex only mode needs more definitions and
# would clutter the lex input file scanner.l
# todo?: may need -ll for linking lexer as standalone
lextest: lex.yy.c
	gcc -o lextest -DLEXONLY lex.yy.c

