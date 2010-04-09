class XML::Parser::Dom::CData
is    XML::Parser::Dom::Node
{
    has Str $.data is rw;

    method xml {
        "<![CDATA[{ self.data }]]>";
    }
}

