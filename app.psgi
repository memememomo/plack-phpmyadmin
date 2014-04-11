use Plack::App::CGIBin;
use Plack::App::PHPCGI;
use Plack::Builder;
use File::Zglob;

my $PHPMYADMIN = '';

my $static = Plack::App::File->new(root => $PHPMYADMIN)->to_app;

my @php;
for my $php ( zglob("$PHPMYADMIN/*.php") ) {
    my $mount = $php;
    $mount =~ s!^$PHPMYADMIN!/phpmyadmin!;
    my $app = Plack::App::PHPCGI->new(
        script => $php,
        php_cgi => '/usr/local/bin/php-cgi',
    )->to_app;
    push @php, [$mount,$app];
}

for my $php ( zglob("$PHPMYADMIN/**/*.php") ) {
    my $mount = $php;
    $mount =~ s!^$PHPMYADMIN!/phpmyadmin!;
    my $app = Plack::App::PHPCGI->new(
        script => $php,
        php_cgi => '/usr/local/bin/php-cgi',
    )->to_app;
    push @php, [$mount,$app];
}

builder {
    enable 'ReverseProxy';
    enable sub {
        my $apps = shift;
        sub {
            my $env = shift;
            return [302,[Location=>'http://'.$env->{HTTP_HOST}.'/phpmyadmin/'],['moved']] if $env->{PATH_INFO} eq '/';
            $env->{REMOTE_USER} = 'phpmyadmin';
            $env->{PATH_INFO} .= 'index.php'
                if $env->{PATH_INFO} =~ m!^/phpmyadmin/([^\.]+/)*$!;
            $apps->($env);
        };
    };
    for my $php ( @php ) {
        mount $php->[0], $php->[1];
    }
    mount '/phpmyadmin' => $static,
}
