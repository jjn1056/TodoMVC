package TodoMVC::Web::Controller::Task;

use Moose;
use MooseX::MethodAttributes;

extends 'Catalyst::Controller';

sub root :Chained(/root) PathPart('task') CaptureArgs(1) {
  my ($self, $c, $id) = @_;
  my $model = $c->model("Schema::Todo")->find($id) ||
    $c->view('NotFound')->detach;
  $c->current_model_instance($model);
}

  sub update :POST Chained(root) PathPart('') Args(0) {
    my ($self, $c) = @_;
    my $form = $c->model('Form::Task', $c->model);
    $form->is_valid ?
      $c->redirect_to($c->controller('Root')->action_for('view')) :
      $c->view('BadRequest');
  }

  sub delete :POST Chained(root)  Args(0) {
    my ($self, $c) = @_;
    $c->model->delete;
    $c->redirect_to($c->controller('Root')->action_for('view'));
  }

__PACKAGE__->meta->make_immutable;
