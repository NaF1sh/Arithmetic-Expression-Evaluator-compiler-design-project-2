%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"

extern int yyerror(const char *s);
%}

%option noyywrap
%option yylineno

%%

[ \t]+              { /* ignore whitespace */ }
\n                  { return NEWLINE; }

[0-9]+              { yylval.ival = atoi(yytext); return NUMBER; }

"+"                 { return PLUS; }
"-"                 { return MINUS; }
"*"                 { return TIMES; }
"/"                 { return DIVIDE; }
"%"                 { return MODULO; }

"("                 { return LPAREN; }
")"                 { return RPAREN; }

"<"                 { return LT; }
"<="                { return LE; }
">"                 { return GT; }
">="                { return GE; }
"=="                { return EQ; }
"!="                { return NE; }

.                   { 
                      fprintf(stderr, "Error: unknown character '%s'\n", yytext);
                      return UNKNOWN;
                    }

%%