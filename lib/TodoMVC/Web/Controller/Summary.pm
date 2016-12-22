package TodoMVC::Web::Controller::Summary;

use Moose;
use MooseX::MethodAttributes;

extends 'Catalyst::Controller';
with 'Catalyst::ControllerRole::At';

sub root : Via(/root) At(...) {  }

  sub clear_completed : POST Via(root) At(clear_completed) {
    $_->model->completed->delete_all;
    $_->redirect_to($_[0]->action_for('view'));
  }

  sub prepare_view :Via(root) At(...?{?q}) {
    return $_->view('Summary',
      tasks => $_->model->filter_by($_{q}),
      set => $_{q});
  }
  
    sub view : GET Via(prepare_view) At() {
      $_->view->http_ok;
    }

    sub add : POST Via(prepare_view) At() {
      my $form = $_->model('Form::Task',
        $_->model->new_result(+{}));
      $form->is_valid ?
        $_->view->http_ok :
        $_->view->apply_errors($form)
          ->http_bad_request;
    }


__PACKAGE__->meta->make_immutable;
