class XML::Parser {
    has XML::Parser::Actions::Base $.action   is rw;
    has XML::Parser::Dom::Document $.document is rw;
    has XML::Parser::Dom::Node     $.context  is rw;
    has Any                        $.handlers;

    has Any                        @.stack is rw;

    multi method parse (Str $xml, Str $action, Any $action_arg?)
    {
        self.parse( $xml, do given $action {
                when 'dom'      { XML::Parser::Actions::Dom.new( parser=>self ) }
                when 'test'     { XML::Parser::Actions::Test.new( parser=>self ) }
                when 'debug'    { XML::Parser::Actions::Debug.new( parser=>self ) }
                when 'handlers' { XML::Parser::Actions::Handlers.new( parser=>self ) }
                default         { die "Unknown XML::Parser::Action" }
        } );
    }

    multi method parse (Str $xml, XML::Parser::Actions $actions)
    {
        my $parse;
        # try {
                $parse = XML::Parser::Grammar.parse( $xml, actions => $actions );
        # }

        my $error   = $! ?? "$!" !! "";
        my $handled = '';

        if $error
        {
            $handled = $error.substr(0,1) eq '!';

            $error   = $error.subst('<candidate>', self.action.lastCandidate)
                if self.action.can('lastCandidate');

            $error   = $error.subst(/^\!/, '');

            die $error
                if $handled;

            die "Syntax error in  ( $! )"; # { self.action.lastCandidate }
        }

        return $parse;
    }
}
