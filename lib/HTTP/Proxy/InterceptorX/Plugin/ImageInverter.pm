package HTTP::Proxy::InterceptorX::Plugin::ImageInverter;

=head2

When used, this plugin will make every image appear upside down.

=cut 

use Moose::Role;
use GD::Image;
use Data::Printer;
use 5.008_005;
our $VERSION = '0.01';

sub invert_image {
  my ( $self, $args ) = @_; 
  return 0 if ! defined $self->http_request 
           or ! defined $self->http_request->uri 
           or           $self->http_request->uri->as_string !~ m/(png|gif|jpg|jpeg|bmp)$/;
  my $req   = HTTP::Request->new( $self->http_request->method => $self->http_request->uri->as_string );
  my $res   = $self->ua->request( $req );
  my $image = GD::Image->new( $res->content );
  return 0 if ! defined $image;
  $image    = $image->copyRotate180();
  $self->content( $image->gif() );
  return 0;
}

after 'BUILD' => sub {
    my ( $self ) = @_; 
    $self->append_plugin_method( "invert_image" );
};

1;

1;
__END__

=encoding utf-8

=head1 NAME

HTTP::Proxy::InterceptorX::Plugin::ImageInverter - Blah blah blah

=head1 SYNOPSIS

  use HTTP::Proxy::InterceptorX::Plugin::ImageInverter;

=head1 DESCRIPTION

HTTP::Proxy::InterceptorX::Plugin::ImageInverter is

=head1 AUTHOR

Hernan Lopes E<lt>hernan@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2013- Hernan Lopes

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
