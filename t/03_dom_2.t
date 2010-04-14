use Test;
use XML::Parser;

my $parser;
lives_ok( { $parser = XML::Parser.new }, 'instance' );
my $t = '<!-- from http://www.w3schools.com/dom/books.xml -->
<!DOCTYPE bookstore [
    <!ENTITY gdl "Giada De Laurentiis">
    <!ENTITY copyright "&#169;">
    <!ENTITY copyright2 "&#xA9;">
    <!ENTITY myamp "&amp;">
    <!ENTITY copyright08 "&copyright; 2008">
]>
<bookstore>
<book category="cooking">
<title lang="en">Everyday Italian</title>
<author>&gdl;</author>
<year>2005</year>
<price>30.00</price>
</book>
<book category="children">
<title lang="en">Harry Potter</title>
<author>&copyright; J K. Rowling</author>
<year>2005</year>
<price>29.99</price>
</book>
<book category="web">
<title lang="en">XQuery Kick Start</title>
<author>James McGovern</author>
<author>Per Bothner</author>
<author>Kurt Cagle</author>
<author>James Linn</author>
<author>Vaidyanathan Nagarajan</author>
<year>2003</year>
<price>49.99</price>
</book>
<book category="web" cover="paperback">
<title lang="en">Learning XML &myamp; XSL</title>
<author>Erik T. Ray</author>
<year>2003</year>
<price>39.95</price>
</book>
</bookstore>';

my $expect = '<?xml version="1.1" encoding="ISO-8859-1" standalone="yes"?>
<root a="b"><tag /><tag_with_pi><?eclipse foox?></tag_with_pi><nested_tag><inner_tag i="t" /></nested_tag><tag_with_text>some bla</tag_with_text><tag_with_attr foo="bar" x="y" /><!-- comment --><![CDATA[ <!&!> ]]>More Text</root>';

$parser.parse( $t, 'dom' );

isa_ok( $parser.document, XML::Parser::Dom::Document );
isa_ok( $parser.document.doctype, XML::Parser::Dom::DocumentType );


ok( $parser.document.doctype.entities );

ok( $parser.document.doctype.entities<lt> );
ok( $parser.document.doctype.entities<gt> );
ok( $parser.document.doctype.entities<amp> );
ok( $parser.document.doctype.entities<apos> );
ok( $parser.document.doctype.entities<quot> );

ok( $parser.document.doctype.entities<gdl> );
ok( $parser.document.doctype.entities<gdl>.name eq 'gdl' );
ok( $parser.document.doctype.entities<gdl>.definition eq 'Giada De Laurentiis' );
ok( $parser.document.doctype.entities<gdl>.parse      eq 'Giada De Laurentiis' );

ok( $parser.document.doctype.entities<copyright> );
ok( $parser.document.doctype.entities<copyright>.name eq 'copyright' );
ok( $parser.document.doctype.entities<copyright>.definition eq '&#169;' );
ok( $parser.document.doctype.entities<copyright>.parse      eq '©' );

ok( $parser.document.doctype.entities<myamp> );
ok( $parser.document.doctype.entities<myamp>.name eq 'myamp' );
ok( $parser.document.doctype.entities<myamp>.definition eq '&amp;' );
ok( $parser.document.doctype.entities<myamp>.parse      eq '&' );

ok( $parser.document.doctype.entities<copyright>.parse eq $parser.document.doctype.entities<copyright2>.parse );
ok( $parser.document.doctype.entities<copyright08>.parse eq '© 2008' );
say $parser.document.doctype.entities<copyright08>.parse;