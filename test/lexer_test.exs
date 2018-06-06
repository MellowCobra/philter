defmodule LexerTest do
  use ExUnit.Case
  doctest Lexer

  # scan_tokens

  test "scan_tokens returns list with only EOF token when given an empty list" do
    input = to_charlist("")
    output = [%Token{lexeme: "\0", type: :EOF, value: nil}]
    assert Lexer.scan_tokens(input) == output
  end

  test "scan_tokens parses single-digit integers" do
    input = to_charlist("1")

    output = [
      %Token{lexeme: "1", type: :INT, value: 1},
      %Token{lexeme: "\0", type: :EOF, value: nil}
    ]

    assert Lexer.scan_tokens(input) == output
  end

  test "scan_tokens parses multi-digit integers" do
    input = to_charlist("123")

    output = [
      %Token{lexeme: "123", type: :INT, value: 123},
      %Token{lexeme: "\0", type: :EOF, value: nil}
    ]

    assert Lexer.scan_tokens(input) == output
  end

  test "scan_tokens parses plus and minus signs" do
    input = to_charlist("1+2-3")

    output = [
      %Token{lexeme: "1", type: :INT, value: 1},
      %Token{lexeme: "+", type: :PLUS},
      %Token{lexeme: "2", type: :INT, value: 2},
      %Token{lexeme: "-", type: :MINUS},
      %Token{lexeme: "3", type: :INT, value: 3},
      %Token{lexeme: "\0", type: :EOF}
    ]

    assert Lexer.scan_tokens(input) == output
  end

  test "scan_tokens parses multiplication and division signs" do
    input = to_charlist("1*2/3")

    output = [
      %Token{lexeme: "1", type: :INT, value: 1},
      %Token{lexeme: "*", type: :STAR},
      %Token{lexeme: "2", type: :INT, value: 2},
      %Token{lexeme: "/", type: :SLASH},
      %Token{lexeme: "3", type: :INT, value: 3},
      %Token{lexeme: "\0", type: :EOF}
    ]

    assert Lexer.scan_tokens(input) == output
  end

  test "scan_tokens ignores whitespace" do
    input = to_charlist("    1\t+

    5  ")

    output = [
      %Token{lexeme: "1", type: :INT, value: 1},
      %Token{lexeme: "+", type: :PLUS},
      %Token{lexeme: "5", type: :INT, value: 5},
      %Token{lexeme: "\0", type: :EOF}
    ]

    assert Lexer.scan_tokens(input) == output
  end

  test "scan_tokens raises an exception when a string contains an unrecognized token" do
    input = to_charlist("123 + ?")

    assert_raise RuntimeError, "unknown token \"?\"", fn ->
      Lexer.scan_tokens(input)
    end
  end

  # int

  test "int converts a char list with a single char into an int" do
    input = to_charlist("1")
    assert Lexer.int(input) == {%Token{lexeme: "1", type: :INT, value: 1}, []}
  end

  test "int converts a char list with multiple chars into an int" do
    input = to_charlist("123")
    assert Lexer.int(input) == {%Token{lexeme: "123", type: :INT, value: 123}, []}
  end

  test "int converts a char list with multiple numeric AND alpha chars into an int and returns the rest of the list" do
    input = to_charlist("123abc")
    output = to_charlist("abc")
    assert Lexer.int(input) == {%Token{lexeme: "123", type: :INT, value: 123}, output}
  end

  # is_digit

  test "is_digit returns true for characters 0-9" do
    assert Lexer.is_digit(?0) == true
    assert Lexer.is_digit(?1) == true
    assert Lexer.is_digit(?2) == true
    assert Lexer.is_digit(?3) == true
    assert Lexer.is_digit(?4) == true
    assert Lexer.is_digit(?5) == true
    assert Lexer.is_digit(?6) == true
    assert Lexer.is_digit(?7) == true
    assert Lexer.is_digit(?8) == true
    assert Lexer.is_digit(?9) == true
  end

  test "is_digit returns false for characters > 9" do
    assert Lexer.is_digit(?:) == false
    assert Lexer.is_digit(?A) == false
  end

  test "is_digit returns false for characters < 0" do
    assert Lexer.is_digit(?/) == false
    assert Lexer.is_digit(?!) == false
  end

  # is_whitespace

  test "is_whitespace returns true for newline '\n'" do
    assert Lexer.is_whitespace(?\n) == true
  end

  test "is_whitespace returns true for tab '\t'" do
    assert Lexer.is_whitespace(?\t) == true
  end

  test "is_whitespace returns true for space ' '" do
    assert Lexer.is_whitespace(?\s) == true
  end

  test "is_whitespace returns false for numeric chars" do
    assert Lexer.is_whitespace(?0) == false
    assert Lexer.is_whitespace(?5) == false
    assert Lexer.is_whitespace(?9) == false
  end

  test "is_whitespace returns false for alpha chars" do
    assert Lexer.is_whitespace(?a) == false
    assert Lexer.is_whitespace(?b) == false
    assert Lexer.is_whitespace(?z) == false
    assert Lexer.is_whitespace(?A) == false
    assert Lexer.is_whitespace(?Z) == false
  end

  test "is_whitespace returns false for other chars" do
    assert Lexer.is_whitespace(?_) == false
    assert Lexer.is_whitespace(?!) == false
    assert Lexer.is_whitespace(?`) == false
    assert Lexer.is_whitespace(?;) == false
  end
end
