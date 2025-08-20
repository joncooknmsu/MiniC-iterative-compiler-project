
/* Header definitions */
%{
#include <stdio.h>
#include <stdlib.h>

#ifndef LEXONLY
  /* we get token types from yacc */
  #include <y.tab.h>
  extern int debug;
#else
  /* this is used only if testing scanner independently */
  typedef union { int ival; char* str; } yystype;
  #define YYSTYPE yystype
  int debug=1;
  // still need to define all tokens here..., so this doesn't work
#endif
%}

%option yylineno

/* RegExp Patterns */
%%
[0-9]+   {
            if (debug) fprintf(stderr,"NUM: (%s)\n", yytext);
            yylval.ival = strtol(yytext,0,10);
            return(NUMBER);
         }
[a-zA-Z_]+   {
            if (debug) fprintf(stderr,"ID: (%s)\n", yytext);
            yylval.str = strdup(yytext);
            return(ID);
         }
\;       {
            if (debug) fprintf(stderr,"SEMICOLON\n");
            yylval.ival = yytext[0];
            return(SEMICOLON);
         }
\,       {
            if (debug) fprintf(stderr,"COMMA\n");
            yylval.ival = yytext[0];
            return(COMMA);
         }
\(       {
            if (debug) fprintf(stderr,"LPAREN\n");
            yylval.ival = yytext[0];
            return(LPAREN);
         }
\)       {
            if (debug) fprintf(stderr,"RPAREN\n");
            yylval.ival = yytext[0];
            return(RPAREN);
         }
\{       {
            if (debug) fprintf(stderr,"LBRACE\n");
            yylval.ival = yytext[0];
            return(LBRACE);
         }
\}       {
            if (debug) fprintf(stderr,"RBRACE\n");
            yylval.ival = yytext[0];
            return(RBRACE);
         }
\"[^\"]+\"  {
            if (debug) fprintf(stderr,"STRING: (%s)\n", yytext);
            yylval.str = strdup(yytext);
            return(STRING);
         }
[ \t\n]+	     /* eat up whitespace */
%%

/* Functions (not used when used with parser) */

#ifdef LEXONLY
// only define main() if used by itself
int main()
{
   do {
      yylex();
   } while (1);
   return 0;
}
#endif

