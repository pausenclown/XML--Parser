# use XML::Parser::Dom::Node;

class XML::Parser::Dom::Comment is XML::Parser::Dom::Node {
    has Str $.data is rw;
    method xml {
        "<!--{ self.data }-->";
    }
}

