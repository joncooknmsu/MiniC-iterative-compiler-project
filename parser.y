/*
* Parser definition for Mini-C iteration 1
* - since this iteration is fairly simple, all needed functions,
*   including main(), are also in this file.
* - this solution frees most everything, but the student assignment
*   does not require them to free anything.
*/

%{
/* Header definitions section */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
/* function prototypes for functions below grammar */
int addString(char *str);
void outputDataSec();
int yyerror(char *s);
int yylex(void);
/* global variables */
int functionNum=1; /* for unique labels per function */
int debug=0; /* set to 1+ to turn on debugging */
/* end header definitions */
%}

/* token and nonterminal value data types */
%union { int ival; char* str; }

%start program
/* All nonterminal actions generate a code string (returned as $$) */
%type <str> function statements statement funcall

/* Token types */
%token <ival> NUMBER COMMA SEMICOLON LPAREN RPAREN LBRACE RBRACE
%token <str>  ID STRING 

%%
/* Grammar Rules */

program: function
     {
        if (debug) fprintf(stderr,"full program def!\n"); 
        outputDataSec();
        printf("\t.text\n%s\n",$1);
        free($1);
     }

function: ID LPAREN RPAREN LBRACE statements RBRACE
     {
        if (debug) fprintf(stderr,"function def!\n"); 
        char *code = (char*) malloc(512+strlen($5));
        /* C syntax allows multiple string constants in a row, and
           it just concatenates them; used for good code formatting */
        sprintf(code,"\t.globl\t%s\n\t.type\t%s, @function\n%s:\n.LFB%d:"
                "\n\t.cfi_startproc\n\tpushq\t%%rbp\n\t.cfi_def_cfa_offset 16"
                "\n\t.cfi_offset 6, -16\n\tmovq\t%%rsp, %%rbp"
                "\n\t.cfi_def_cfa_register 6\n%s\tmovq\t$0,%%rax"
                "\n\tpopq\t%%rbp\n\t.cfi_def_cfa 7, 8\n\tret"
                "\n\t.cfi_endproc\n.LFE%d:\n.size\t%s, .-%s\n",
                $1,$1,$1,functionNum,$5,functionNum,$1,$1);
        functionNum++;
        free($5);
        $$ = code;
     }

statements: /* empty */ { $$ = strdup(""); }
     | statement statements
     {
        if (debug) fprintf(stderr,"statements def!\n");
        char *code = (char*) malloc(strlen($1)+strlen($2)+5);
        strcpy(code,$1);
        strcat(code,$2);
        $$ = code;
        free($1);
        free($2);
     }

statement: funcall
     {
        if (debug) fprintf(stderr,"statement def!\n"); $$ = $1;
     }

funcall: ID LPAREN STRING RPAREN SEMICOLON
     {
        if (debug) fprintf(stderr,"function call!\n");
        int sid = addString($3);
        char *code = (char*) malloc(128);
        sprintf(code,"\tleaq\t.LC%d(%%rip), %%rdi\n\tcall\t%s@PLT\n",sid,$1);
        $$ = code;
     }
      
%%
/* Functions */

/* global variables to keep track of string constants */
int stringCount = 0;
char *strings[100]; /* a real compiler needs a dynamic table */

/* save a new string constant in the string table, return its ID */
int addString(char* str)
{
   int i = stringCount++;
   strings[i] = strdup(str);
   return i;
}

/* output the assembly code data section and free string constants */
void outputDataSec()
{
   int i;
   printf("\t.text\n\t.section\t.rodata\n");
   for (i=0; i < stringCount; i++) {
      printf(".LC%d:\n\t.string\t%s\n",i,strings[i]);
      free(strings[i]);
      strings[i] = NULL;
   }
}

extern FILE* yyin; /* used by scanner to read file input */

/*
* main: only takes a single command line argument, the input filename
* - if no arg, uses stdin
*/
int main(int argc, char** argv)
{
   int stat;
   if (argc > 2) {
      fprintf(stderr,"Error: too many arguments!\n");
      return 1;
   }
   yyin = stdin; /* if no args, just use stdin */
   if (argc == 2) {
      yyin = fopen(argv[1],"r");
      if (!yyin) {
         fprintf(stderr,"Error: unable to open (%s)\n", argv[1]);
         return 2;
      }
   }
   stat = yyparse();
   if (yyin != stdin)
      fclose(yyin);
   return(stat);
}

extern int yylineno; /* for syntax error messages below */

int yyerror(char* s)
{
   fprintf(stderr, "line %d: %s\n",yylineno,s);
   return 0;
}

int yywrap()
{
   return(1);
}

