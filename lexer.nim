import fusion/matching
{.experimental: "caseStmtMacros".}

type
    TokenType* = enum
        LAMBDA,
        DOT,
        LPAREN,
        RPAREN,
        ID,
    Token* = ref object
        case ttype* : TokenType
        of ID:
            name*: string
        else:
            discard

func baseToken(c: char): bool =
    c == '\\' or c == '.' or c == '(' or c == ')' or c == ' '

func tokenize*(source: seq[char]): seq[Token] = 
    case source:
        of []:
            @[]
        of ['\\', all @tail]:
            @[Token(ttype: LAMBDA)] & tokenize(tail)
        of ['.', all @tail]:
            @[Token(ttype: DOT)] & tokenize(tail)
        of ['(', all @tail]:
            @[Token(ttype: LPAREN)] & tokenize(tail)
        of [')', all @tail]:
            @[Token(ttype: RPAREN)] & tokenize(tail)
        of [' ', until != ' ', all @tail]:
            tokenize(tail)
        of [until @a.baseToken(), all @tail]:
            Token(ttype: ID, name: cast[string](a)) & tokenize(tail)
        else:
            raise newException(Exception, "Lexer couldn't tokenize. Illegal symbol encountered.")