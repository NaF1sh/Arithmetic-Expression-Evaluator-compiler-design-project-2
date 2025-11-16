%{
   /* Definition section */
   #include <stdio.h>
   #include <stdlib.h>
   #include "y.tab.h"
%}

%%

[0-9]+ {
         yylval = atoi(yytext);
         return NUMBER;
       }

[ \t]+ ;

[\n] return NEWLINE;

"+"  return PLUS;
"-"  return MINUS;
"*"  return TIMES;
"/"  return DIVIDE;
"%"  return MODULO;
"("  return LPAREN;
")"  return RPAREN;

"<=" return LE;    
"<"  return LT;
">=" return GE;    
">"  return GT;
"==" return EQ;
"!=" return NE;

. {
    printf("Error: unknown character '%s'\n", yytext);
    return UNKNOWN;
  }

%%

int yywrap(void) {
    return 1;
}