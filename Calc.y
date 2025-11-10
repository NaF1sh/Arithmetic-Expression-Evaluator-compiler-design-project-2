%{
#include <stdio.h>
#include <stdlib.h>

int yylex();
void yyerror(const char *s);
int div_error = 0;
%}

%token NUMBER
%token NEWLINE

%left EQ NE
%left LT LE GT GE
%left '+' '-'
%left '*' '/' '%'
%right UMINUS

%%

lines: 
     | lines line
     ;

line: NEWLINE
    | E NEWLINE { 
        if(!div_error) {
            printf("%d\n", $1); 
        }
        div_error = 0;
      }
    | error NEWLINE { 
        yyerrok; 
        div_error = 0; 
      }
    ;

E   : E LT E        { $$ = ($1 < $3) ? 1 : 0; }
    | E LE E        { $$ = ($1 <= $3) ? 1 : 0; }
    | E GT E        { $$ = ($1 > $3) ? 1 : 0; }
    | E GE E        { $$ = ($1 >= $3) ? 1 : 0; }
    | E EQ E        { $$ = ($1 == $3) ? 1 : 0; }
    | E NE E        { $$ = ($1 != $3) ? 1 : 0; }
    | E '+' E       { $$ = $1 + $3; }
    | E '-' E       { $$ = $1 - $3; }
    | E '*' E       { $$ = $1 * $3; }
    | E '/' E       { 
        if($3 == 0) {
            printf("Error: division by zero\n");
            $$ = 0;
            div_error = 1;
        } else {
            $$ = $1 / $3;
        }
      }
    | E '%' E       { 
        if($3 == 0) {
            printf("Error: division by zero\n");
            $$ = 0;
            div_error = 1;
        } else {
            $$ = $1 % $3;
        }
      }
    | '-' E %prec UMINUS { $$ = -$2; }
    | '(' E ')'          { $$ = $2; }
    | NUMBER             { $$ = $1; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    yyparse();
    return 0;
}