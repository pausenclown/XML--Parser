class XML::Parser::Dom::Entity { ... }

class XML::Parser::Dom::DocumentType {
    has Str $.name  is rw;
    has Str $.descr is rw;
    has Str $.url   is rw;
    has %.entities  is rw;

    has XML::Parser::Dom::Document $.ownerDocument is rw;

    multi method add_entity( *%args )
    {
        self.add_entity( XML::Parser::Dom::Entity.new( |%args ) );
    }

    multi method add_entity( XML::Parser::Dom::Entity $entity )
    {
        self.entities{ $entity.name } = $entity;
        $entity.doctype = self;
    }
}

