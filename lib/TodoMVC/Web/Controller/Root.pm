package TodoMVC::Web::Controller::Root;

use Moose;
use MooseX::MethodAttributes;

extends 'Catalyst::Controller';
with 'Catalyst::ControllerRole::At';

sub root : At(/...) {  }

sub default :Default {
  my ($self, $c, @args) = @_;
  $c->view('NotFound')->http_404;
}

__PACKAGE__->meta->make_immutable;
