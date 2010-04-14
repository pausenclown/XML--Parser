class XML::Parser::Dom::Entity {
    has Str $.name           is rw;
    has Str $.definition     is rw;
    has Str $.system_literal is rw;
    has Str $.pub_id_literal is rw;
    has Str $.ndata_name     is rw;

    has XML::Parser::Dom::DocumentType $.doctype is rw;

    method parse( Str $def is copy = "{ self.definition }" ) {
        my $again;

        $def = $def.subst( / \& \# ( \d+ ) \; /,
            -> $m { chr( $m[0].Str ) } );

        $def = $def.subst( / \& \# x ( <[ 0..9 A..F a..f ]>+ ) \; /,
            -> $m { chr( :10( '0x' ~ $m[0].Str ) ) } );

        $def = $def.subst( / \& ( <[ \: A..Z a..z \_ ]> <[ \: A..Z a..z \_ \- \. \d ]>+ ) \; /,
            -> $m { $again = 1; self.doctype.entities{$m[0]}.definition } );

        $again ?? self.parse( $def ) !! $def;
    }
}
