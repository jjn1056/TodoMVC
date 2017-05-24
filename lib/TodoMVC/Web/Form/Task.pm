package TodoMVC::Web::Form::Task;

use Moo;
use Data::MuForm::Meta;
extends 'Data::MuForm';

has_field 'completed' => (
  type => 'Checkbox',
  required => 0 );

has_field 'title' => (
  type => 'Text',
  minlength => 3,
  maxlength => 40,
  required => 1 );

sub update_model {
  my $self = shift;
  my %values = %{$self->values};
  for($self->model) {
    $_->title($values{title});
    $_->completed($values{completed} ? 1 : 0);
    $_->insert_or_update;
  }
}

1;

