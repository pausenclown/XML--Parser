class XML::Parser::Dom::XmlDeclaration {
    has Str $.version    is rw = "1.0";
    has Str $.encoding   is rw = "UTF-8";
    has Str $.standalone is rw = "yes";

    method xml {
        "<?xml version=\"{self.version}\" encoding=\"{self.encoding}\" standalone=\"{self.standalone}\"?>"
    }
}

