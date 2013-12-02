## 

When used, this plugin will make every image appear upside down.

# NAME

HTTP::Proxy::InterceptorX::Plugin::ImageInverter - Inverts every image on the page

# SYNOPSIS

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

# DESCRIPTION

HTTP::Proxy::InterceptorX::Plugin::ImageInverter is mainly a proof of concept that will invert every image on every site you access using this proxy.

# CONFIG

Doesnt need a config file since it will invert all the images if finds.

# AUTHOR

Hernan Lopes <hernan@cpan.org>

# COPYRIGHT

Copyright 2013- Hernan Lopes

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO
