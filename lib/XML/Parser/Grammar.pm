
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
                [ <-[ \% \& \" ]> | <pe_reference_unparsed>  | <reference_unparsed> ]*
        ] }
        token entity_value_sv { [ <-[ \% \& \' ]> | <pe_reference_unparsed>  | <reference_unparsed>  ]*   }
        token entity_value_sq { \' <entity_value_sv> \' } #'
        token entity_value_dq { \" <entity_value_dv> \" } #"
        token entity_value    { [ <entity_value_sq> | <entity_value_dq> ] }

        # [10]    AttValue     ::=    '"' ([^<&"] | Reference)* '"' |  "'" ([^<&'] | Reference)* "'"
        token att_value_dv {
                [
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

        token reference_unparsed {
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

        token pe_reference_unparsed {
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
