class XML::Parser::Namespace {
    has Str $.name is rw = "";
    has Str $.uri  is rw = "";

    method xml {
        self.name                          ??
        "xmlns:{self.name}=\"{self.uri}\"" !!
        "xmlns=\"{self.uri}\""             ;
    }
}

