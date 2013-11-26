package HTTP::Proxy::InterceptorX::Plugin::ImageInverter;

=head2

When used, this plugin will make every image appear upside down.

=cut 

use Moose::Role;
use GD::Image;
use Data::Printer;
use 5.008_005;
our $VERSION = '0.01';

sub ImageInverter {
  my ( $self, $args ) = @_; 
  return 0 if ! defined $self->http_request 
           or ! defined $self->http_request->uri 
           or           $self->http_request->uri->path !~ m/(png|gif|jpg|jpeg|bmp)$/;
  my $req   = HTTP::Request->new( $self->http_request->method => $self->http_request->uri->as_string );
  my $res   = $self->ua->request( $req );
  my $image = GD::Image->new( $res->content );
  return 0 if ! defined $image;
  $image    = $image->copyRotate180();
  $self->override_content( $image->gif() );
  return 0;
}

after 'BUILD' => sub {
    my ( $self ) = @_; 
    $self->append_plugin_method( "ImageInverter" );
};

1;
__END__

=encoding utf-8

=head1 NAME

HTTP::Proxy::InterceptorX::Plugin::ImageInverter - Inverts every image on the page

=head1 SYNOPSIS

    package My::Custom::Proxy;
    use Moose;
    extends qw/HTTP::Proxy::Interceptor/;
    with qw/
      HTTP::Proxy::InterceptorX::Plugin::ImageInverter
    /;
     
    1;

    my $p = My::Custom::Proxy->new(
      config_path => 'teste_config.pl', #dont really need this for this plugin
      port        => 9919,
    );

    $p->start ;
    1;

=head1 DESCRIPTION

HTTP::Proxy::InterceptorX::Plugin::ImageInverter is mainly a proof of concept that will invert every image on every site you access using this proxy.

=head1 CONFIG

Doesnt need a config file since it will invert all the images if finds.

=head1 AUTHOR

Hernan Lopes E<lt>hernan@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2013- Hernan Lopes

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
