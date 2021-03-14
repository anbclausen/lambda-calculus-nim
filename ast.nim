type
    TermType*    = enum
        Var, 
        Abs, 
        App,
    T*   = ref object         # Term
        case t*: TermType     # type
        of Var: 
            id*: string
        of Abs:
            param*: string
            body*: T
        of App:
            t1*: T
            t2*: T