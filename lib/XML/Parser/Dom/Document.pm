# use XML::Parser::Dom::Doctype;

class XML::Parser::Dom::Document
is    XML::Parser::Dom::ParentalNode
{
    has XML::Parser::Dom::DocumentType   $.doctype  is rw;
    has XML::Parser::Dom::XmlDeclaration $.xml_decl is rw handles <version encoding standalone>;

    has Any                   @.childNodes is rw;
    has Any                   @.namespaces;

    method version    { self.xml_decl.version }
    method encoding   { self.xml_decl.encoding }
    method standalone { self.xml_decl.standalone }
    method root       { self.child_nodes.first({ $_.isa( XML::Parser::Dom::Element ) }) }

    method xml {
        self.xml_decl.xml ~ "\n" ~ join('', self.child_nodes>>.xml);
    }

    method text {
        join('', self.child_nodes>>.text);
    }

    multi method add_doctype ( *%args )
    {
        self.add_doctype( XML::Parser::Dom::DocumentType.new( name => %args<name> || %args<root_name> ) );
    }

    multi method add_doctype ( XML::Parser::Dom::DocumentType $doctype )
    {
        given $doctype {
            self.doctype = $_;
            .ownerDocument = self;
            .add_entity( name => 'lt',   definition => '<' );
            .add_entity( name => 'gt',   definition => '>' );
            .add_entity( name => 'amp',  definition => '&' );
            .add_entity( name => 'apos', definition => "'" );
            .add_entity( name => 'quot', definition => '"' );
        }
    }
}
