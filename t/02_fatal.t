use Test;
use XML::Parser;

my %xml = {
        'illegal content'                      => [ '<root>text</root>trash', "Syntax Error after ROOT, illegal content" ],
        'illegalcontent'                       => [ 'trash<root>text</root>', "Syntax Error before ROOT, illegal content" ],

        'no root node, but prolog'             => [ '<!-- no root node -->', 'Syntax Error before ROOT, missing root element' ],
        'no root node, but text'               => [ 'x', 'Syntax Error before ROOT, illegal content' ],
        'no root node, empty'                  => [ '', 'Syntax Error in DOCUMENT, no content' ],
        'no root node, only ws'                => [ ' ', 'Syntax Error before ROOT, missing root element' ],
        'nesting error'                        => [ '<root><nested></root><root>< /root>', 'Syntax-Error in Element, closing Tag "root" doesn\'t match "nested"' ],

        'doctype, missing ]'                   => [ '<!DOCTYPE foo [ trash ]>', 'Syntax Error in DOCTYPE declaration, missing "]"' ],
        'doctype, missing >'                   => [ '<!DOCTYPE foo [] <root/>', 'Syntax Error in DOCTYPE declaration, missing closing ">"' ],
        'doctype, missing ]'                   => [ '<!DOCTYPE foo [ <root/>', 'Syntax Error in DOCTYPE declaration, missing "]"' ],
        'doctype, missing name'                => [ '<!DOCTYPE []>', 'Syntax Error in DOCTYPE declaration, missing "name"' ],
        'doctype, missing ['                   => [ '<!DOCTYPE foo ]><root/>', 'Syntax Error in DOCTYPE declaration, missing "["' ],

        'entity, missing name'                 => [ '<!DOCTYPE foo [ <!ENTITY "&#xAFFE;"> ]> <root/>', 'Syntax Error in ENTITY-Deklaration, missing "name"' ],
        'entity, missing >'                    => [ '<!DOCTYPE foo [ <!ENTITY bar "AFFE" ]><root/>', 'Syntax Error in ENTITY-Deklaration, missing ">"' ],

        'entity, missing name >'               => [ '<!DOCTYPE foo [ <!ENTITY "AFFE" ]><root/>', 'Syntax Error in ENTITY-Deklaration, missing "name"' ],
        'entity, missing definition >'         => [ '<!DOCTYPE foo [ <!ENTITY bar ]><root/>', 'Syntax Error in ENTITY-Deklaration, missing or wrong "definition"' ],
        'entity, malformed definition >'       => [ '<!DOCTYPE foo [ <!ENTITY bar AFFE ]><root/>', 'Syntax Error in ENTITY-Deklaration, missing or wrong "definition"' ],
        'entity, malformed value >'            => [ '<!DOCTYPE foo [ <!ENTITY bar "&AFFE" ]><root/>', 'Syntax Error in ENTITY-Reference, missing ";"' ],
        'entity, missing external_id value >'  => [ '<!DOCTYPE foo [ <!ENTITY bar SYSTEM ]><root/>', 'Syntax Error in ENTITY-Deklaration, missing or wrong "definition"' ],
        'entity, malforme identifier >'        => [ '<!DOCTYPE foo [ <!ENTITY bar PUBIC "hello.dtd"> ]><root/>', 'Syntax Error in ENTITY-Deklaration, missing or wrong "definition"' ],
        'entity reference, missing ;'          => [ '<foo>&amp</foo>', 'Syntax Error in ENTITY-Reference, missing ";"'],
        'entity reference, missing name'       => [ '<foo>&;</foo>', 'Syntax Error in ENTITY-Reference, missing "name"'],
        'char reference, missing ;'            => [ '<foo>&#123</foo>', 'Syntax Error in CHAR-Reference, missing ";"'],
        'char reference, missing #'            => [ '<foo>&123</foo>', 'Syntax Error in CHAR-Reference, missing "#"'],
        'char reference, missing value'        => [ '<foo>&#;</foo>', 'Syntax Error in CHAR-Reference, missing "value"'],

        'xml_decl misplaced'                   => [ '<root><?xml version = "1.0" ?></root>', 'Syntax Error in DOCUMENT, XML-Declaration misplaced' ],
        'xml_decl, version borked'             => [ '<?xml version="1" ?><root/>', 'Syntax Error in XML-Declaration, "version" not like "1.*"' ],
        'xml_decl, encoding borked'            => [ '<?xml version="1.0" encoding="UTF!8" ?><root/>', 'Syntax Error in XML-Deklaration, unknown "encoding"' ],
        'xml_decl, no version info'            => [ '<?xml encoding="UTF-8" ?><root/>', 'Syntax Error in XML-Declaration, no "version" info' ],
        'xml_decl, standalone borked'          => [ '<?xml version = "1.0" standalone="nes" ?><root/>', 'Syntax Error in XML-Deklaration, "standalone" not "yes" or "no"' ],
        'xml_decl, missing ?>'                 => [ '<?xml version="1.0" ><root/>', 'Syntax error in XML-Declaration, missing "?>"' ],
        'xml_decl, < ?xml'                     => [ '< ?xml version="1.0" ?><root/>', 'Syntax error in XML-Declaration, space between "<" and "?"' ],
        'xml_decl, <? xml'                     => [ '<? xml version="1.0" ?><root/>', 'Syntax error in XML-Declaration, space between "<?" and "xml"' ],
        'xml_decl, ? >'                        => [ '<?xml version="1.0" ? ><root/ >', 'Syntax error in XML-Declaration, space between "?" and ">"' ],

        'illegal attribute value, empty'       => [ '<root foo="<" />', 'Syntax error in Element "root", attribute contains illegal values' ],
        'illegal attribute value'              => [ '<root foo="<"></root>', 'Syntax error in Element "root", attribute contains illegal values' ],
        'illegal attribute name -foo'          => [ '<root -foo="" />', 'Syntax error in Element "root", malformed or missing attribute name' ],
        'illegal attribute name ö'             => [ '<root öfoo="" />', 'Syntax error in Element "root", malformed or missing attribute name' ],
};

my $parser;
lives_ok( { $parser = XML::Parser.new }, 'instance' );

my $t = '';

for %xml.kv -> $test, $args {

        if !$t || ( $t eq $test )
        {
                try { XML::Parser.new.parse( $args[0], 'dom', 1 ); }

                if $! && "$!" eq $args[1]
                {
                        ok(1, $test);
                }
                else
                {
                        ok(0, $test);
                        say "got: <{$!}>";
                        say "expected: <{$args[1]}>",
                }
        }
}


exit;
#
#
# # ok( $! && "$!" ~~ /Unknown \s ENTITY \s \( glt \)/, "unknown entities croak" );
# #
# # try { XML::Parser.new(parseDebug=>0).parse($xml) };
# # ok( $! && "$!" ~~ "Unknown namespace (xsi)", 'unknown namespace' );
