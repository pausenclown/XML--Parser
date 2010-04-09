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
        self.add_node( $cd );
    }

    multi method xml_declaration( XML::Parser::Dom::XmlDeclaration $d ) {
        self.parser.document.xml_decl = $d;
    }

    multi method pi( XML::Parser::Dom::ProcessingInstruction $pi ) {
        self.add_node( $pi );
    }

    multi method start_tag( XML::Parser::Dom::Element $t ) {
        self.add_node( $t );
        self.parser.context = $t;
        self.parser.stack.push( self.parser.context );
    }

    multi method end_tag( XML::Parser::Dom::Element $t ) {
        self.parser.stack.pop;
        self.parser.context = self.parser.stack.elems ?? self.parser.stack[*-1] !! self.parser.document;
    }

    multi method comment( XML::Parser::Dom::Comment $c ) {
        self.add_node( $c );
    }

    multi method text( XML::Parser::Dom::Text $t ) {
        self.add_node( $t );
    }

    method add_node( XML::Parser::Dom::Node $n ) {
        self.set_node_kin( $n );
        self.parser.context.child_nodes.push( $n );
    }

    method set_node_kin( XML::Parser::Dom::Node $n ) {
        $n.owner_document   = self.parser.document;
        $n.parent_node      = self.parser.context;

        if self.parser.context.child_nodes.elems {
            $n.previous_sibling = self.parser.context.child_nodes[*-1];
            self.parser.context.child_nodes[*-1].next_sibling = $n;
        }
    }
}
