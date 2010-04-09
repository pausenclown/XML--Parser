class XML::Parser::Dom::DocumentType {
    has Str $.name  is rw;
    has Str $.descr is rw;
    has Str $.url   is rw;
    has %.entities  is rw;
}

