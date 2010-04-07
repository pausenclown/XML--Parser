class XParser::Dom::Doctype {
        has Str $.name  is rw;
        has Str $.descr is rw;
        has Str $.url   is rw;
        has %.entities  is rw;
}