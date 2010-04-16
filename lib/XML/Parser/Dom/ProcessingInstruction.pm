class XML::Parser::Dom::ProcessingInstruction
is    XML::Parser::Dom::Node
{
    has Str $.target is rw;
    has Str $.data   is rw;

    method xml {
        "<?{self.target} {self.data}?>";
    }

    method path {
        join( '/', self.parent_node.path, "#processing_instruction:{self.target}" );
    }
}


