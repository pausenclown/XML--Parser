
class XML::Parser::Dom::Element
is    XML::Parser::Dom::ParentalNode
{
    has XML::Parser::Dom::Attribute @.attributes;
    has XML::Parser::Namespace %._namespaces;

    # namespaceURI Returns the namespace URI of a node
#     method namespace_uri {
#         self.namespace.uri;
#     }

    method xml
    {
        if !self.child_nodes.elems
        {
            "<{self.full_name}{self.attribute_xml} />";
        }
        else
        {
            "<{self.full_name}{self.attribute_xml}{self.namespace_xml}>{self.children_xml}</{self.full_name}>";
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

    method namespace_xml {
        given join( ' ', self._namespaces.values>>.xml ) {
            ' ' ~ $_ if $_;
        }
    }

    multi method add_attribute( $name, $value )
    {
        # found a namespace
        if $name ~~ / ^ [ xmlns | xmlns \: ( .+ ) ] $ /
        {
            my $namespace = $0 // ''; #/
            self._namespaces{ $namespace } = XML::Parser::Namespace.new( name => $namespace, uri => $value );
        }
        else
        {
            ( $name, my $prefix ) = $name.split(':').reverse; $prefix //= ''; #/

            self.attributes.push( XML::Parser::Dom::Attribute.new( name  => $name, value => $value, prefix => $prefix, container_element => self  ) );
        }
    }

    multi method add_attribute( XML::Parser::Dom::Attribute $a )
    {
        self.attributes.push( $a );
    }

     method namespaces {
         my %namespaces = self.parent_node && self.parent_node.isa( XML::Parser::Dom::Element ) ?? self.parent_node.namespaces !! hash;
         for %._namespaces.kv -> $name, $namespace {
             %namespaces{ $name } = $namespace;
         }
         %namespaces;
     };

    method namespace {
        self.namespaces{ self.prefix };
    }
}

