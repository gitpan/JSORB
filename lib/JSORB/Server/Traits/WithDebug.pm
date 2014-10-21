package JSORB::Server::Traits::WithDebug;
use Moose::Role;

use Text::SimpleTable;
use JSON ();

our $VERSION   = '0.02';
our $AUTHORITY = 'cpan:STEVAN';

around 'build_handler' => sub {
    my $next    = shift;
    my $self    = shift;
    my $handler = $self->$next(@_);
    return sub {
        my $request = shift;
    
        my $t = Text::SimpleTable->new(15, 55);
        $t->row('Request', $request->request_uri);        
        $t->row('Method',  $request->method);                
        
        my $t2 = Text::SimpleTable->new([ 15, 'Parameter' ], [ 55, 'Value' ]);        
        $t2->row($_, $request->param($_)) for sort $request->param;        
        
        warn $t->draw, "\n", $t2->draw, "\n";
        
        my $response = $handler->($request);
        
        my $t3 = Text::SimpleTable->new(15, 55);        
        $t3->row(
            'Response' => JSON->new->pretty(1)->encode(
                JSON->new->decode(
                    $response->body
                )
            )
        );
        
        warn $t3->draw, "\n";
        
        return $response;
    }
};

no Moose::Role; 1;

__END__

=pod

=head1 NAME

JSORB::Server::Traits::WithDebug - A debugging trait for JSORB::Server::Simple

=head1 SYNOPSIS

  JSORB::Server::Simple->new_with_traits(
      traits     => [ 'JSORB::Server::Traits::WithDebug' ],
      dispatcher => JSORB::Dispatcher::Path->new(
          namespace => $ns,
      )
  )->run;

=head1 DESCRIPTION

This is a trait meant to be used with L<JSORB::Server::Simple> 
to aid in debugging. It basically prints out nicely formatted
ASCII tables to STDERR.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no 
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 AUTHOR

Stevan Little E<lt>stevan.little@iinteractive.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2008-2009 Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
