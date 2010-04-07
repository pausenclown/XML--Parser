use XParser::Dom::Node;
use XParser::Dom::Attribute;

class XParser::Dom::ProcessingInstruction is XParser::Dom::Node {
        has Str $.name is rw = "";
        has XParser::Dom::Attribute @.attributes;
}