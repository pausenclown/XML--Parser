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


