use Test;
use XML::Parser;

my %xml =
    'minimal'                          => [ '<test></test>' ],
    'minimal'                          => [ '<test/>' ],
    'minimal with ws 1'                => [ '<test ></test>' ],
    'minimal with ws 2'                => [ '<test></test >' ],
    'minimal with ws 3'                => [ '<test />' ],
    'minimal with attributes'          => [ '<test foo="bar" x="y"></test>' ],
    'minimal with attributes/entities' => [ '<test foo="&amp;" x="&#123;"></test>' ],
    'minimal nested nodes'             => [ '<simple><nested></nested></simple>' ],
    'nested nodes w. attributes'       => [ '<simple><nested><nodes with="attributes"></nodes></nested></simple>' ],
    'minimal nested nodes w. empty'    => [ '<simple><nested/></simple>' ],
    'minimal nested nodes w. empty'    => [ '<sim><ple><nested/></ple></sim>' ],
    'simple texnode'                   => [ '<textnode>TEXT</textnode>' ],
    'texnode with entitites'           => [ '<textnode>&amp;&#123;</textnode>' ],
    'texnode with text & entitites'    => [ '<textnode>TEXT&amp;TEXT&#123;TEXT</textnode>' ],
    'pre root comment'                 => [ '<!-- comment --><root/>' ],
    'in tag comment'                   => [ '<root><!-- comment --></root>' ],
    'cdata node'                       => [ '<root><![CDATA[<>]]></root>' ],
    'xml_decl minimal'                 => [ '<?xml version="1.0"?><root/>' ],
    'xml_decl w. attributes'           => [ '<?xml version="1.0" encoding="UTF-16" standalone="no"?><root/>' ],
    'minimal doctype'                  => [ '<!DOCTYPE Capability SYSTEM "obex-capability.dtd"><root/>' ],
    'simple doctype'                   => [ '<!DOCTYPE catalog PUBLIC "-//OASIS//DTD Entity Resolution XML Catalog V1.0//EN" "http://www.oasis-open.org/committees/entity/release/1.0/catalog.dtd"><root/>' ],
    'doctype'                          => [ '<!DOCTYPE doctype [ <!ENTITY lbracket "&#91;"> ]> <doctype>&lbracket;</doctype>' ],
    'doctype 2'                        => [ '<?xml version="1.0"?><!DOCTYPE greeting SYSTEM "hello.dtd"><greeting>Hello, world!</greeting>' ],
    'element decl 1'                   => [ '<!DOCTYPE greeting [ <!ELEMENT greeting (#PCDATA)> ]> <greeting>Hello, world!</greeting>' ],
    'element decl 2'                   => [ '<!DOCTYPE greeting [ <!ELEMENT br EMPTY> ]> <greeting>Hello, world!</greeting>' ],
    'element decl 3'                   => [ '<!DOCTYPE greeting [ <!ELEMENT p (#PCDATA|emph)* > ]> <greeting>Hello, world!</greeting>' ],
    'element decl 5'                   => [ '<!DOCTYPE greeting [ <!ELEMENT container ANY> ]> <greeting>Hello, world!</greeting>' ],
    'element decl x'                   => [ '<!DOCTYPE greeting [ ]> <greeting>Hello, world!</greeting>' ],
    'attlist 1'                        => [ "<!DOCTYPE root [ <!ATTLIST poem  xml:space (default|preserve) 'preserve'> ]><root/>" ],
    'attlist 2'                        => [ "<!DOCTYPE root [ <!ATTLIST pre xml:space (preserve) #FIXED 'preserve'> ]><root/>" ],
    'attlist 3'                        => [ "<!DOCTYPE root [ <!ATTLIST termdef id ID #REQUIRED name CDATA #IMPLIED> ]><root/>" ],
    'attlist 4'                        => [ '<!DOCTYPE root [ <!ATTLIST list type (bullets|ordered|glossary) "ordered"> ]><root/>' ],
    'attlist 5'                        => [ '<!DOCTYPE root [ <!ATTLIST form method CDATA #FIXED "POST"> ]><root/>' ],
    'entity 1'                         => [ '<!DOCTYPE root [ <!ENTITY d "&#xD;">  ]><root/>' ],
    'entity 2'                         => [ "<!DOCTYPE root [ <!ENTITY % draft 'INCLUDE' > ]><root/>" ],
    'entity 3'                         => [ "<!DOCTYPE root [ <!ENTITY % final 'IGNORE' > ]><root/>" ],
    'entity 4'                         => [ '<!DOCTYPE root [ <!ENTITY % ISOLat2 SYSTEM "http://www.xml.com/iso/isolat2-xml.entities" > ]><root/>' ],
    'entity 5'                         => [ '<!DOCTYPE root [ <!ENTITY Pub-Status "This is a pre-release of the specification."> ]><root/>' ],
    'entity 6'                         => [ '<!DOCTYPE root [ <!ENTITY open-hatch SYSTEM "http://www.textuality.com/boilerplate/OpenHatch.xml"> ]><root/>' ],
    'entity 7'                         => [ '<!DOCTYPE root [ <!ENTITY open-hatch PUBLIC "-//Textuality//TEXT Standard open-hatch boilerplate//EN" "http://www.textuality.com/boilerplate/OpenHatch.xml"> ]><root/>' ],
    'entity 8'                         => [ '<!DOCTYPE root [ <!ENTITY hatch-pic SYSTEM "../grafix/OpenHatch.gif" NDATA gif> ]><root/>' ],

    # <!ENTITY % YN '"Yes"' > <!ENTITY WhatHeSaid "He said %YN;" >
    # while this is not:

    # croak
    # <!ENTITY EndAttr "27'" > <element attribute='a-&EndAttr;>

    'xml:lang'                        => [ '<!DOCTYPE p [ <!ATTLIST poem   xml:lang CDATA "fr"> ]> <p xml:lang="en">The quick brown fox jumps over the lazy dog.</p>' ],
    'name 1'                          => [ '<root _xfoo="name"/>' ],
    'name 2'                          => [ '<root f-oo="name"/>' ],
    'name 3'                          => [ '<root f1oo="name"/>' ],
    'unicode textnode'                => [ '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><root>ö</root>' ],
    # 'element decl 4'                  => [ '<!DOCTYPE greeting [ <!ELEMENT %name.para; %content.para; > ]> <greeting>Hello, world!</greeting>' ],
    'element decl 6'                  => [ '<!DOCTYPE greeting [ <!ELEMENT spec (front, body, back?)> ]> <greeting>Hello, world!</greeting>' ],
    'element decl 7'                  => [ '<!DOCTYPE greeting [ <!ELEMENT div1 (head, (p | list | note)*, div2*)> ]> <greeting>Hello, world!</greeting>' ],
    'element decl 8'                  => [ '<!DOCTYPE greeting [ <!ELEMENT p (#PCDATA|a|ul|b|i|em)*> ]> <greeting>Hello, world!</greeting>' ],
    'element decl 9'                  => [ '<!DOCTYPE greeting [ <!ELEMENT p (#PCDATA | %font; | %phrase; | %special; | %form;)* > ]> <greeting>Hello, world!</greeting>' ],
    'element decl 10'                 => [ '<!DOCTYPE greeting [ <!ELEMENT dictionary-body (%div.mix; | %dict.mix;)*> ]> <greeting>Hello, world!</greeting>' ],
;


my $parser;
lives_ok( { $parser = XML::Parser.new }, 'instance' );

my $t = '';

for %xml.kv -> $test, @xml {
    if !$t || ( $t eq $test )
    {
        try {
            ok( $parser.parse( @xml[0], 'dom', 0 ), $test );
        }
        if $! {
            ok( 0, "$test - Unexpected error: $!" );
        }
    }
}