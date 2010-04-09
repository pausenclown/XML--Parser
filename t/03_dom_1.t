use Test;
use XML::Parser;

my $parser;
lives_ok( { $parser = XML::Parser.new }, 'instance' );

my $t = '<?xml version="1.1" encoding="ISO-8859-1"?>
<root a="b">
<tag></tag>
<tag_with_pi><?eclipse foox?></tag_with_pi>
<nested_tag><inner_tag i="t" /></nested_tag>
<tag_with_text>some bla</tag_with_text>
<tag_with_attr foo="bar" x=\'y\'/>
<!-- comment -->
<![CDATA[ <!&!> ]]>
More Text
</root>
';

my $expect = '<?xml version="1.1" encoding="ISO-8859-1" standalone="yes"?>
<root a="b"><tag /><tag_with_pi><?eclipse foox?></tag_with_pi><nested_tag><inner_tag i="t" /></nested_tag><tag_with_text>some bla</tag_with_text><tag_with_attr foo="bar" x="y" /><!-- comment --><![CDATA[ <!&!> ]]>More Text</root>';

$parser.parse( $t, 'dom' );

isa_ok( $parser.document, XML::Parser::Dom::Document );
ok( $parser.document.version == '1.1', 'decl. version' );
ok( $parser.document.encoding == 'ISO-8859-1', 'decl. encoding' );
ok( $parser.document.standalone == 'yes', 'decl. standalone' );
ok( $parser.document.xml eq $expect, 'toxml');
ok( "{ $parser.document }" eq $parser.document.xml, 'stringification');
ok( $parser.document.child_nodes[0], "very first child exists" );
isa_ok( $parser.document.child_nodes[0], XML::Parser::Dom::Element );
ok( $parser.document.child_nodes[0].name eq 'root', "vfc name set" );
ok( $parser.document.first_child.name eq 'root', "first_child works" );
ok( $parser.document.root.name eq 'root', "root works" );
ok( $parser.document.root.child_nodes.elems == 8, "vfc children there" );
isa_ok( $parser.document.root.parent_node, XML::Parser::Dom::Document );
isa_ok( $parser.document.root.owner_document, XML::Parser::Dom::Document );
isa_ok( $parser.document.root.child_nodes[0], XML::Parser::Dom::Element );
isa_ok( $parser.document.root.child_nodes[1].first_child, XML::Parser::Dom::ProcessingInstruction );
ok( $parser.document.root.child_nodes[1].first_child.target eq 'eclipse', 'pi target' );
ok( $parser.document.root.child_nodes[1].first_child.path eq '/root/tag_with_pi/#processing_instruction', 'path ok');
ok( $parser.document.root.child_nodes[1].first_child.data eq 'foox', 'pi data' );

ok( $parser.document.root.child_nodes[2].name eq 'nested_tag', 'found nested_tag' );
ok( $parser.document.root.child_nodes[2].previous_sibling.name eq 'tag_with_pi', 'found prev sibling' );
ok( $parser.document.root.child_nodes[2].next_sibling.name eq 'tag_with_text', 'found next sibling' );
ok( $parser.document.root.child_nodes[3].node_type eq 'Element', "node type element" );
ok( $parser.document.root.child_nodes[3].first_child.node_type eq 'Text', "node type text" );
ok( $parser.document.root.child_nodes[3].first_child.data eq 'some bla', "text content" );
ok( $parser.document.text eq 'some bla More Text', "text content" );
ok( $parser.document.root.child_nodes[4].node_type eq 'Element', "node type element" );
ok( $parser.document.root.child_nodes[4].name eq 'tag_with_attr', "node name tag_with_attr" );
ok( $parser.document.root.child_nodes[4].attributes.elems == 2, "no. of attr" );
ok( $parser.document.root.child_nodes[4].attributes[1].name eq 'x', "attr name" );
ok( $parser.document.root.child_nodes[4].attributes[1].value eq 'y', "attr value" );
ok( $parser.document.root.child_nodes[5].node_type eq 'Comment', "node type comment" );
ok( $parser.document.root.child_nodes[5].data eq ' comment ', "comment data" );

say "Expect\n$expect";
say "Got\n{$parser.document}";
