package TodoMVC::Web::Controller::Root;

use Moose;
use MooseX::MethodAttributes;

extends 'Catalyst::Controller';
with 'Catalyst::ControllerRole::At';

sub root : At(/...) {  }

  sub summary : Via(root) At(...?{q=all}) {
    my $model = $_->model;
    if($_{q} eq 'completed') {
      $model = $model->completed;
    } elsif($_{q} eq 'active') {
      $model = $model->active;
    } 
    $_->view('Summary', tasks => $model, set => $_{q});
  }
    
    sub view : GET Via(summary) At() {
      $_->view('Summary')->http_ok;
    }

    sub add : POST Via(summary) At() {
      my $form = $_->model('Form::Task',
        $_->model->new_result(+{}));
      $form->is_valid ?
        $_->view('Summary')->http_ok :
        $_->view('Summary')->apply('InputErrors', $form)
          ->http_bad_request;
    }

  sub clear_completed : POST Via(root) At(clear_completed) {
    $_->model->completed->delete_all;
    $_->redirect_to($_[0]->action_for('view'));
  }

sub default :Default {
  my ($self, $c, @args) = @_;
  $c->view('NotFound')->http_404;
}

__PACKAGE__->meta->make_immutable;
