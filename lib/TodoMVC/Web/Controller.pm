package TodoMVC::Web::Controller::Base;

use Moose;
use MooseX::MethodAttributes;

extends 'Catalyst::Controller';
with 'Catalyst::ControllerRole::At';
  
package TodoMVC::Web::Controller;

use strict;
use warnings;

use Moose::Exporter;
use Import::Into;
use Module::Runtime;

my ($import, $unimport, $init_meta) =
  Moose::Exporter->build_import_methods( also => ['Moose'] );

sub importables {
  'namespace::autoclean',
}

sub base_class { 'TodoMVC::Web::Controller::Base' }

sub init_meta {
  my ($class, @args) = @_;
  Moose->init_meta( @args,
    base_class => $class->base_class );
  goto $init_meta if $init_meta;
}

sub import {
  Module::Runtime::use_module($_)
    ->import::into(scalar caller)
      for shift->importables;
  goto $import;
}

1;

