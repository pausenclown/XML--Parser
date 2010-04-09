class XML::Parser::Actions::Dom
is    XML::Parser::Actions::Base
{

    multi method document_start( XML::Parser::Dom::Document $d ) {
        self.parser.document = $d;
        self.parser.context  = $d;
    }

    multi method document_end() {
    }

    multi method start_cdata() {
    }

    multi method end_cdata( XML::Parser::Dom::CData $cd ) {
        self.parser.context.add_node( $cd );
    }

    multi method xml_declaration( XML::Parser::Dom::XmlDeclaration $d ) {
        self.parser.document.xml_decl = $d;
    }

    multi method pi( XML::Parser::Dom::ProcessingInstruction $pi ) {
        self.parser.context.add_node( $pi );
    }

    multi method start_tag( XML::Parser::Dom::Element $t ) {
        self.parser.context.add_node( $t );
    }

    multi method end_tag( XML::Parser::Dom::Element $t ) {
    }

    multi method comment( XML::Parser::Dom::Comment $c ) {
        self.parser.context.add_node( $c );
    }

    multi method text( XML::Parser::Dom::Text $t ) {
        self.parser.context.add_node( $t );
    }
}
