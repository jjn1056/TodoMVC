package TodoMVC::Web::Controller::Root;

use Moose;
use MooseX::MethodAttributes;

extends 'Catalyst::Controller';

sub root :Chained(/) PathPart('') CaptureArgs(0) {  }

  sub static :Chained(root) Does(Public) At(/:actionname/*) {  }

  sub summary :Chained(root) PathPart('') CaptureArgs(0) {
    my ($self, $c) = @_;
    my ($model, $set) = ($c->model, "all");
    if(my $q = $c->req->query_parameters->{q}) {
      if($q eq 'completed') {
        $model = $model->completed;
        $set = $q;
      } elsif($q eq 'active') {
        $model = $model->active;
        $set = $q;
      } 
    }
    $c->view('Summary', tasks => $model, set => $set);
  }
    
    sub view :GET Chained('summary') PathPart('') Args(0) {
      my ($self, $c) = @_;
      $c->view('Summary')->http_ok;
    }

    sub add :POST Chained(summary) PathPart('') Args(0) {
      my ($self, $c) = @_;
      my $form = $c->model('Form::Task',
        $c->model->new_result(+{}));
      $form->is_valid ?
        $c->view('Summary')->http_ok :
        $c->view('Summary')->apply('InputErrors', $form)
          ->http_bad_request;
    }

  sub clear_completed :POST Chained(root) Args(0) {
    my ($self, $c) = @_;
    $c->model->completed->delete_all;
    $c->redirect_to($self->action_for('view'));
  }

  sub not_found { ... }

__PACKAGE__->meta->make_immutable;
