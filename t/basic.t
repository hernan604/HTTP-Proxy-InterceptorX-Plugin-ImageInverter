package My::Proxy;
use Test::More;
use Moose;
use lib './t';
use TestsConfig;
use TestServer;
use HTTP::Tiny;
use Data::Printer;
use Path::Class;
use GD::Image;
use File::Slurp;

extends qw/HTTP::Proxy::Interceptor/;
with qw/
    HTTP::Proxy::InterceptorX::Plugin::ImageInverter
/;

my $url_path;
my $proxy_port        = int(rand(9999))+50000;
my $tests_config      = TestsConfig->new();
my $server            = TestServer->new();
   $server->set_dispatch( $tests_config->conteudos );
my $pid_server        = $server->background();
#ok 1;

my $p   = My::Proxy->new( );
my $pid = fork_proxy( $p );

#User agents
my $ua       = HTTP::Tiny->new( );
my $ua_proxy = HTTP::Tiny->new( proxy => "http://127.0.0.1:$proxy_port" );


#  NORMAL REQUEST (WITHOUT PROXY)
my $res            = $ua->get( $server->root . "/google_logo.jpeg");
my $content_wanted = $tests_config->conteudos->{ '/google_logo.jpeg' }->{args}->{ content }->{ original };
ok( $res->{ content } eq $content_wanted , "Content is fine" );
#ok( $res->{ content } =~ /javascript/gi , "found javascript in the original string" );

#  REQUEST WITH PROXY (CONTENT WILL BE MODIFIED)
my $res_proxy      = $ua_proxy->get( $server->root . "/google_logo.jpeg");
#ok( $res_proxy->{ content } =~ /perl/ig , "found perl in the modified response" );
#ok( $res_proxy->{ content } !~ /javascript/ig , "did not find javascript in the modified response" );
my $image_original = read_file( file( qw/t google_logo.jpeg/ ) );
   $image_original = GD::Image->new( $image_original )->copyRotate180();
   $image_original = $image_original;

is( $res_proxy->{ content } , $image_original->gif() , "Content was inverted with success" );

#depois dos testes..
kill 'KILL', $pid, $pid_server;

sub fork_proxy {
    my $proxy = shift;
    my $pid = fork;
    die "Unable to fork proxy" if not defined $pid;
    if ( $pid == 0 ) {
        $0 .= " (proxy)";
        $proxy->run(  port => $proxy_port );
        exit 0;
    }
    return $pid;
}

done_testing;
