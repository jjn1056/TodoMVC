package  TodoMVC::Web::View::Summary;
 
use Moose;
use HTTP::Status qw(:constants);
use Catalyst::View::Template::Pure::Helpers (':All');

extends 'Catalyst::View::Template::Pure';

has 'set' => (is=>'ro', required=>0);
has 'tasks' => (is=>'ro', required=>1);

__PACKAGE__->config(
  returns_status => [HTTP_OK],
  auto_template_src => 1,
  directives => [
    'form#new_task@action' => Uri('add'),
    'form#clear_completed@action' => Uri('clear_completed'),
    'ul.todo-list li' => {
      '.<-tasks' => Apply('Summary::Task'),
    },
    '.todo-count strong' => 'tasks.active.count',
    '.filters' => [
      '#={set | default("all") }@class' => '"selected"',
      '#all@href' => Uri('view'),
      '#active@href' => Uri('view',{q=>'active'}),
      '#completed@href' => Uri('view',{q=>'completed'}),
    ],
  ],
);

sub apply_errors {
  my ($self, $form) = @_;
  return $self->apply('FormErrors',
    id => 'new_task',
    errors_by_name => $form->errors_by_name,
    input_wrapper => Wrap('Summary::InputErrWrapper'),
  );
}

__PACKAGE__->meta->make_immutable
