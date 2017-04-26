package TodoMVC::Web::Controller::Task;

use Moose;
use MooseX::MethodAttributes;

extends 'Catalyst::Controller';
with 'Catalyst::ControllerRole::At';

sub root : Via(/root) At(task/{id}/...) {
  my $model = $_->model->find($_{id}) ||
    $_->view('NotFound')->http_not_found->detach;
  $_->current_model_instance($model);
}

  sub update : POST Via(root) At() {
    my $form = $_->model('Form::Task', $_->model);
    $form->is_valid ?
      $_->redirect_to($_[0]->action_for('../summary')) :
      $_->view('Task',
        title => $form->fif->{title},
        errors_by_name => $form->errors_by_name,
      )->http_bad_request;
  }

  sub delete : POST Via(root) At(delete) {
    $_->model->delete;
    $_->redirect_to($_[0]->action_for('../summary'));
  }

__PACKAGE__->meta->make_immutable;
