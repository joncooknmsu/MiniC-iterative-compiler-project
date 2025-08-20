/*****
* Yacc parser for simple example (left recursion version)
*
* The grammar in this example is:
* all -> phrases
* phrases -> <empty>
* phrases -> phrases NUMBER PLUS NUMBER
* phrases -> phrases NUMBER
* phrases -> phrases STRING
* 
* The tokens that come from the scanner are: NUMBER, PLUS, and STRING. 
* The scanner skips all whitespace (space, tab, newline, and carriage return).
* The lexemes of the token NUMBER are strings of digits ('0'-'9'). 
* The lexeme of PLUS is only a string consisting of the plus symbol ('+').
* The lexemes of the token STRING are strings of characters that do not 
* include whitespace, digits, or the plus symbol.
* 
* Given the input "acb 42 +34 52this is", the scanner would produce 
* the tokens (with lexemes) of:
* <STRING,"abc">, <NUMBER,"42">, <PLUS,"+">, <NUMBER,"34">, <NUMBER,"52">,
* <STRING,"this">, <STRING,"is">
* 
* and this would match the grammar.
*
* This example also shows building up and returning a string
* through all the parsing rules, and then printing it out when
* the grammar is done matching the input. This is VERY similar
* to how we will initially build up assembly code!
*****/

/****** Header definitions ******/
%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
// function prototypes from lex
int yyerror(char *s);
int yylex(void);
int debug=1; // set to 1 to turn on extra printing

/*
* Defs below are not used in this code, but this can be used 
* in your compiler to save the constant strings that need output
* in the data section of the assembly output 
*/
char* savedStrings[100];
int lastStringIndex=0;

%}

/* token value data types */
%union { int ival; char* str; }

/* Starting non-terminal */
%start all
%type <str> phrases

/* Token types */
%token <ival> NUMBER PLUS
%token <str> STRING

%%
/******* Rules *******/

all: phrases 
     {
         printf("--- begin official output ---\n");
         printf("Write a preamble here...\n");
         printf("ALL: {\n%s}\n",$1);
         printf("Write a postscript here...\n");
     }

phrases: /*empty*/
       { $$ = "\tempty\n"; }
     | phrases NUMBER PLUS NUMBER
       { 
          // printf is just for informational/debugging purposes
          if (debug) printf("yacc: add %d %d is %d\n",$2,$4,$2+$4);
          // allocate space enough for the result string
          $$ = (char*) malloc(strlen($1)+48);
          // create combined output string by adding this
          // rule's acronym to front of other phrases
          sprintf($$,"%s\tadd(%d+%d)\n",$1,$2,$4);
       }
     | phrases NUMBER
       {
          if (debug) printf("yacc: number %d\n",$2);
          $$ = (char*) malloc(strlen($1)+24);
          sprintf($$,"%s\tnum(%d)\n",$1,$2);
       }
     | phrases STRING
       {
          if (debug) printf("yacc: string [%s]\n",$2);
          $$ = (char*) malloc(strlen($1)+strlen($2)+8);
          sprintf($$,"%s\tstr(%s)\n",$1,$2);
       }
     ;
%%
/******* Functions *******/
extern FILE *yyin; // from lex, the input file handle

int main(int argc, char **argv)
{
   int stat;
   if (argc == 1) {
      yyin = stdin;
   } else if (argc == 2) {
      yyin = fopen(argv[1],"r");
      if (!yyin) {
         fprintf(stderr,"Error: unable to open file (%s)\n",argv[1]);
         return 1;
      }
   } else {
      fprintf(stderr,"Usage: %s [inputfilename]\n",argv[0]);
      return 1;
   }
   // now invoke the parser
   stat = yyparse();
   if (stat) {
      fprintf(stderr,"Parsing error, stat = %d\n",stat);
   }
   return stat;
}

extern int yylineno; // from lex, allows syntax errors to print line #

int yyerror(char *s)
{
   fprintf(stderr, "Syntax error: line %d: %s\n",yylineno,s);
   return 0;
}

int yywrap()
{
   return(1);
}

