class XML::Parser::Action::Test {
        has Any $.lastMatch is rw;
        has Str $.lastToken is rw;
        
        method remember (Any $match, Str $token) {
                self.lastToken = $token;
                self.lastMatch = $match;
                # say " <$match $token> "
        }

        method TOP                      ( $/, $w? ) { self.remember( $/, "TOP" ); }
        method document                 ( $/, $w? ) { self.remember( $/, "document" ); }
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
        method element                  ( $/, $w? ) { self.remember( $/, "element" ); }
        method s_tag                    ( $/, $w? ) { self.remember( $/, "s_tag" ); }
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
        token TOP { <document> }

        # Document
        # [1]     document     ::=    prolog element Misc*
        token document { 
                <prolog> 
                # {say "..prolog $/" } 
                <element> 
                <misc>* 
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
        token entity_value_dv  { [ <-[ \% \& \" ]> | <pe_reference>  | <reference>  ]*   } 
        token entity_value_sv  { [ <-[ \% \& \' ]> | <pe_reference>  | <reference>  ]*   }
        token entity_value_sq { \' <entity_value_sv> \' } #'
        token entity_value_dq { \" <entity_value_dv> \" } #"
        token entity_value    { [ <entity_value_sq> | <entity_value_dq> ] }
        
        # [10]    AttValue     ::=    '"' ([^<&"] | Reference)* '"' |  "'" ([^<&'] | Reference)* "'"
        token att_value_dv  { [ <-[ \% \& \" ]> | <reference> ]* } #'
        token att_value_sv  { [ <-[ \% \& \' ]> | <reference> ]* } #'
        token att_value_sq { \' <att_value_sv>  \' } #'
        token att_value_dq { \" <att_value_dv> \" } #"
        token att_value    { [ <att_value_sq> | <att_value_dq> ] }

        # [11]    SystemLiteral    ::=    ('"' [^"]* '"') | ("'" [^']* "'")
        token system_literal { [ <system_literal_value_sq> | <system_literal_value_dq> ] }
        token system_literal_value_sq { \' <-[ \' ]>* \' } #'
        token system_literal_value_dq { \" <-[ \" ]>* \" } #"
        
        # [12]    PubidLiteral     ::=    '"' PubidChar* '"' | "'" (PubidChar - "'")* "'"
        token pub_id_literal { [ <pub_id_literal_sq> | <pub_id_literal_dq> ] }
        token pub_id_literal_v { <pub_id_char> * } #'
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
        token pi {\< \?  <!before xml> <pi_target> ( <wts> <char>* <?before \? \>>)?  {*} \? \> }
        
        # [17]    PITarget     ::=    Name - (('X' | 'x') ('M' | 'm') ('L' | 'l'))
        token pi_target { <name> }
 
        # [18]    CDSect     ::=    CDStart CData CDEnd
        token cd_sect {   <cd_start>    <c_data>  <cd_end> }

        # [19]    CDStart    ::=    '<![CDATA['
         token cd_start { \< \! \[ CDATA \[ }

        # [20]    CData    ::=    (Char* - (Char* ']]>' Char*))
        token c_data { .*? <?before \] \] \>> }
        
        # [21]    CDEnd    ::=    ']]>'
        token cd_end { \] \] \> }

        # [22]    prolog     ::=    XMLDecl? Misc* (doctypedecl Misc*)?
        token prolog { <xml_decl>? <misc>* [ <doctype_decl> <misc>*]? }
        
        # [23]    XMLDecl    ::=    '<?xml' VersionInfo EncodingDecl? SDDecl? S? '?>'
        token xml_decl { \< \? xml <version_info> <encoding_decl>? <sd_decl>? <wts>? \?\> }

        # [24]    VersionInfo    ::=    S 'version' Eq ("'" VersionNum "'" | '"' VersionNum '"')
        token version_info { <wts> version <equal> [ \" <version_num> \" | \' <version_num> \' ] }

        # [25]    Eq     ::=    S? '=' S?
        token equal { <wts>* \= <wts>* } 

        # [26]    VersionNum     ::=    '1.' [0-9]+
        token version_num { 1 \. <[ 0..9 ]>+ }

        # [27]    Misc     ::=    Comment | PI | S
        token misc { [ <comment> | <pi> | <wts> ] } 

        # [28]    doctypedecl    ::=    '<!DOCTYPE' S Name (S ExternalID)? S? ('[' intSubset ']' S?)? '>' 
        token doctype_decl {
                \< \! DOCTYPE 
                # {say 'doctype'; }
                <wts>  <name> 
                ( <wts> <external_id> )? <wts>? 
                (
                        \[ 
                        <int_subset> \]
                        <wts>? \]? 
                )?
                \> 
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
        token sd_decl { <wts> standalone <equal> [ \" [ yes|no ] \" | \' [ yes|no ] \' ] } #"

        # [39]    element    ::=    
        token element { 
                # {say "..element" } 
                [ 
                        <empty_elem_tag> | 
                        <s_tag> <content> <e_tag> 
                ] 
        }

        # [40]    STag     ::=    '<' Name (S Attribute)* S? '>'
        token s_tag { 
                \< <name> 
                # {say '..stag'; } 
                ( <wts> <attribute> )* <wts>? \> 
         }

        # [41]    Attribute    ::=    Name Eq AttValue
        token attribute { <name> <equal> <att_value> }

        # [42]    ETag     ::=    '</' Name S? '>'
        token e_tag { \< \/ <name> <wts>? \> } #/

        token rest { .+ }
        token z { z+ }

        # [43]    content    ::=    CharData? ((element | Reference | CDSect | PI | Comment) CharData?)*
        token content { 
                <cd>?
                (
                        [ 
                                <element> | 
                                <reference> | 
                                <cd_sect> | 
                                <pi> | 
                                <comment> 
                        ] 
                        <cd>?
                )* 
                
        }

        token cd { <-[ \& \< ]>+ }

        # [44]    EmptyElemTag     ::=    '<' Name (S Attribute)* S? '/>'
        token empty_elem_tag { 
                # {say "..ee $/" } 
                \< 
                # {say "...ee $/" } 
                <name> 
                # {say "....ee $/" } 
                (<wts> <attribute>)* <wts>? \/ \> 
        } #/

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
                # { say "<char_ref" } 
                \& \# [ \d+ | x <[ 0..9 a..z A..Z ]>+ ] \; }
                # { say "<char_ref $/" } 

        token reference { 
                # { say "<reference" } 
                [ <entity_ref> | <char_ref> ]  
        }
        
        # [68]    EntityRef    ::=    '&' Name ';'  
        token entity_ref { 
                # { say "<entity_ref $/" } 
                \& 
                # { say "+&" } 
                <name> 
                # { say "+name $/" }
                \; 
        }
 
        # [69]    PEReference    ::=    '%' Name ';'  [VC: Entity Declared]
        token pe_reference { \% <name> \; }

        # [70]    EntityDecl     ::=    GEDecl | PEDecl
        token entity_decl { 
                # { say '<entity_decl' }
                [ <ge_decl> | <pe_decl> ] 
        }

        # [71]    GEDecl     ::=    '<!ENTITY' S Name S EntityDef S? '>'
        token ge_decl { 
                # { say '<ge_decl' }
                \< \! ENTITY <wts> 
                <name> <wts> 
                # { say "+name $/", "#" }
                <entity_def> <wts>? 
                # { say "+entity_def $/" }
                \> 
                # { say '>ge_decl' }
        } 

        # [72]    PEDecl     ::=    '<!ENTITY' S '%' S Name S PEDef S? '>'
        token pe_decl { \< \! ENTITY <wts> \% <wts> <name> <wts> <pe_def> <wts>? \> }
        
        # [73]    EntityDef    ::=    EntityValue | (ExternalID NDataDecl?)
        token entity_def { 
                # { say "<entity_def" }
                [ 
                        <entity_value> | 
                        <external_id> <ndata_decl>? 
                ] 
        }

        # [74]    PEDef    ::=    EntityValue | ExternalID
        token pe_def { <entity_value> | <external_id> }

        # [75]    ExternalID     ::=    'SYSTEM' S SystemLiteral | 'PUBLIC' S PubidLiteral S SystemLiteral
        token external_id { SYSTEM <wts> <system_literal> | PUBLIC <wts> <pub_id_literal> <wts> <system_literal> } 

        # [76]    NDataDecl    ::=    S 'NDATA' S Name 
        token ndata_decl { <wts> NDATA <wts> <name> } 

        # [77]    TextDecl     ::=    '<?xml' VersionInfo? EncodingDecl S? '?>'
        token text_decl { \< \? xml <version_info>? <encoding_decl> <wts>? \? \> } 

        # [78]    extParsedEnt     ::=    TextDecl? content
        token ext_parsed_ent { <text_decl>? <content> }

        # [80]    EncodingDecl     ::=    S 'encoding' Eq ('"' EncName '"' | "'" EncName "'" )
        token encoding_decl { <wts> encoding <equal> [ \" <enc_name> \" | \' <enc_name> \' ] }  #'"
        
        # [81]    EncName    ::=    [A-Za-z] ([A-Za-z0-9._] | '-')* /* Encoding name contains only Latin characters */
        token enc_name { <[ a..z A..Z ]> <[ a..z A..Z 0..9 \. \_ \- ]>* }

        # [82]    NotationDecl     ::=    '<!NOTATION' S Name S (ExternalID | PublicID) S? '>'  [VC: Unique Notation Name]
        token notation_decl { \< \! NOTATION <wts> <name> <wts> [ <external_id> | <public_id> ] <wts>? \> } 

        # [83]    PublicID     ::=    'PUBLIC' S PubidLiteral
        token public_id { PUBLIC <wts> <pub_id_literal> } 

};


class XML::Parser {

        has Any $.action is rw;

        method new_action (Str $action, Any $action_arg ) {
                given $action {
                        when 'test' { self.action = XML::Parser::Action::Test.new( ) }
                }
                return self.action; 
        }

        method parse (Str $xml, Str $action = 'dom', Any $action_arg?)
        {
                my $parse = XML::Parser::Grammar.parse( $xml, actions => self.new_action( $action, $action_arg ) );

                die "Syntax error after " ~ self.action.lastToken
                        unless $parse;

                return $parse;
                1;
        }

        method parsefile (Str $file, Str $action = 'dom', Any $action_arg?)
        {
                my $parse = XParser::Grammar.parsefile( $file, actions => self.new_action( $action, $action_arg ) );

                die "Syntax error after " ~ self.action.lastFound
                        unless $parse;

                return $parse;
        }
}
