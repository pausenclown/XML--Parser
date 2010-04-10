use Test;
use XML::Parser;

class Handler
{
    has Any @.books   is rw;
    has Str $.context is rw;

    method book( @attr ) {
        self.books.push( hash( category => @attr ?? @attr[0].value !! 'unknown' ) );
    }

    method text( XML::Parser::Dom::Text $text, XML::Parser::Dom::Element $context ) {
        self.books[*-1]{$context.name} = $text.data;
    }
}

my $parser;
my $handlers = Handler.new;

lives_ok( { $parser = XML::Parser.new( handlers => $handlers ) }, 'instance' );

my $t = '<!-- from http://www.w3schools.com/dom/books.xml -->
<bookstore>
<book category="cooking">
<title lang="en">Everyday Italian</title>
<author>Giada De Laurentiis</author>
<year>2005</year>
<price>30.00</price>
</book>
<book category="children">
<title lang="en">Harry Potter</title>
<author>J K. Rowling</author>
<year>2005</year>
<price>29.99</price>
</book>
<book category="web">
<title lang="en">XQuery Kick Start</title>
<author>James McGovern</author>
<year>2003</year>
<price>49.99</price>
</book>
<book category="web" cover="paperback">
<title lang="en">Learning XML</title>
<author>Erik T. Ray</author>
<year>2003</year>
<price>39.95</price>
</book>
</bookstore>';

$parser.parse( $t, 'handlers' );

ok( $handlers.books.elems == 4, 'books' );
ok( $handlers.books[0]<category> eq 'cooking', 'category' );
ok( $handlers.books[1]<title>    eq 'Harry Potter', 'title' );
ok( $handlers.books[2]<author>   eq 'James McGovern', 'author' );
ok( $handlers.books[3]<price>    eq '39.95', 'price' );
