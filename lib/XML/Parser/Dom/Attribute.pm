class XML::Parser::Dom::Attribute {
    has Str $.name is rw;
    has Str $.value is rw;

    method xml {
        "{self.name}=\"{self.value}\""
    }
}

