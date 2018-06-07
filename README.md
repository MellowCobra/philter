# Philter

An interpreter for the philter programming language written in Elixir

_Note:_ This is a WIP, and currently only parses simple arithmetic expressions

## Run

Run in iex with

-   `iex> Philter.start`

## Component Process

The interpreter has the following components, each of which transforms given input into a specific output. The philter driver then pipes said output into the next component.

-   Lexer: scans charlist and converts to list of tokens
-   Parser: parses token list into an Abstract Syntax Tree (AST)
-   Interpreter: walks the AST and interprets each node

### Lexer

Main function: `scan_tokens(charlist) -> [Token]`

**Input:** the source expression _charlist_
**Output:** a list of tokens _[Token]_

### Parser

Main function: `parse([Token]) -> Expr`

**Input:** a list of tokens _[Token]_
**Output:** an expression AST _Expr_

### Interpreter

Main function: `interpret(Expr) -> Int`

**Input:** an expression AST _Expr_
**Output:** the value of the calculated expression _Int_

## Next Steps

1.  Add grouping expressions with parentheses
2.  Add variables
    -   Add environments to store variables
    -   Add IDENTIFIER tokens and scan them
    -   Add variable declaration expressions
    -   Add variable usage expressions
