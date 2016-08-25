package TodoMVC::Web::Controller::Root;

use Moose;
use MooseX::MethodAttributes;

extends 'Catalyst::Controller';

sub root :Chained(/) PathPart('') CaptureArgs(0) {  }

  sub static :Chained(root) Does(Public) At(/:actionname/*) {  }

  sub summary :Chained(root) PathPart('') CaptureArgs(0) {
    my ($self, $c) = @_;
    $c->view('Summary', tasks => $c->model);
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

__PACKAGE__->meta->make_immutable;
