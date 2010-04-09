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
