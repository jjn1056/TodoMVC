package TodoMVC::Web::Controller::Task;

use Moose;
use MooseX::MethodAttributes;

extends 'Catalyst::Controller';
with 'Catalyst::ControllerRole::At';

sub root : Via(/root) At($affix/{id}/...) {
  my $model = $_->model("Schema::Todo")->find($_{id}) ||
    $_->view('NotFound')->http_not_found->detach;
  $_->current_model_instance($model);
}

  sub update : POST Via(root) At(/) {
    my $form = $_->model('Form::Task', $_->model);
    $form->is_valid ?
      $_->redirect_to($_->controller('Root')->action_for('view')) :
      $_->view('BadRequest');
  }

  sub delete : POST Via(root) At($name) {
    $_->model->delete;
    $_->redirect_to($_->controller('Root')->action_for('view'));
  }

__PACKAGE__->meta->make_immutable;
