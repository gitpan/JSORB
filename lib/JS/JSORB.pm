package JS::JSORB;

use strict;
use warnings;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

1;

__END__

=pod

=head1 NAME

JS::JSORB - Javascript client for JSORB

=head1 SYNOPSIS

  var c = new JSORB.Client ({
      base_url : 'http://localhost:8080/',
  })
  
  c.call({
      method : '/math/simple/add',
      params : [ 2, 2 ]
  }, function (result) {
      alert(result)
  });

=head1 DESCRIPTION

This is basically the JS:: module for the JSORB Javascript client.
If you don't know about JS.pm, you should really check it out.

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
