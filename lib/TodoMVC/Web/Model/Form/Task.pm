package TodoMVC::Web::Model::Form::Task;

use Moo;
use Module::Runtime;
extends 'Catalyst::Model';

has _args => (
  is=>'ro',
  required=>1);

has form => (
  is=>'ro',
  required=>1);

sub COMPONENT {
  my ($class, $app, $args) = @_;
  my $merged_args = $class->merge_config_hashes($class->config, $args);
  my $form = Module::Runtime::use_module($args->{form_class})->new($merged_args);
  return $class->new(_args=>$merged_args, form=>$form);
}

# If its a POST we grab params automagically
my $prepare_post_params = sub {
  my ($self, $c, %process_args) = @_;
  if(
    ($c->req->method=~m/post/i)
    and (not exists($process_args{params}))
  ) {
    $process_args{params} = $c->req->body_data;
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
