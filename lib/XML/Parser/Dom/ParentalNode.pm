class XML::Parser::Dom::Text { ... }

class XML::Parser::Dom::ParentalNode
is    XML::Parser::Dom::Node
{

    method add_node( XML::Parser::Dom::Node $n ) {
        self.set_node_kin( $n );

        if $n.isa( XML::Parser::Dom::Text ) && self.child_nodes && self.child_nodes[*-1].isa( XML::Parser::Dom::Text )
        {
            self.child_nodes[*-1].data ~= $n.data;
            return;
        }

        self.child_nodes.push( $n );
    }

    method set_node_kin( XML::Parser::Dom::Node $n ) {
        $n.owner_document   = self.owner_document || self;
        $n.parent_node      = self;

        if self.child_nodes.elems {
            $n.previous_sibling = self.child_nodes[*-1];
            self.child_nodes[*-1].next_sibling = $n;
        }
    }
}

