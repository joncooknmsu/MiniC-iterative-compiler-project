#
# Make file for simple scanner and parser example
# - note: lex and yacc are tools that are meant to be
#   used together, by using the output of the lex part
#   be used as input to the yacc part. It can be useful
#   to debug your lex part all by itself, and so this
#   Makefile and the lex code itself has the ability
#   to do this
#

# flags and defs for built-in compiler rules
CFLAGS = -I. -Wall -Wno-unused-function
CC = gcc

# default rule, build the parser into a 'lyexample' executable
all: lyexample

# yacc "-d" flag creates the y.tab.h header, used by the lex code
y.tab.c: parser.y
	yacc -d parser.y

# lex rule includes y.tab.c to force yacc to run first
# lex "-d" flag turns on debugging output, if you want it
lex.yy.c: scanner.l y.tab.c
	lex scanner.l

# lyexample executable needs both scanner and parser object files
lyexample: lex.yy.o y.tab.o
	gcc -o lyexample y.tab.o lex.yy.o

# example test run of the program using file input redirection
# - do "make test" from the command line to use this
test: lyexample
	./lyexample < test1.txt

# ltest is a standalone lexer (scanner)
# - build this by doing "make ltest"
# (todo: look into -ll for compiling lexer as standalone)
ltest: scanner.l
	lex scanner.l
	gcc -DLEXONLY lex.yy.c -o ltest 

# clean the directory for a pure rebuild (do "make clean")
clean: 
	rm -f lex.yy.c a.out y.tab.c y.tab.h *.o lyexample ltest

