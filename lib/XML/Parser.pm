class XML::Parser::Namespace {
    has Str $.name is rw = "";
    has Str $.uri  is rw = "";
}

class XML::Parser::Dom::XmlDeclaration {
    has Str $.version    is rw = "1.0";
    has Str $.encoding   is rw = "UTF-8";
    has Str $.standalone is rw = "yes";

    method xml {
        "<?xml version=\"{self.version}\" encoding=\"{self.encoding}\" standalone=\"{self.standalone}\"?>"
    }
}

class XML::Parser::Dom::Attribute {
    has Str $.name is rw;
    has Str $.value is rw;

    method xml {
        "{self.name}=\"{self.value}\""
    }
}

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

    # namespace    Returns the namespace of a node
    has XML::Parser::Namespace $.namespace is rw;

    # namespaceURI Returns the namespace URI of a node
    method namespace_uri {
        self.namespace.uri;
    }

    # prefix  Returns the namespace prefix of a node
    method prefix {
        self.namespace ?? self.namespace.name !! '';
    }

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

class XML::Parser::Dom::ParentalNode
is    XML::Parser::Dom::Node
{

    method add_node( XML::Parser::Dom::Node $n ) {
        self.set_node_kin( $n );
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

class XML::Parser::Dom::Text
is    XML::Parser::Dom::Node
{
    has Str $.data is rw;

    method xml {
        "{self.data}";
    }

    method text {
        "{self.data}";
    }
}

class XML::Parser::Dom::CData
is    XML::Parser::Dom::Node
{
    has Str $.data is rw;

    method xml {
        "<![CDATA[{ self.data }]]>";
    }
}

# use XML::Parser::Dom::Node;

class XML::Parser::Dom::Comment is XML::Parser::Dom::Node {
    has Str $.data is rw;
    method xml {
        "<!--{ self.data }-->";
    }
}

class XML::Parser::Dom::Entity { ... }

class XML::Parser::Dom::DocumentType {
    has Str $.name  is rw;
    has Str $.descr is rw;
    has Str $.url   is rw;
    has %.entities  is rw;

    has XML::Parser::Dom::Document $.ownerDocument is rw;

    multi method add_entity( *%args )
    {
        self.add_entity( XML::Parser::Dom::Entity.new( |%args ) );
    }

    multi method add_entity( XML::Parser::Dom::Entity $entity )
    {
        self.entities{ $entity.name } = $entity;
        $entity.doctype = self;
    }
}

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
class XML::Parser::Dom::Entity {
    has Str $.name           is rw;
    has Str $.definition     is rw;
    has Str $.system_literal is rw;
    has Str $.pub_id_literal is rw;
    has Str $.ndata_name     is rw;

    has XML::Parser::Dom::DocumentType $.doctype is rw;

    method parse( Str $def is copy = "{ self.definition }" ) {
        my $again;

        $def = $def.subst( / \& \# ( \d+ ) \; /, -> $m { chr( $m[0].Str ) } );
        $def = $def.subst( / \& \# x ( <[ 0..9 A..F a..f ]>+ ) \; /, -> $m { chr( :10( '0x' ~ $m[0].Str ) ) } );
        $def = $def.subst( / \& ( <[ \: A..Z a..z \_ ]> <[ \: A..Z a..z \_ \- \. \d ]>+ ) \; /, -> $m { $again = 1; self.doctype.entities{$m[0]}.definition } );

        $again ?? self.parse( $def ) !! $def;
    }
}
class XML::Parser::Dom::EntityReference {
}


class XML::Parser::Dom::ProcessingInstruction
is    XML::Parser::Dom::Node
{
    has Str $.target is rw;
    has Str $.data   is rw;

    method xml {
        "<?{self.target} {self.data}?>";
    }
}



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
        # say "add_attribute ", self.name, '-', $name, '+', $value, '!', $name.WHAT, '+', $value.WHAT;
        self.attributes.push( XML::Parser::Dom::Attribute.new( name  => $name, value => $value ) );
        # say "<add_attribute ";
    }

    multi method add_attribute( XML::Parser::Dom::Attribute $a )
    {
        self.attributes.push( $a );
    }
}



class XML::Parser { ... }

class XML::Parser::Actions::Base {

    has XML::Parser $.parser;
    has Str         $.lastCandidate is rw = 'DOCUMENT';

    multi method document_start( $/, $w? ) {
        my $d = XML::Parser::Dom::Document.new;
        self.document_start( $d );
    }

    multi method document_end( $/, $w? ) {
        self.document_end();
    }

    multi method pi( $/, $w? ) {
        self.pi( XML::Parser::Dom::ProcessingInstruction.new(
            target => $<pi_target>.Str,
            data   => $<pi_data><char>.Str
        ));
    }

    multi method comment( $/, $w? ) {
        self.comment( XML::Parser::Dom::Comment.new(
            data   => $<comment_data>.Str
        ));
    }

    multi method xml_decl( $/, $w? ) {
        self.xml_declaration(XML::Parser::Dom::XmlDeclaration.new(
            version    => $<version_info><version_num>.Str,
            encoding   => $<encoding_decl> ?? $<encoding_decl>[0]<encoding_decl_value><enc_name>.Str !! 'UTF-32',
            standalone => $<sd_decl>       ?? $<sd_decl>[0]<sd_decl_value><sd_value>.Str             !! 'yes'
        ));
    }

    multi method s_tag( $/, $w? ) {
        my $element = XML::Parser::Dom::Element.new(
            local_name => $<s_tag_name>.Str
        );

        die "!Document Type name doesn't match root element."
            if !self.parser.stack && self.parser.document.doctype && self.parser.document.doctype.name ne $element.local_name;

        self._add_attributes( $element, $/ );
        self.start_tag( $element );
        self.parser.context = $element;
        self.parser.stack.push( self.parser.context );


    }

    multi method e_tag( $/, $w? ) {
        self.parser.stack.pop;
        self.parser.context = self.parser.stack.elems ?? self.parser.stack[*-1] !! self.parser.document;

        self.end_tag( XML::Parser::Dom::Element.new(
            local_name => $<name>.Str
        ));
    }

    method empty_elem_tag( $/, $w? ) {
        my $element = XML::Parser::Dom::Element.new(
            local_name => $/<empty_elem_name>.Str
        );
        self._add_attributes( $element, $/ );

        self.start_tag( $element );
        self.end_tag( $element );
    }

    method _add_attributes( $element, $match  ) {
        if $match<attributes>
        {
            for  $match<attributes>[0] -> $a
            {
                $element.add_attribute(
                    $a<attribute><att_name>[0].Str,
                    $a<attribute><att_value><att_value_dq> ?? $a<attribute><att_value><att_value_dq><att_value_dv>.Str !!
                    $a<attribute><att_value><att_value_sq> ?? $a<attribute><att_value><att_value_sq><att_value_sv>.Str !!
                    die "Wow, that came unexpected! Ask your deity for assistance."
                );
            }
        }
    }

    multi method text_node( $/, $w? )
    {
        my $text = "$/";

        # FIXME
        $text = $text.subst(/ ^ \s+ /, '');
        $text = $text.subst(/ \s+ $ /, '');

        return unless $text;

        self.text( XML::Parser::Dom::Text.new(
            data => $text
        ));
    }

    multi method cd_start( $/, $w? )
    {
        self.start_cdata();
    }

    multi method cd_sect( $/, $w? )
    {
        self.end_cdata( XML::Parser::Dom::CData.new(
            data => "{$<c_data>}"
        ));
    }

    multi method doctype_decl_name( $/, $w? )
    {
        # self.parser.document.doctype = XML::Parser::Dom::DocumentType.new( name => $/.Str );
        self.parser.document.add_doctype( name => $/.Str );
    }

    multi method ge_decl ( $/, $w? )
    {
        given $<entity_def>
        {
            if $_<entity_value> {
                self.parser.document.doctype.add_entity(
                    name       => $<ge_decl_name>.Str,
                    definition => $_<entity_value><entity_value_dq> ?? $_<entity_value><entity_value_dq><entity_value_dv>.Str !!
                                  $_<entity_value><entity_value_sq> ?? $_<entity_value><entity_value_sq><entity_value_sv>.Str !!
                                  die "I am your father, Luke."
                );
            }

            if $_<external_id> {
                self.parser.document.doctype.add_entity(
                    name           => $_<ge_decl_name>.Str,
                    system_literal => $_<external_id><system_literal>.Str,
                    pub_id_literal => $_<pub_id_literal> ?? $_<external_id><pub_id_literal>.Str !! '',
                    ndata_name     => $_<ndata_decl>     ?? $_<ndata_decl><name>.Str            !! ''
                );
            }
        }
    }

    # =head2 notation_declaration ( XML::Parser::Dom::NotationDeclaraion $decl )
    # =head2 external_entity ( XML::Parser::Dom::ExternalEntity $ent )
    # =head2 entity_declaration ( XML::Parser::Dom::EntityDeclaration $decl )
    # =head2 element_declaration( XML::Parser::Dom::ElementDeclaration $decl )
    # =head2 attlist_declaration ( XML::Parser::Dom::AttlistDeclaration $decl )
    # =head2 start_doctype_declaration ( XML::Parser::Dom::DoctypeDeclaration $decl )
    # =head2 end_doctype_declaration ( XML::Parser::Dom::DoctypeDeclaration $decl )


    multi method ge_decl_start            ( $/, $w? ) { self.lastCandidate = "ENTITY-Declaration"  }
    multi method pe_decl_start            ( $/, $w? ) { self.lastCandidate = "ENTITY-Declaration"  }
    multi method doctype_decl_start       ( $/, $w? ) { self.lastCandidate = "DOCTYPE declaration" }
    multi method document                 ( $/, $w? ) { self.lastCandidate = "DOCUMENT"            }
    multi method element                  ( $/, $w? ) { self.lastCandidate = "Element"             }
    multi method root                     ( $/, $w? ) { self.lastCandidate = "ROOT"                }
    multi method entity_decl_start        ( $/, $w? ) { self.lastCandidate = "Entity"              }
    multi method empty_elem_name          ( $/, $w? ) { self.lastCandidate = "Element \"" ~ $/<name> ~ "\"" }
    multi method s_tag_name               ( $/, $w? ) { self.lastCandidate = "Element \"" ~ $/<name> ~ "\"" }
};



class XML::Parser::Actions::Test
is    XML::Parser::Actions::Base
{

    multi method pi( XML::Parser::Dom::ProcessingInstruction $pi ) {
        say $pi.xml;
    }

    multi method xml_decl( XML::Parser::Dom::XmlDeclaration $xd ) {
        say $xd.xml;
    }

    multi method tag_start( XML::Parser::Dom::Element $tag ) {
        say $tag.xml;
    }

}


class XML::Parser::Actions::Debug {
        has Any $.lastMatch is rw;
        has Str $.lastToken is rw;
        has Str $.lastCandidate is rw = 'DOCUMENT';

        method remember (Any $match, Str $token, Str $candidate='') {
                self.lastToken = $token unless $token eq 'wts';
                self.lastCandidate = $candidate if $candidate;
                self.lastMatch = $match;
                say " <$match - $token - $candidate> \n";
        }

        method pi_decl_start            ( $/, $w? ) { self.remember( $/, "pi_decl_start" ); }
        method pi_decl_end              ( $/, $w? ) { self.remember( $/, "pi_decl_end" ); }

        method xml_decl_start           ( $/, $w? ) { self.remember( $/, "xml_decl_start" ); }
        method xmldecl_end              ( $/, $w? ) { self.remember( $/, "xml_decl_end" ); }

        method ge_decl_start            ( $/, $w? ) { self.remember( $/, "ge_decl_start", "ENTITY-Declaration" ); }
        method ge_decl_end              ( $/, $w? ) { self.remember( $/, "ge_decl_end" ); }
        method ge_decl_name             ( $/, $w? ) { self.remember( $/, "ge_decl_name" ); }

        method pe_decl_start            ( $/, $w? ) { self.remember( $/, "pe_decl_start", "ENTITY-Declaration" ); }
        method pe_decl_end              ( $/, $w? ) { self.remember( $/, "pe_decl_end" ); }
        method pe_decl_name             ( $/, $w? ) { self.remember( $/, "pe_decl_name" ); }

        method doctype_decl_end         ( $/, $w? ) { self.remember( $/, "doctype_decl_end" ); }
        method doctype_body             ( $/, $w? ) { self.remember( $/, "doctype_body" ); }
        method doctype_body_open_brace  ( $/, $w? ) { self.remember( $/, "doctype_body_open_brace" ); }
        method doctype_body_close_brace ( $/, $w? ) { self.remember( $/, "doctype_close_open_brace  " ); }

        method doctype_decl_start       ( $/, $w? ) { self.remember( $/, "doctype_decl_start", 'DOCTYPE declaration' ); }
        method doctype_decl_name        ( $/, $w? ) { self.remember( $/, "doctype_decl_name" ); }
        method doctype_body             ( $/, $w? ) { self.remember( $/, "doctype_body" ); }
        method TOP                      ( $/, $w? ) { self.remember( $/, "TOP" ); }
        method document                 ( $/, $w? ) { self.remember( $/, "document", "DOCUMENT" ); }
        method Char                     ( $/, $w? ) { self.remember( $/, "Char" ); }
        method wts                      ( $/, $w? ) { self.remember( $/, "wts" ); }
        method name_start_char          ( $/, $w? ) { self.remember( $/, "name_start_char" ); }
        method name_char                ( $/, $w? ) { self.remember( $/, "name_char" ); }
        method name                     ( $/, $w? ) { self.remember( $/, "name" ); }
        method names                    ( $/, $w? ) { self.remember( $/, "names" ); }
        method nm_token                 ( $/, $w? ) { self.remember( $/, "nm_token" ); }
        method nm_tokens                ( $/, $w? ) { self.remember( $/, "nm_tokens" ); }
        method entity_value_v           ( $/, $w? ) { self.remember( $/, "entity_value_v" ); }
        method entity_value_sq          ( $/, $w? ) { self.remember( $/, "entity_value_sq" ); }
        method entity_value_dq          ( $/, $w? ) { self.remember( $/, "entity_value_dq" ); }
        method entity_value             ( $/, $w? ) { self.remember( $/, "entity_value" ); }
        method att_value_v              ( $/, $w? ) { self.remember( $/, "att_value_v" ); }
        method att_value_sq             ( $/, $w? ) { self.remember( $/, "att_value_sq" ); }
        method att_value_dq             ( $/, $w? ) { self.remember( $/, "att_value_dq" ); }
        method att_value                ( $/, $w? ) { self.remember( $/, "att_value" ); }
        method system_literal           ( $/, $w? ) { self.remember( $/, "system_literal" ); }
        method system_literal_value_sq  ( $/, $w? ) { self.remember( $/, "system_literal_value_sq" ); }
        method system_literal_value_dq  ( $/, $w? ) { self.remember( $/, "system_literal_value_dq" ); }
        method pub_id_literal           ( $/, $w? ) { self.remember( $/, "pub_id_literal" ); }
        method pub_id_literal_v         ( $/, $w? ) { self.remember( $/, "pub_id_literal_v" ); }
        method pub_id_literal_value_sq  ( $/, $w? ) { self.remember( $/, "pub_id_literal_value_sq" ); }
        method pub_id_literal_value_dq  ( $/, $w? ) { self.remember( $/, "pub_id_literal_value_dq" ); }
        method pub_id_char              ( $/, $w? ) { self.remember( $/, "pub_id_char" ); }
        method char_data                ( $/, $w? ) { self.remember( $/, "char_data" ); }
        method cd                       ( $/, $w? ) { self.remember( $/, "cd" ); }
        method text_node                ( $/, $w? ) { self.remember( $/, "text_node" ); }
        method comment                  ( $/, $w? ) { self.remember( $/, "comment" ); }
        method comment_data             ( $/, $w? ) { self.remember( $/, "comment_data" ); }
        method pi                       ( $/, $w? ) { self.remember( $/, "pi" ); }
        method pi_target                ( $/, $w? ) { self.remember( $/, "pi_target" ); }
        method cd_sect                  ( $/, $w? ) { self.remember( $/, "cd_sect" ); }
        method cd_start                 ( $/, $w? ) { self.remember( $/, "cd_start" ); }
        method c_data                   ( $/, $w? ) { self.remember( $/, "c_data" ); }
        method cd_end                   ( $/, $w? ) { self.remember( $/, "cd_end" ); }
        method prolog                   ( $/, $w? ) { self.remember( $/, "prolog" ); }
        method xml_decl                 ( $/, $w? ) { self.remember( $/, "xml_decl" ); }
        method equal                    ( $/, $w? ) { self.remember( $/, "equal" ); }
        method version_num              ( $/, $w? ) { self.remember( $/, "version_num" ); }
        method misc                     ( $/, $w? ) { self.remember( $/, "misc" ); }
        method doctype_decl             ( $/, $w? ) { self.remember( $/, "doctype_decl" ); }
        method decl_sep                 ( $/, $w? ) { self.remember( $/, "decl_sep" ); }
        method int_subset               ( $/, $w? ) { self.remember( $/, "int_subset" ); }
        method markup_decl              ( $/, $w? ) { self.remember( $/, "markup_decl" ); }
        method ext_subset               ( $/, $w? ) { self.remember( $/, "ext_subset" ); }
        method ext_subset_decl          ( $/, $w? ) { self.remember( $/, "ext_subset_decl" ); }
        method sd_decl                  ( $/, $w? ) { self.remember( $/, "sd_decl" ); }
        method element                  ( $/, $w? ) { self.remember( $/, "element", "Element" ); }
        method root                     ( $/, $w? ) { self.remember( $/, "element", "ROOT" ); }
        method s_tag                    ( $/, $w? ) { self.remember( $/, "s_tag" ); }
        method empty_elem_name          ( $/, $w? ) { self.remember( $/, "empty_elem_name", "Element \"" ~ $/<name> ~ "\"" ); }
        method s_tag_name               ( $/, $w? ) { self.remember( $/, "s_tag", "Element \"" ~ $/<name> ~ "\"" ); }
        method attribute                ( $/, $w? ) { self.remember( $/, "attribute" ); }
        method e_tag                    ( $/, $w? ) { self.remember( $/, "e_tag" ); }
        method content                  ( $/, $w? ) { self.remember( $/, "content" ); }
        method empty_elem_tag           ( $/, $w? ) { self.remember( $/, "empty_elem_tag" ); }
        method element_decl             ( $/, $w? ) { self.remember( $/, "element_decl" ); }
        method content_spec             ( $/, $w? ) { self.remember( $/, "content_spec" ); }
        method children                 ( $/, $w? ) { self.remember( $/, "children" ); }
        method cp                       ( $/, $w? ) { self.remember( $/, "cp" ); }
        method choice                   ( $/, $w? ) { self.remember( $/, "choice" ); }
        method seq                      ( $/, $w? ) { self.remember( $/, "seq" ); }
        method mixed                    ( $/, $w? ) { self.remember( $/, "mixed" ); }
        method att_list_decl            ( $/, $w? ) { self.remember( $/, "att_list_decl" ); }
        method att_def                  ( $/, $w? ) { self.remember( $/, "att_def" ); }
        method att_type                 ( $/, $w? ) { self.remember( $/, "att_type" ); }
        method string_type              ( $/, $w? ) { self.remember( $/, "string_type" ); }
        method tokenized_type           ( $/, $w? ) { self.remember( $/, "tokenized_type" ); }
        method enumerated_type          ( $/, $w? ) { self.remember( $/, "enumerated_type" ); }
        method notation_type            ( $/, $w? ) { self.remember( $/, "notation_type" ); }
        method enumeration              ( $/, $w? ) { self.remember( $/, "enumeration" ); }
        method default_decl             ( $/, $w? ) { self.remember( $/, "default_decl" ); }
        method char_ref                 ( $/, $w? ) { self.remember( $/, "char_ref" ); }
        method reference                ( $/, $w? ) { self.remember( $/, "reference" ); }
        method entity_ref               ( $/, $w? ) { self.remember( $/, "entity_ref" ); }
        method pe_reference             ( $/, $w? ) { self.remember( $/, "pe_reference" ); }
        method entity_decl              ( $/, $w? ) { self.remember( $/, "entity_decl" ); }
        method entity_decl_start        ( $/, $w? ) { self.remember( $/, "entity_decl_start", 'Entity' ); }
        method entity_decl_end          ( $/, $w? ) { self.remember( $/, "entity_decl_end" ); }
        method ge_decl                  ( $/, $w? ) { self.remember( $/, "ge_decl" ); }
        method pe_decl                  ( $/, $w? ) { self.remember( $/, "pe_decl" ); }
        method pe_entity_def            ( $/, $w? ) { self.remember( $/, "pe_entity_def" ); }
        method pe_def                   ( $/, $w? ) { self.remember( $/, "pe_def" ); }
        method external_id              ( $/, $w? ) { self.remember( $/, "external_id" ); }
        method ndata_decl               ( $/, $w? ) { self.remember( $/, "ndata_decl" ); }
        method text_decl                ( $/, $w? ) { self.remember( $/, "text_decl" ); }
        method ext_parsed_ent           ( $/, $w? ) { self.remember( $/, "ext_parsed_ent" ); }
        method encoding_decl            ( $/, $w? ) { self.remember( $/, "encoding_decl" ); }
        method enc_name                 ( $/, $w? ) { self.remember( $/, "enc_name" ); }
        method notation_decl            ( $/, $w? ) { self.remember( $/, "notation_decl" ); }
        method public_id                ( $/, $w? ) { self.remember( $/, "public_id" ); }
        method cd                       ( $/, $w? ) { self.remember( $/, "cd" ); }
        method rest                     ( $/, $w? ) { self.remember( $/, "rest" ); }
};
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
            self.parser.handlers.text( $t, self.parser.context );
        }
    }
}
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

