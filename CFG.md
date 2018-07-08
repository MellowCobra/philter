Terminals:

-   SEMI `;`
-   LPR `(`
-   RPR `)`
-   MINUS `-`
-   PLUS `+`
-   STAR `*`
-   SLASH `/`
-   INT `1234`
-   EQUAL `=`
-   IDENTIFIER `_abC123`
-   VAR `var`
-   EOF `\0`

Productions:

    compound_stmt   → stmt
                    | stmt SEMI stmt_list
                    ;

    stmt            → print_stmt
                    | var_stmt
                    ;

    print_stmt      → PRINT expr
                    ;

    var_stmt        → VAR IDENTIFIER EQUAL expr
                    ;

    expr            → term
                    | term ( STAR | SLASH ) expr
                    ;

    term            → factor
                    | factor ( PLUS | MINUS ) term
                    ;

    factor          → INT
                    | var_expr
                    | ( expr )
                    ;

    var_expr        → IDENTIFIER
