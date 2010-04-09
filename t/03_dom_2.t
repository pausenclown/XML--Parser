use Test;
use XML::Parser;

my $parser;
lives_ok( { $parser = XML::Parser.new }, 'instance' );
my $t = '<!-- from http://www.w3schools.com/dom/books.xml -->
<bookstore>
<book category="cooking">
<title lang="en">Everyday Italian</title>
<author>Giada De Laurentiis</author>
<year>2005</year>
<price>30.00</price>
</book>
<book category="children">
<title lang="en">Harry Potter</title>
<author>J K. Rowling</author>
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
<title lang="en">Learning XML</title>
<author>Erik T. Ray</author>
<year>2003</year>
<price>39.95</price>
</book>
</bookstore>';

my $expect = '<?xml version="1.1" encoding="ISO-8859-1" standalone="yes"?>
<root a="b"><tag /><tag_with_pi><?eclipse foox?></tag_with_pi><nested_tag><inner_tag i="t" /></nested_tag><tag_with_text>some bla</tag_with_text><tag_with_attr foo="bar" x="y" /><!-- comment --><![CDATA[ <!&!> ]]>More Text</root>';

$parser.parse( $t, 'dom' );

isa_ok( $parser.document, XML::Parser::Dom::Document );

