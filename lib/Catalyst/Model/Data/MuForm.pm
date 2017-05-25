package Catalyst::Model::Data::MuForm;

use Moo;
use Module::Pluggable::Object;
use Template::Tiny;

extends 'Catalyst::Model';

has _application => (is => 'ro', required=>1);

has 'form_namespace' => (
  is=>'ro',
  required=>1,
  lazy=>1, 
  builder=>'_build_form_namespace');
 
  sub _default_form_namespace_part { 'Form' }
 
  sub _build_form_namespace {
    my $self = shift;
    warn $self->_application;
    return $self->_application .'::'. $self->_default_form_namespace_part;
  }
 
has 'form_packages' => (
  is=>'ro',
  required=>1,
  lazy=>1,
  builder=>'_build_form_packages');
 
  sub _build_form_packages {
    my $self = shift;
    my @forms = Module::Pluggable::Object->new(
      require => 1,
      search_path => [ $self->form_namespace ],
    )->plugins;
    return \@forms;
  }

has 'template_string' => (
  is=>'ro',
  required=>1,
  lazy=>1,
  builder=>'_build_template_string');

  sub _build_template_string { local $/; return <DATA> }

has 'template_processor' => (
  is=>'ro',
  required=>1,
  lazy=>1,
  builder=>'_build_template_processor');

  sub _build_template_processor { Template::Tiny->new(TRIM => 1) }

around 'BUILDARGS' => sub {
  my ($orig, $self, $app, @args) = @_;
  my $args = $self->$orig($app, @args);
  $args->{_application} = $app;
  return $args;
};

sub expand_modules {
  my ($self, $config) = @_;
  my @model_packages;
  foreach my $form_package (@{$self->form_packages}) {
    warn "doing $form_package";
    my $model_package = $self->construct_model_package($form_package);
    my $model_name = $self->construct_model_name($form_package);
    $self->build_model_adaptor($model_package, $form_package, $model_name);
    push @model_packages, $model_package;
  }
  return @model_packages;
}

sub construct_model_package {
  my ($self, $form_package) = @_;
  return $self->_application .'::Model'. ($form_package=~m/${\$self->_application}(::.+$)/)[0];
}
 
sub construct_model_name {
  my ($self, $form_package) = @_;
  return ($form_package=~m/${\$self->_application}::(.+$)/)[0];
}
 
sub build_model_adaptor {
  my ($self, $model_package, $form_package, $model_name) = @_;
  my $input = $self->template_string;
  my $output = '';
  $self->template_processor->process(
    \$input,
    +{
      model_package=>$model_package,
      form_package=>$form_package,
    },
    \$output );

  eval $output;
  die $@ if $@;
}

1;

__DATA__
package [% model_package %];

use Moo;
use Module::Runtime;
extends 'Catalyst::Model';

has _args => (
  is=>'ro',
  required=>1);

has body_method => (
  is=>'ro',
  required=>1,
  default=>'body_data');

has auto_process => (is=>'ro', required=>1, default=>1);

has form => (
  is=>'ro',
  required=>1);

sub COMPONENT {
  my ($class, $app, $args) = @_;
  my $merged_args = $class->merge_config_hashes($class->config, $args);
  my $form = Module::Runtime::use_module("[% form_package %]")->new($merged_args);
  return $class->new(_args=>$merged_args, form=>$form);
}

# If its a POST we grab params automagically
my $prepare_post_params = sub {
  my ($self, $c, %process_args) = @_;
  if(
    ($c->req->method=~m/post/i)
    and (not exists($process_args{params}))
    and (not $process_args{no_auto_process})
    and ($self->auto_process)
  ) {
    my $body_method = $self->body_method;
    $process_args{params} = $c->req->$body_method;
    $process_args{submitted} = 1 unless exists($process_args{submitted});
  }
  return %process_args;
};

# If there are odd args, that means the first one is either the
# model object or model_id
my $normalize_process_args = sub {
  my ($self, $c, %process_args) = (shift, shift, ());
  if(scalar(@_) % 2) {
    my $item_proto = shift;
    %process_args = @_;
    if(ref $item_proto) { # assume its blessed
      $process_args{model} = $item_proto;
    } else {
      $process_args{model_id} = $item_proto;
    }
  } else {
    %process_args = @_;
  }
  return $self->$prepare_post_params($c, %process_args);
};


sub ACCEPT_CONTEXT {
  my ($self, $c, @process_args) = @_;
  my %process_args = $self->$normalize_process_args($c, @process_args);  
  local $_; #WHY?
  $self->form->process(%process_args, ctx=>$c);
  return $self->form;
}

1;
