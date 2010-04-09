class XML::Parser {
    has XML::Parser::Actions::Base $.action   is rw;
    has XML::Parser::Dom::Document $.document is rw;
    has XML::Parser::Dom::Node     $.context  is rw;
    has Any                        $.handlers;

    has Any                        @.stack is rw;

    method new_action (Str $action, Any $action_arg ) {
        given $action {
                when 'dom'      { self.action = XML::Parser::Actions::Dom.new( parser=>self ) }
                when 'test'     { self.action = XML::Parser::Actions::Test.new( parser=>self ) }
                when 'debug'    { self.action = XML::Parser::Actions::Debug.new( parser=>self ) }
                when 'handlers' { self.action = XML::Parser::Actions::Handlers.new( parser=>self ) }
        }
        return self.action || die "Unknown XML::Parser::Action";
    }

    method parse (Str $xml, Str $action = 'dom', Any $action_arg?)
    {
        my $parse;

        try {
                $parse = XML::Parser::Grammar.parse( $xml, actions => self.new_action( $action, $action_arg ) );
        }

        my $error   = $! ?? "$!" !! "";
        my $handled = '';

        if $error
        {
            $handled = $error.substr(0,1) eq '!';

            # $error   = $error.subst('<candidate>', self.action.lastCandidate);
            $error   = $error.subst(/^\!/, '');

            die $error
                    if $handled;

            die "Syntax error in  ( $! )"; # { self.action.lastCandidate }
        }

        return $parse;
    }
}
