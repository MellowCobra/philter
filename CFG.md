Terminals:

*   LPR `(`
*   RPR `)`
*   MINUS `-`
*   PLUS `+`
*   STAR `*`
*   SLASH `/`
*   INT `1234`
*   EOF `\0`

Productions:

    expr            → term (( MUL | DIV ) term)*
                    ;

    term            → factor (( PLUS | MINUS ) factor)*
                    ;

    factor          → INT
                    ;
