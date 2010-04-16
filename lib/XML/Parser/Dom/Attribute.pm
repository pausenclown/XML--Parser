class XML::Parser::Dom::Element { ... }

class XML::Parser::Dom::Attribute
{
    has Str                       $.name              is rw;
    has Str                       $.value             is rw;
    has Str                       $.prefix            is rw;
    has XML::Parser::Dom::Element $.container_element is rw;

    method full_name {
        ( self.prefix ?? "{self.prefix}:" !! "" ) ~
        self.name
    }

    method xml {
        "{self.full_name}=\"{self.value}\""
    }

    method namespace {
        return if self.prefix eq '';
        self.container_element.namespaces{ self.prefix };
    }
}

