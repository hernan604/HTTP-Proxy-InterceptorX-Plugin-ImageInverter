package My::Proxy;
use Moose;
extends qw/HTTP::Proxy::Interceptor/;
with qw/
  HTTP::Proxy::InterceptorX::Plugin::ImageInverter
/;


my $proxy = My::Proxy->new();
My::Proxy->run(  port => $proxy->porta );
