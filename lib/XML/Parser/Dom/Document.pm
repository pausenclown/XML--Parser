# use XML::Parser::Dom::Doctype;

class XML::Parser::Dom::Document {
        has Str                   $.declaration is rw;
        has XML::Parser::Dom::Doctype $.doctype is rw;
        has Any                   @.dom is rw;
        has Any                   @.namespaces;
}