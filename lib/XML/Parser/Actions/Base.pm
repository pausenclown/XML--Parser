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



