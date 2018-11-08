package TodoMVC::Web::Controller::Static;

use Moose;
extends 'Catalyst::Controller::Public';

__PACKAGE__->meta->make_immutable;
__PACKAGE__->config(chain_base_action=>'/root')
