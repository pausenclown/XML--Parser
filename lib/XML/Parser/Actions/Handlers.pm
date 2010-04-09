class XML::Parser::Actions::Handlers
is    XML::Parser::Actions::Base
{

    multi method document_start( XML::Parser::Dom::Document $d ) {
    }

    multi method document_end() {
    }

    multi method start_cdata() {
    }

    multi method end_cdata( XML::Parser::Dom::CData $cd ) {
    }

    multi method xml_declaration( XML::Parser::Dom::XmlDeclaration $d ) {
    }

    multi method pi( XML::Parser::Dom::ProcessingInstruction $pi ) {
    }

    multi method start_tag( XML::Parser::Dom::Element $t ) {
        my $name = $t.name;
        my @attr = $t.attributes;

        if self.parser.handlers.can($name)
        {
            eval( "self.parser.handlers.{$name}( \@attr );" );
        }
    }

    multi method end_tag( XML::Parser::Dom::Element $t ) {
    }

    multi method comment( XML::Parser::Dom::Comment $c ) {
    }

    multi method text( XML::Parser::Dom::Text $t ) {
        if self.parser.handlers.can('text') {
            self.parser.handlers.text( $t );
        }
    }
}
