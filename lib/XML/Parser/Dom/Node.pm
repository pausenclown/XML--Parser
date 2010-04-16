subset XML::Parser::XmlName of Str where { $_ ~~ / ^ \w+ $ / };

class XML::Parser::Dom::Document { ... }
class XML::Parser::Dom::Element  { ... }

class XML::Parser::Dom::Node {

    method Str {
        self.xml;
    }

    # localName   Returns the local part of the name of a node
    has XML::Parser::XmlName        $.local_name is rw;

    # nodeName    Returns the name of a node, depending on its type
    method node_name {
        self.full_name || '#' ~ self.node_type.lcfirst.subst( / (<[ A..Z ]>) /, ->$/ { "_{$/[0]}".lc } );
    }

    # alias for local_name
    method name {
        self.local_name;
    }

    # fullName    Returns the full name of a node, including namespace prefix
    method full_name {
        self.prefix ?? self.prefix  ~ ':' ~ self.local_name !! self.local_name;
    }

    # nodeType    Returns the type of a node
    method node_type {
        "{self.WHAT}".subst(/XML \:\: Parser \:\: Dom \:\: /, '').subst(/ \( \) $ /, '');
    }

    # prefix  Returns the namespace prefix of a node
    has Str $.prefix is rw = '';

    # childNodes  Returns the child nodes for a node
    has XML::Parser::Dom::Node      @.child_nodes;

    # ownerDocument   Returns the root element (document object) for a node
    has XML::Parser::Dom::Document  $.owner_document is rw;

    # parentNode  Returns the parent node of a node
    has XML::Parser::Dom::Element   $.parent_node is rw;

    # previousSibling Returns the node immediately before a node
    has XML::Parser::Dom::Node      $.previous_sibling is rw;

    # nextSibling Returns the node immediately following a node
    has XML::Parser::Dom::Node      $.next_sibling is rw;

    # firstChild  Returns the first child of a node
    method first_child {
        self.child_nodes.elems ?? self.child_nodes[0] !! Mu;
    }

    # lastChild   Returns the last child of a node
    method last_child {
        self.child_nodes.elems ?? self.child_nodes[*-1] !! Mu;
    }

    # baseURI Returns the absolute base URI of a node

    # nodeValue   Sets or returns the value of a node, depending on its type
    method node_value {
        die "'node_value' must be implemented by subclass.";
    }

    # text    Returns the text of a node and its descendants.
    method text {
        '';
    }

    method path {
        self.parent_node ?? join( '/', self.parent_node.path, self.node_name ) !! '';
    }
}

