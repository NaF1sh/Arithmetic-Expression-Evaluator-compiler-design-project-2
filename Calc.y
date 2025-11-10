%{
   /* Definition section */
   #include <stdio.h>
   #include <stdlib.h>
   
   int flag = 0;
   int div_by_zero = 0;
   
   /* forward declarations so gcc is happy */
   int yylex(void);
   void yyerror(const char *s);
%}

%token NUMBER
%token PLUS MINUS TIMES DIVIDE MODULO
%token LPAREN RPAREN
%token LT LE GT GE EQ NE
%token NEWLINE
%token UNKNOWN

%left EQ NE
%left LT LE GT GE
%left PLUS MINUS
%left TIMES DIVIDE MODULO
%right UMINUS

%%

Program
    : /* empty */
    | Program Line
    ;

Line
    : NEWLINE {
        /* Empty line, do nothing */
      }
    | Expression NEWLINE {
        if (!div_by_zero) {
            printf("%d\n", $1);
        }
        div_by_zero = 0;
        flag = 0;
      }
    | error NEWLINE {
        yyerrok;
        div_by_zero = 0;
        flag = 0;
      }
    ;

Expression
    : Comparison { $$ = $1; }
    ;

Comparison
    : Comparison LT Term    { $$ = ($1 < $3) ? 1 : 0; }
    | Comparison LE Term    { $$ = ($1 <= $3) ? 1 : 0; }
    | Comparison GT Term    { $$ = ($1 > $3) ? 1 : 0; }
    | Comparison GE Term    { $$ = ($1 >= $3) ? 1 : 0; }
    | Comparison EQ Term    { $$ = ($1 == $3) ? 1 : 0; }
    | Comparison NE Term    { $$ = ($1 != $3) ? 1 : 0; }
    | Term                  { $$ = $1; }
    ;

Term
    : Term PLUS Factor      { $$ = $1 + $3; }
    | Term MINUS Factor     { $$ = $1 - $3; }
    | Factor                { $$ = $1; }
    ;

Factor
    : Factor TIMES Unary    { $$ = $1 * $3; }
    | Factor DIVIDE Unary   {
                              if ($3 == 0) {
                                  printf("Error: division by zero\n");
                                  div_by_zero = 1;
                                  $$ = 0;
                              } else {
                                  $$ = $1 / $3;
                              }
                            }
    | Factor MODULO Unary   {
                              if ($3 == 0) {
                                  printf("Error: division by zero\n");
                                  div_by_zero = 1;
                                  $$ = 0;
                              } else {
                                  $$ = $1 % $3;
                              }
                            }
    | Unary                 { $$ = $1; }
    ;

Unary
    : MINUS Unary %prec UMINUS { $$ = -$2; }
    | Primary                   { $$ = $1; }
    ;

Primary
    : LPAREN Expression RPAREN { $$ = $2; }
    | NUMBER                   { $$ = $1; }
    ;

%%

int main(void) {
    printf(
        "\nArithmetic Expression Evaluator\n"
        "Supports: +, -, *, /, %%, (), unary minus\n"
        "Comparisons: <, <=, >, >=, ==, !=\n"
        "Enter expressions (one per line, Ctrl+D to exit):\n\n"
    );
    
    yyparse();
    
    return 0;
}

void yyerror(const char *s) {
    /* s = "syntax error" etc. */
    if (!div_by_zero) {
        printf("Error: %s\n", s);
    }
    flag = 1;
}