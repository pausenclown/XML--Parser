use XParser::Dom::Node;
use XParser::Dom::Attribute;
use XParser::Dom::Namespace;

class XParser::Dom::Tag is XParser::Dom::Node {
        has Str        $.name is rw = "";
        has Any        $.namespace is rw;
        has Any        @.children;
        has Any        @.attributes;
}