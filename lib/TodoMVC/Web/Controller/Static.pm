package TodoMVC::Web::Controller::Static;

use Moose;
use MooseX::MethodAttributes;

extends 'Catalyst::Controller';

sub static :Chained(/root) Args Does(Public) At(/:actionname/*) {  }

__PACKAGE__->meta->make_immutable;
