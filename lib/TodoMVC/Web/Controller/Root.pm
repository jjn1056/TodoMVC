package TodoMVC::Web::Controller::Root;

use TodoMVC::Web::Controller;

sub root : At(/...) {  }

  sub catchall : Via(root) At({*}) {
    $_->view('NotFound')->http_404;  
  }

  sub summary : Via(root) At(?{q=all}) Name(summary) {
    $_->view('Summary',
      set => $_{q},
      tasks => $_->model->filter_by($_{q}),
    )->http_ok;
  }

  sub add : POST Via(root) At() {
    my $form = $_->model('Form::Task',
      $_->model->new_todo);
    $form->validated ?
      $_->detach('summary') :
      $_->view('Task',
        title => $form->fif->{title},
        errors_by_name => $form->errors_by_name,
      )->http_bad_request;        
  }

  sub clear_completed : POST Via(root) At(clear_completed) ($self, $c) {
    $c->model->completed->delete_all;
    $c->redirect_to_action('#summary', +{q=>'all'});
  }

__PACKAGE__->meta->make_immutable;
