package TodoMVC::Web::Controller::Root;

use Moose;
use MooseX::MethodAttributes;

extends 'Catalyst::Controller';
with 'Catalyst::ControllerRole::At';

sub root : At(/...) {  }

  sub summary :Via(root) At(?{?q}) {
    $_->view('Summary',
      set => $_{q}||'all',
      tasks => $_->model->filter_by($_{q}))
    ->http_ok;
  }

  sub add : POST Via(root) At() {
    my $form = $_->model('Form::Task', $_->model->empty);
    $form->is_valid ?
      $_->detach('summary') :
      $_->view('Task',
        title => $form->fif->{title},
        errors_by_name => $form->errors_by_name,
      )->http_bad_request;        
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
