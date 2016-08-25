package TodoMVC::Web::Controller::Task;

use Moose;
use MooseX::MethodAttributes;

extends 'Catalyst::Controller';

sub root :Chained(/root) PathPart('task') CaptureArgs(1) {
  my ($self, $c, $id) = @_;
  my $model = $c->model("Schema::Game::Result") || die "$id not found";
  $c->current_model_instance($model);
}

  sub update :POST Chained(root) PathPart('') Args(0) {
    my ($self, $c) = @_;
    my $form = $c->model('Form::Task', $c->model);
    $form->is_valid ?
      $c->redirect_to('/summary') :
      die "Invalid Form!";
  }

__PACKAGE__->meta->make_immutable;
