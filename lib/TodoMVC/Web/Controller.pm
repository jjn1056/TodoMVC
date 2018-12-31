package TodoMVC::Web::Controller::Base;

use Moose;
use MooseX::MethodAttributes;

extends 'Catalyst::Controller';
with 'Catalyst::ControllerRole::At';
  
package TodoMVC::Web::Controller;

use strict;
use warnings;

use Import::Into;
use Module::Runtime;

sub base_class { 'TodoMVC::Web::Controller::Base' }

sub importables {
  return (
    'utf8',
    'namespace::autoclean',
    ['base', shift->base_class],
    ['feature', ':5.10'],
    ['experimental', 'signatures'],
  );
}

sub import {
  foreach my $import_proto(shift->importables) {
    my ($module, @args) = (ref($import_proto)||'') eq 'ARRAY' ? 
      @$import_proto : ($import_proto, ());
    Module::Runtime::use_module($module)
      ->import::into(scalar(caller), @args)
  }
}

1;

