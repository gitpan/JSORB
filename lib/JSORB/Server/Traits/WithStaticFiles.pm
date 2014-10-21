package JSORB::Server::Traits::WithStaticFiles;
use Moose::Role;
use MooseX::Types::Path::Class;

our $VERSION   = '0.02';
our $AUTHORITY = 'cpan:STEVAN';

has 'doc_root' => (
    is       => 'ro',
    isa      => 'Path::Class::Dir',
    coerce   => 1,
    required => 1,
);

around 'build_handler' => sub {
    my $next    = shift;
    my $self    = shift;
    my $handler = $self->$next(@_);

    return sub {
        my $request = shift;
        
        # NOTE:
        # this is **extremely** niave, it simply 
        # tests for something that looks like a 
        # file by seeing if the path has a trailing 
        # extension, but even that is done poorly
        # so at some point this will need to be 
        # fixed to be more sane in some way.
        # - SL
        if ($request->path =~ /\.[a-zA-Z]+$/) {

            my $file = $self->doc_root->file($request->path);

            return return HTTP::Engine::Response->new(status => 404)
                unless -e $file;

            return HTTP::Engine::Response->new(
                status => 200,
                body   => $file->openr
            );
        }

        $handler->($request);
    }
};

no Moose::Role; 1;

__END__

=pod

=head1 NAME

JSORB::Server::Traits::WithStaticFiles - A JSORB::Server::Simple trait for static files

=head1 SYNOPSIS

  JSORB::Server::Simple->new_with_traits(
      traits     => [ 'JSORB::Server::Traits::WithStaticFiles' ],
      doc_root   => [ $FindBin::Bin, '..', '..' ],
      dispatcher => JSORB::Dispatcher::Path->new(
          namespace => $ns,
      )
  )->run;

=head1 DESCRIPTION

This is basically just a simple way to serve static files through
your simple JSORB server. Its detection of files is B<very> niave, 
you have been warned (patches welcome).

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
