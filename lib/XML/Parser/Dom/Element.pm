
class XML::Parser::Dom::Element
is    XML::Parser::Dom::ParentalNode
{
    has XML::Parser::Dom::Attribute @.attributes;

    method xml
    {
        if !self.child_nodes.elems
        {
            "<{self.name}{self.attribute_xml} />";
        }
        else
        {
            "<{self.name}{self.attribute_xml}>{self.children_xml}</{self.name}>";
        }
    }

    method text {
        join( ' ', grep( { $_ }, self.child_nodes>>.text ) );
    }

    method attribute_xml {
        given join( ' ', self.attributes>>.xml ) {
            ' ' ~ $_ if $_;
        }
    }

    method children_xml {
        join( '', self.child_nodes>>.xml );
    }

    multi method add_attribute( $name, $value )
    {
        say "add_attribute ", self.name, '-', $name, '+', $value, '!', $name.WHAT, '+', $value.WHAT;
        self.attributes.push( XML::Parser::Dom::Attribute.new( name  => $name, value => $value ) );
        say "<add_attribute ";
    }

    multi method add_attribute( XML::Parser::Dom::Attribute $a )
    {
        self.attributes.push( $a );
    }
}



