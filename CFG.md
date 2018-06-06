Terminals:

-   LPR `(`
-   RPR `)`
-   MINUS `-`
-   PLUS `+`
-   STAR `*`
-   SLASH `/`
-   INT `1234`
-   EOF `\0`

Productions:

    expr            → term
                    | term ( STAR | SLASH ) expr
                    ;

    term            → factor
                    | factor ( PLUS | MINUS ) term
                    ;

    factor          → INT
                    ;
