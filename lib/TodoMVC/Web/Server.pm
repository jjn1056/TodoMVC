use warnings;
use strict;

package TodoMVC::Web::Server;

use TodoMVC::Web;
use Plack::Runner;

sub run { Plack::Runner->run(@_, TodoMVC::Web->to_app) }

return caller(1) ? 1 : run(@ARGV);

=head1 NAME

TodoMVC::Web::Server - Start the application under a web server

=head1 DESCRIPTION

Start the web application.  Example:

    perl -Ilib  lib/TodoMVC/Web/Server.pm --server Gazelle

=head1 AUTHORS & COPYRIGHT

See L<TodoMVC>.

=head1 LICENSE

See L<TodoMVC>.

=cut
