# use XML::Parser::Dom::Node;
# use XML::Parser::Dom::Attribute;

class XML::Parser::Dom::ProcessingInstruction is XML::Parser::Dom::Node {
        has Str $.name is rw = "";
        has XML::Parser::Dom::Attribute @.attributes;
}