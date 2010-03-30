class XML::Parser {

        has Any $.action is rw;

        method new_action (Str $action, Any $action_arg ) {
                given $action {
                        when 'test' { self.action = XML::Parser::Action::Test.new( debug => $action_arg ) }
                }
                return self.action;
        }

        method parse (Str $xml, Str $action = 'dom', Any $action_arg?)
        {
                my $parse;

                try {
                        $parse = XML::Parser::Grammar.parse( $xml, actions => self.new_action( $action, $action_arg ) );
                }

                my $error = $! ?? "$!" !! "";
                my $handled = '';

                if $error
                {
                        $handled = $error.substr(0,1) eq '!';

                        $error   = $error.subst('<candidate>', self.action.lastCandidate);
                        $error   = $error.subst(/^\!/, '');

                        die $error
                                if $handled;

                        die "Syntax error in { self.action.lastCandidate } ( $! )"
                }

                return $parse;
        }

        method parsefile (Str $file, Str $action = 'dom', Any $action_arg?)
        {
                # say $file;
                my $parse = XML::Parser::Grammar.parsefile( $file, actions => self.new_action( $action, $action_arg ) );

                die "Syntax error after " ~ self.action.lastFound
                        unless $parse;

                return $parse;
        }
}
