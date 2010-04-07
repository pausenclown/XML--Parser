use XParser::Dom::Node;

class XParser::Dom::Comment is XParser::Dom::Node {
        has Str $.text is rw;
}