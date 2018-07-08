# Philter

An interpreter for the philter programming language written in Elixir

_Note:_ This is a WIP, and currently only parses simple arithmetic expressions

## Run

Run in iex with

-   `iex> Philter.start`

## Component Process

The interpreter has the following components, each of which transforms given input into a specific output. The philter driver then pipes said output into the next component.

-   [Lexer](#lexer): scans charlist and converts to list of tokens
-   [Parser](#parser): parses token list into an Abstract Syntax Tree (AST)
-   [Interpreter](#interpreter): walks the AST and interprets each node

### Lexer

Main function: `scan_tokens(charlist) -> [Token]`

**Input:** the source expression `charlist`

**Output:** a list of tokens `[Token]`

### Parser

Main function: `parse([Token]) -> Compound_Stmt`

**Input:** a list of tokens `[Token]`

**Output:** a compound statement AST `Compound_Stmt`

### Interpreter

Main function: `interpret() -> :ok || :error`

**Input:** a compound statement AST `Compound_Stmt`

**Output:** :ok if interpretation succeeded. Currently doesn't handle errors

## Next Steps

1.  Add file input (currently only reads and interprets a single line from REPL)
2.  Change statements to expressions
    -   Print statement: return the value of its expression after printing it
    -   Var declaration: return the value of its expression after assigning it
    -   Compound statement: return the value of the last expression in the list
3.  Add boolean expressions
4.  Better error handling!
