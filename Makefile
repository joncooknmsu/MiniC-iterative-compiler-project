#
# Mini-C compiler iteration 1
# - do 'make test' and read the rule to see a complete
#   example execution
#

CFLAGS = -I. -Wall -Wno-unused-function -g
CC = gcc

all: mycc

# yacc nice opts: -d -t -v
y.tab.c: parser.y
	yacc -d parser.y

# lex nice opts: -d -T
lex.yy.c: scanner.l y.tab.c
	lex scanner.l

# -ll for compiling lexer as standalone
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
lextest: lex.yy.c
	gcc -o lextest -DLEXONLY lex.yy.c

