package TestsConfig;
use Moose;
use File::Slurp;
use Path::Class;

has conteudos => (
    is      => 'ro',
    default => sub {
        return 
        {
            "/download.png" => {
                ref     => \&html_content,
                args    => {
                    content => {
                        original => sub {
                            my $image = read_file( file( "t","download.png" ) );
                            return $image;
                        }->()
                    }
                
                }
            }
        };
    }
); 

sub html_content {
    my ( $cgi, $url_path, $args ) = @_;
    return if !ref $cgi;
    print
        $cgi->header(),
        (   defined $args 
        and exists $args->{ content } 
        and exists $args->{ content }->{ original } )
        ? $args->{ content }->{ original } : ""
}


1;