# This grammar defines the rules to parse XML as per W3C specification ( http://www.w3.org/TR/REC-xml/ )

# All XML processors MUST accept the UTF-8 and UTF-16 encodings of Unicode [Unicode];

# All #xD characters literally present in an XML document are either removed or replaced by #xA
# characters before any other processing is done.


# A Name is an Nmtoken with a restricted set of initial characters.]
#Disallowed initial characters for Names include digits, diacritics, the full stop and the hyphen.
#
# Names beginning with the string "xml", or with any string which would match (('X'|'x') ('M'|'m') ('L'|'l')), are reserved
# for standardization in this or future versions of this specification.

# All text that is not markup constitutes the character data of the document.

# Parameter entity references MUST NOT be recognized within comments.
# Comments

# The grammar does not allow a comment ending in --->. The following example is not well-formed.
# <!-- B+, B, or B--->

grammar XML::Parser::Grammar {
        token TOP {
                <document_start>
                [
                        <document_end> { die "!Syntax Error in DOCUMENT, no content" }
                        |
                        <document>
                        <document_end>
                ]
        }
        token document_start { ^ }
        token document_end { $ }


        # Document
        # [1]     document     ::=    prolog element Misc*
        token document {
                <prolog>
                [
                        <?before <document_end>>
                        { die "!Syntax Error before ROOT, missing root element" }
                        |
                        <root>
                        <misc>*
                ]
        }

        # [2]     Char     ::=    #x9 | #xA | #xD | [#x20-#xD7FF] | [#xE000-#xFFFD] | [#x10000-#x10FFFF]
        #         any Unicode character, excluding the surrogate blocks, FFFE, and FFFF. */
        # token char { <[ \x[9] \x[A] \x[D] \x[20]..\x[D7FF] \x[E000]..\x[FFFD] \x[10000]-\x[10FFFF] ]> }
        token char { \w }

        # [3]     S    ::=    (#x20 | #x9 | #xD | #xA)+
        token wts { [ \x[9] | \x[A] | \x[D] | \x[20] ]+ }


        # [4]     NameStartChar    ::=    ":" | [A-Z] | "_" | [a-z] | [#xC0-#xD6] | [#xD8-#xF6] | [#xF8-#x2FF] | [#x370-#x37D] | [#x37F-#x1FFF] | [#x200C-#x200D] | [#x2070-#x218F] | [#x2C00-#x2FEF] | [#x3001-#xD7FF] | [#xF900-#xFDCF] | [#xFDF0-#xFFFD] | [#x10000-#xEFFFF]
        token name_start_char { <[ \: A..Z a..z \_ ]> }
#         token name_start_char {
#                 <[
#                         \: \_ A..Z  a..z
#                         \x[C0]..\x[D6]      \x[D8]..\x[F6]      \x[F8]..\x[2FF]
#                         \x[370]..\x[37D     \x[37F]..\x[1FFF]   \x[200C]..\x[200D]
#                         \x[2070]..\x[218F]  \x[2C00]..\x[2FEF]  \x[3001]..\x[D7FF]
#                         \x[F900]..\x[FDCF]  \x[FDF0]..\x[FFFD]  \x[10000]..\x[EFFFF]
#                 ]>
#         }

        # [4a]    NameChar     ::=    NameStartChar | "-" | "." | [0-9] | #xB7 | [#x0300-#x036F] | [#x203F-#x2040]
        # token name_char { <[ <name_start_char> \- \| \. 0..9 \[xB7] \[0300]..\[x036F] \[x203F]..\[x2040] ]> }
        token name_char { [ <name_start_char> | \- | \. | \d ] }
        # token name_char { \w }

        # [5]     Name     ::=    NameStartChar (NameChar)*
        token name
        {
                # { say "<name" }
                [ <xname> | <ename> ]
                # { say ">name $/" }
        }
        token xname {
                # { say "<xname" }
                <name_start_char>
                # { say "<+start_char $/" }
                <name_char>*
                # { say "<+name_char $/" }
        }

        token ename {
                # { say "<ename" }
                \%
                # { say "+&" }
                <xname>
                #{ say "+xname $/" }
                \;
        }

        # [6]     Names    ::=    Name (#x20 Name)*
        token names { <name> \x[20] <name> }

        # [7]     Nmtoken    ::=    (NameChar)+
        token nm_token { <name_char>+ }

        # [8]     Nmtokens     ::=    Nmtoken (#x20 Nmtoken)*
        token nm_tokens { <nm_token> \x[20] <nm_token> }


        # [9]     EntityValue    ::=    '"' ([^%&"] | PEReference | Reference)* '"'  |  "'" ([^%&'] | PEReference | Reference)* "'"
        token entity_value_dv { [
                [ <-[ \% \& \" ]> | <pe_reference>  | <reference> ]*
        ] }
        token entity_value_sv { [ <-[ \% \& \' ]> | <pe_reference>  | <reference>  ]*   }
        token entity_value_sq { \' <entity_value_sv> \' } #'
        token entity_value_dq { \" <entity_value_dv> \" } #"
        token entity_value    { [ <entity_value_sq> | <entity_value_dq> ] }

        # [10]    AttValue     ::=    '"' ([^<&"] | Reference)* '"' |  "'" ([^<&'] | Reference)* "'"
        token att_value_dv {
                [
                        <reference>
                        |
                        [
                                [
                                        [
                                                <?before <[ \< \& ]>>
                                                { die "!Syntax error in <candidate>, attribute contains illegal values" }
                                                |
                                                <-[ \< \& \" ]>       #"
                                        ]

                                ]+
                        ]
                ]*
        }

        token att_value_sv {
                [
                        <reference>
                        |
                        [
                                [
                                        [
                                                <?before <[ \< \& ]>>
                                                { die "!Syntax error in <candidate>, attribute contains illegal values" }
                                                |
                                                <-[ \< \& \' ]>       #'
                                        ]

                                ]+
                        ]
                ]*
        }

        token att_value_sq { \' <att_value_sv>  \' } #'
        token att_value_dq { \" <att_value_dv> \" } #"
        token att_value    {
                [ <att_value_sq> | <att_value_dq> ]
        }

        # [11]    SystemLiteral    ::=    ('"' [^"]* '"') | ("'" [^']* "'")
        token system_literal          { [ <system_literal_value_sq> | <system_literal_value_dq> ] }
        token system_literal_value_sq { \' <-[ \' ]>* \' } #'
        token system_literal_value_dq { \" <-[ \" ]>* \" } #"

        # [12]    PubidLiteral     ::=    '"' PubidChar* '"' | "'" (PubidChar - "'")* "'"
        token pub_id_literal    { [ <pub_id_literal_sq> | <pub_id_literal_dq> ] }
        token pub_id_literal_v  { <pub_id_char> * } #'
        token pub_id_literal_sq { \' ~ \' <pub_id_literal_v> } #'
        token pub_id_literal_dq { \" ~ \" <pub_id_literal_v> } #"

        # [13]    PubidChar    ::=    #x20 | #xD | #xA | [a-zA-Z0-9] | [-'()+,./:=?;!*#@$_%]
        # token pub_id_char { <[ \x[20] \x[D] \x[A] a..z A..Z 0..9 \( \) \+ \, \. \/ \: \= \? \; \! \* \# \@ \$ \_ \% ]> } #/
        #token pub_id_char { [ \x[20] | \x[D] | \x[A] | <[ a..z A..Z 0..9 \( \) \+ \, \. \/ \: \= \? \; \! \* \# \@ \$ \_ \% ]> } #/
        token pub_id_char { [ \x[20] | \x[D] | \x[A] | <[ a..z A..Z 0..9 \- \( \) \+ \, \. \/ \: \= \? \; \! \* \# \@ \$ \_ \% ]> ] } #/


        # [14]    CharData     ::=    [^<&]* - ([^<&]* ']]>' [^<&]*)
        token char_data { <-[ \< \& ]>*? <?before \] \] \>> }

        # [15]    Comment    ::=    '<!--' ((Char - '-') | ('-' (Char - '-')))* '-->'
        token comment {
                \< \! \- \- <comment_data> \- \- \>
        }
        token comment_data { .*? <?before \- \-> }

        # [16]    PI     ::=    '<?' PITarget (S (Char* - (Char* '?>' Char*)))? '?>'
        token pi {
                <pi_start>
                [
                        xml { die "!Syntax Error in DOCUMENT, XML-Declaration misplaced" }
                        |
                        <pi_target> <wts> <pi_data>?
                ]
                <pi_end> }

        token pi_start { \< \?  }
        token pi_end { \? \> }
        token pi_data { <char>*? <?before \? \>> }

        # [17]    PITarget     ::=    Name - (('X' | 'x') ('M' | 'm') ('L' | 'l'))
        token pi_target { <name> }

        # [18]    CDSect     ::=    CDStart CData CDEnd
        token cd_sect {   <cd_start> <c_data> <cd_end> }

        # [19]    CDStart    ::=    '<![CDATA['
         token cd_start { \< \! \[ CDATA \[ }

        # [20]    CData    ::=    (Char* - (Char* ']]>' Char*))
        token c_data { .*? <?before \] \] \>> }

        # [21]    CDEnd    ::=    ']]>'
        token cd_end { \] \] \> }

        # [22]    prolog     ::=    XMLDecl? Misc* (doctypedecl Misc*)?
        token prolog { <xml_decl>? <misc>* [ <doctype_decl> <misc>*]? }

        # [23]    XMLDecl    ::=    '<?xml' VersionInfo EncodingDecl? SDDecl? S? '?>'
        token xml_decl {
                <xml_decl_start>
                [
                        <version_info>
                        <encoding_decl>? <sd_decl>? <wts>?
                        [
                                <!before <xml_decl_end>>
                                { die '!Syntax error in XML-Declaration, missing "?>"' }
                                |
                                <xml_decl_end>
                        ]
                ]
        }

        token xml_decl_start {
                \<
                [
                        <wts> \? { die '!Syntax error in XML-Declaration, space between "<" and "?"' } |
                        \?
                        [
                                <wts> xml { die '!Syntax error in XML-Declaration, space between "<?" and "xml"' } |
                                xml
                        ]
                ]
        }

        token xml_decl_end {
                \?
                [
                        <wts> \> { die '!Syntax error in XML-Declaration, space between "?" and ">"' }
                        |
                        \>
                ]
        }

        # [24]    VersionInfo    ::=    S 'version' Eq ("'" VersionNum "'" | '"' VersionNum '"')
        token version_info {
                <wts>
                [
                        [
                                version |
                                { die '!Syntax Error in XML-Declaration, no "version" info' }
                        ]

                        [
                                <equal> |
                                <!before <equal>> { die '!Syntax Error in XML-Declaration, missing "="' }
                        ]

                        [
                                [
                                        \" <version_num> \" |    #"
                                        \' <version_num> \'      #'
                                ] |
                                <!before <equal>> { die '!Syntax Error in XML-Declaration, missing "value"' }
                        ]
                ]
        }

        # [25]    Eq     ::=    S? '=' S?
        token equal {
                <wts>* \= <wts>*
        }

        # [26]    VersionNum     ::=    '1.' [0-9]+
        token version_num {
                [
                        <!before <version_numm>> { die '!Syntax Error in XML-Declaration, "version" not like "1.*"' }
                        |
                        <version_numm>
                ]
        }
        token version_numm { 1 \. <[ 0..9 ]>+ }

        # [27]    Misc     ::=    Comment | PI | S
        token misc { [ <comment> | <pi> | <wts> | <pre_text> ] }

        # [28]    doctypedecl    ::=    '<!DOCTYPE' S Name (S ExternalID)? S? ('[' intSubset ']' S?)? '>'
        token doctype_decl {
                <doctype_decl_start> <wts>
                <doctype_decl_name>
                [
                        <wts> <external_id>
                        ( <wts>? <?before \[> <doctype_body> )?
                        |
                        <wts>? <doctype_body>
                ]

                <doctype_decl_end>
        }

        token doctype_decl_start {
                \< \! DOCTYPE
        }

        token doctype_decl_end  {
                [
                        ( <!before \>> { die '!Syntax Error in DOCTYPE declaration, missing closing ">"' } )

                        | \>
                ]
        }


        token doctype_decl_name {
                [
                        <!before <name>> { die '!Syntax Error in DOCTYPE declaration, missing "name"' }
                        | <name>
                ]
        }

        token doctype_body {
                        <doctype_body_open_brace>
                        <wts>? <int_subset> <wts>?
                        <doctype_body_close_brace>
        }

        token doctype_body_open_brace {
                [
                        <?before \>>
                        |
                        <!before \[> { die '!Syntax Error in DOCTYPE declaration, missing "["' }
                        |
                        \[
                ]

        }

        token doctype_body_close_brace {
                [
                        ( <!before \]> { die '!Syntax Error in DOCTYPE declaration, missing "]"' } )
                        | \]
                ]
        }

        # [28a]     DeclSep    ::=    PEReference | S   [WFC: PE Between Declarations]
        token decl_sep { [ <pe_reference> | <wts> ] }

        # [28b]     intSubset    ::=    (markupdecl | DeclSep)*
        token int_subset {  [ <markup_decl> | <decl_sep> ]* }

        # [29]    markupdecl     ::=    elementdecl | AttlistDecl | EntityDecl | NotationDecl | PI | Comment
        token markup_decl {
                        [ <element_decl>
                        | <attlist_decl>
                        | <entity_decl>
                        | <notation_decl>
                        | <pi>
                        | <comment> ]
        }

        # [30]    extSubset    ::=    TextDecl? extSubsetDecl
        token ext_subset { <text_decl>? <ext_subset_decl> }

        # [31]    extSubsetDecl    ::=    ( markupdecl | conditionalSect | DeclSep)*
        token ext_subset_decl { [ <markup_decl> | <conditional_sect> | <decl_sep> ]* }

        # [32]    SDDecl     ::=    S 'standalone' Eq (("'" ('yes' | 'no') "'") | ('"' ('yes' | 'no') '"'))
        token sd_decl { <wts> standalone <equal>
                [
                        <sd_decl_value>
                        |
                        { die '!Syntax Error in XML-Deklaration, "standalone" not "yes" or "no"' }
                ]
        }

        token sd_decl_value {
                [
                        \"                       #"
                        <sd_value>
                        \"                       #"
                        |
                        \'                       #'
                        <sd_value>
                        \'                       #'
                ]
        }

        token sd_value { [ yes|no ] }

        # [39]    element    ::=
        token root {
                <element>
                <ws>?
                <after_text>?
        }

        token element {
                [
                        <empty_elem_tag> |
                        <s_tag> <content> <e_tag>
                        {
                                die
                                        '!Syntax-Error in Element, closing Tag "' ~
                                        $/<e_tag><name> ~ '" doesn\'t match "' ~
                                        $/<s_tag><s_tag_name> ~ '"'
                                                unless $/<s_tag><s_tag_name> eq $/<e_tag><name>;
                        }
                ]
        }

        token after_text {
                        <?before .> { die "!Syntax Error after ROOT, illegal content" }
        }

        token pre_text {
                        <?before <[a..z]>> { die "!Syntax Error before ROOT, illegal content" }
        }

        # [40]    STag     ::=    '<' Name (S Attribute)* S? '>'
        token s_tag {
                \< <s_tag_name>
                # {say '..stag'; }
                [
                        <wts>? \>
                        |
                        <attributes> <wts>? \>
                ]
         }

        token attributes {
                ( <wts> <attribute> )+
        }

        token s_tag_name {
                <name>
        }

        # [41]    Attribute    ::=    Name Eq AttValue
        token attribute {
#                {say '!?'}
                <att_name>*
#                {say '??'}
                <equal>
                { die "#" unless $<att_name> }


                # {say '???'}
                <att_value>
#                 {
#                         die "Syntax error in <candidate>, attribute contains illegal values"
#                                 if "$/" ~~ / <[ \& \< ]> /;
#                 }
        }

        token att_name {
                <name>
#                 <!before <wts> \>>
#                 {
#                         die '!Syntax error in Element "root", malformed or missing attribute name' unless $/<name>
#                 }
        }

        # [42]    ETag     ::=    '</' Name S? '>'
        token e_tag { \< \/ <name> <wts>? \> } #/

        token rest { .+ }
        token z { z+ }

        # [43]    content    ::=    CharData? ((element | Reference | CDSect | PI | Comment) CharData?)*
        token content {
                <text_node>?
                [
                        [
                                | <element>
                                # { say '*element ',$<element> }
                                | <reference>
                                # { say '*reference ',$<reference> }
                                | <cd_sect>
                                # { say '*cd_sect ',$<cd_sect> }
                                | <pi>
                                # { say '*pi ',$<pi> }
                                | <comment> :
                                # { say '*comment ',$<comment> }
                        ]
                        <text_node>?
                ] *
        }

        token text_node { <cd> }

        token cd { <-[ \& \< ]>+ }

        # [44]    EmptyElemTag     ::=    '<' Name (S Attribute)* S? '/>'
        token empty_elem_tag {
                \<
                <empty_elem_name>
                [
                        <wts>? \/ \>
                        |
                        <attributes> <wts>? \/ \>
                ]
        } #/

        token empty_elem_name {
                <name>
        }

        # [45]    elementdecl    ::=    '<!ELEMENT' S Name S contentspec S? '>'
        # <!ELEMENT %name.para; %content.para; >
        token element_decl {
                \< \! ELEMENT
                # { say "<ELEMENT" }
                <wts> <name> <wts>
                # { say "+name $/" }
                <content_spec> <wts>?
                \>
        }


        # [46]    contentspec    ::=    'EMPTY' | 'ANY' | Mixed | children
        token content_spec { [ EMPTY | ANY | <mixed> | <children> ] }

        # [47]    children     ::=    (choice | seq) ('?' | '*' | '+')?
        token children { [ <choice> | <seq> ] <[ \? \* \+ ]>? }

        # [48]    cp     ::=    (Name | choice | seq) ('?' | '*' | '+')?
        token cp { [ <name> | <choice> | <seq> ] <[ \? \* \+ ]>? }

        # [49]    choice     ::=    '(' S? cp ( S? '|' S? cp )+ S? ')'
        token choice { \( <wts>? <cp> ( <wts>? \| <wts>? <cp> )+ <wts>? \) }

        # [50]    seq    ::=    '(' S? cp ( S? ',' S? cp )* S? ')'
        token seq { \( <wts>? <cp> ( <wts>? \, <wts>? <cp> )* <wts>? \) }

        # [51]    Mixed    ::=    '(' S? '#PCDATA' (S? '|' S? Name)* S? ')*' | '(' S? '#PCDATA' S? ')'
        token mixed { [
                \( <wts>?
                \# PCDATA
                 [<wts>? \| <wts>? <name>]*
                <wts>?
                \) \*?
                 |
                 \( <wts>
                 \# PCDATA
                 <wts>?
                 \)
        ] }

        # [52]    AttlistDecl    ::=    '<!ATTLIST' S Name AttDef* S? '>'
        token attlist_decl { \< \! ATTLIST <wts> <name> <att_def>* <wts>? \> }

        # [53]    AttDef     ::=    S Name S AttType S DefaultDecl
        token att_def { <wts> <name> <wts> <att_type> <wts> <default_decl> }

        # [54]    AttType    ::=    StringType | TokenizedType | EnumeratedType
        token att_type { [ <string_type> | <tokenized_type> | <enumerated_type> ] }

        # [55]    StringType     ::=    'CDATA'
        token string_type { CDATA }

        # [56]    TokenizedType    ::=    'ID' | 'IDREF' | 'IDREFS' | 'ENTITY' | 'ENTITIES' | 'NMTOKEN' | 'NMTOKENS'
        token tokenized_type { [ ID | IDREF | IDREFS | ENTITY | ENTITIES | NMTOKEN | NMTOKENS ] }

        # [57]    EnumeratedType     ::=    NotationType | Enumeration
        token enumerated_type { [ <notation_type> | <enumeration> ] }

        # [58]    NotationType     ::=    'NOTATION' S '(' S? Name (S? '|' S? Name)* S? ')'
        token notation_type { NOTATION <wts> \( <wts> <name> (<wts>? \| <wts>? <name>)* <wts>? \) }

        # [59]    Enumeration    ::=    '(' S? Nmtoken (S? '|' S? Nmtoken)* S? ')'
        token enumeration { \( <wts>? <nm_token> [ <wts>? \| <wts>? <nm_token>]* <wts>? \) }

        # [60]    DefaultDecl    ::=    '#REQUIRED' | '#IMPLIED' | (('#FIXED' S)? AttValue)
        token default_decl { [ \#REQUIRED | \#IMPLIED | (\#FIXED <wts>)? <att_value> ] }

        # [66]    CharRef    ::=    '&#' [0-9]+ ';' | '&#x' [0-9a-fA-F]+ ';
        token char_ref {
                \&
                \#
                [
                        [
                                <char_ref_value> | {
                                        die '!Syntax Error in CHAR-Reference, missing "value"'
                                                unless $<char_ref_value>;
                                }
                        ]
                        [
                                \; |
                                { die '!Syntax Error in CHAR-Reference, missing ";"' }
                        ]
                ]
        }

        token char_ref_value
        {
                [
                        \d+ | x <[ 0..9 a..z A..Z ]>+
                ]
        }

        token reference {
                [ <entity_ref> | <char_ref> ]
        }

        # [68]    EntityRef    ::=    '&' Name ';'
        token entity_ref {

                \& <!before \#>

                [
                        <?before \d> { die '!Syntax Error in CHAR-Reference, missing "#"' }
                        |
                        <!before <name_start_char>> { die '!Syntax Error in ENTITY-Reference, missing "name"' }
                        |
                        <name>
                        [
                                <!before \;> { die '!Syntax Error in ENTITY-Reference, missing ";"' }
                                |
                                \;
                        ]
                ]
        }

        # [69]    PEReference    ::=    '%' Name ';'  [VC: Entity Declared]
        token pe_reference {
                <wts>*
                \%
                <name> \; }

        # [70]    EntityDecl     ::=    GEDecl | PEDecl
        token entity_decl {
                [ <pe_decl> | <ge_decl> ]
        }

        # [71]    GEDecl     ::=    '<!ENTITY' S Name S EntityDef S? '>'
        token ge_decl {
                <ge_decl_start>
                <wts>
                <ge_decl_name> <wts>
                <entity_def> <wts>?
                <ge_decl_end>
        }

        token ge_decl_start {
                \< \! ENTITY
        }

        token ge_decl_end {
                [
                        <!before \>>  { die '!Syntax Error in ENTITY-Deklaration, missing ">"' }
                        |
                        \>
                ]
        }

        token ge_decl_name {
                [
                        <!before <name_char>>  { die '!Syntax Error in ENTITY-Deklaration, missing "name"' }
                        |
                        <name>
                ]
        }


        # [72]    PEDecl     ::=    '<!ENTITY' S '%' S Name S PEDef S? '>'
        token pe_decl {
                <pe_decl_start> <wts>
                \% <wts> <name> <wts>
                <pe_def> <wts>?
                <pe_decl_end>
        }

        token pe_decl_start {
                \< \! ENTITY
        }

        token pe_decl_end {
                \>
        }

        # [73]    EntityDef    ::=    EntityValue | (ExternalID NDataDecl?)
        token entity_def {
                [
                        #= internal
                        <?before <[ \" \' ]>>
                        <entity_value>
                        |
                        <?before <[SYSTEM|PUBLIC]>>
                        <external_id> <ndata_decl>?
                        |
                        { die '!Syntax Error in ENTITY-Deklaration, missing or wrong "definition"' }
                ]
        }

        #"
        token ent_decl_identifier {
            <?before <[SYSTEM|PUBLIC]>>
        }
        # [74]    PEDef    ::=    EntityValue | ExternalID
        token pe_def { <entity_value> | <external_id> }

        # [75]    ExternalID     ::=    'SYSTEM' S SystemLiteral | 'PUBLIC' S PubidLiteral S SystemLiteral
        token external_id { [
                SYSTEM <wts> <system_literal>
                |
                PUBLIC <wts> <pub_id_literal> <wts> <system_literal>
        ] }

        # [76]    NDataDecl    ::=    S 'NDATA' S Name
        token ndata_decl { <wts> NDATA <wts> <name> }

        # [77]    TextDecl     ::=    '<?xml' VersionInfo? EncodingDecl S? '?>'
        token text_decl { \< \? xml <version_info>? <encoding_decl> <wts>? \? \> }

        # [78]    extParsedEnt     ::=    TextDecl? content
        token ext_parsed_ent { <text_decl>? <content> }

        # [80]    EncodingDecl     ::=    S 'encoding' Eq ('"' EncName '"' | "'" EncName "'" )
        token encoding_decl {
                <wts> encoding <equal> [
                        <!before <encoding_decl_value>> { die '!Syntax Error in XML-Deklaration, unknown "encoding"' }
                        |
                        <encoding_decl_value>
                ]
        }

        token encoding_decl_value {
                [
                        \"              #"
                        <enc_name>
                        \"              #"
                        |
                        \'              #'
                        <enc_name>
                        \'              #'
                ]
        }

        # [81]    EncName    ::=    [A-Za-z] ([A-Za-z0-9._] | '-')* /* Encoding name contains only Latin characters */
        token enc_name { <[ a..z A..Z ]> <[ a..z A..Z 0..9 \. \_ \- ]>* }

        # [82]    NotationDecl     ::=    '<!NOTATION' S Name S (ExternalID | PublicID) S? '>'  [VC: Unique Notation Name]
        token notation_decl { \< \! NOTATION <wts> <name> <wts> [ <external_id> | <public_id> ] <wts>? \> }

        # [83]    PublicID     ::=    'PUBLIC' S PubidLiteral
        token public_id { PUBLIC <wts> <pub_id_literal> }

};
class XML::Parser {
    has XML::Parser::Actions::Base $.action   is rw;
    has XML::Parser::Dom::Document $.document is rw;
    has XML::Parser::Dom::Node     $.context  is rw;
    has Any                        $.handlers;

    has Any                        @.stack is rw;

    multi method parse (Str $xml, Str $action, Any $action_arg?)
    {
        self.parse( $xml, do given $action {
                when 'dom'      { XML::Parser::Actions::Dom.new( parser=>self ) }
                when 'test'     { XML::Parser::Actions::Test.new( parser=>self ) }
                when 'debug'    { XML::Parser::Actions::Debug.new( parser=>self ) }
                when 'handlers' { XML::Parser::Actions::Handlers.new( parser=>self ) }
                default         { die "Unknown XML::Parser::Action" }
        } );
    }

    multi method parse (Str $xml, XML::Parser::Actions::Base   $actions)
    {
        my $parse;

        try {
                $parse = XML::Parser::Grammar.parse( $xml, actions => $actions );
        }

        my $error   = $! ?? "$!" !! "";
        my $handled = '';

        if $error
        {
            $handled = $error.substr(0,1) eq '!';

            $error   = $error.subst('<candidate>', self.action.lastCandidate)
                if self.action.can('lastCandidate');

            $error   = $error.subst(/^\!/, '');

            die $error
                    if $handled;

            die "Syntax error in  ( $! )"; # { self.action.lastCandidate }
        }

        return $parse;
    }
}
