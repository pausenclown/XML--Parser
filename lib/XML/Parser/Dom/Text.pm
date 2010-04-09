class XML::Parser::Dom::Text
is    XML::Parser::Dom::Node
{
    has Str $.data is rw;

    method xml {
        "{self.data}";
    }

    method text {
        "{self.data}";
    }
}

