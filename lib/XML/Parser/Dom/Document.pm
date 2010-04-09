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
    # FIXME
    method root       { self.first_child }

    method xml {
        self.xml_decl.xml ~ "\n" ~ join('', self.child_nodes>>.xml);
    }

    method text {
        join('', self.child_nodes>>.text);
    }
}

