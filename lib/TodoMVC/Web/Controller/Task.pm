package TodoMVC::Web::Controller::Task;

use TodoMVC::Web::Controller;

sub root : Via(/root) At(task/{id}/...) {
  my $model = $_->model->find($_{id}) ||
    $_->view('NotFound')->http_not_found->detach;
  $_->current_model_instance($model);
}

  sub update : POST Via(root) At() {
    my $form = $_->model('Form::Task', $_->model);
    $form->validated?
      $_->redirect_to_action('#summary') :
      $_->view('Task',
        title => $form->fif->{title},
        errors_by_name => $form->errors_by_name,
      )->http_bad_request;
  }

  sub delete : POST Via(root) At(delete) {
    $_->model->delete;
    $_->redirect_to_action('#summary');
  }

__PACKAGE__->meta->make_immutable;
