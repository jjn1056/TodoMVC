package  TodoMVC::Web::View::Summary;
 
use Moose;
use HTTP::Status qw(:constants);
 
extends 'Catalyst::View::Template::Pure';

has 'tasks' => (is=>'ro', required=>1);
 
__PACKAGE__->config(
  timestamp => scalar(localtime),
  returns_status => [HTTP_OK, HTTP_BAD_REQUEST],
  auto_template_src => 1,
  directives => [
    'ul.todo-list li' => {
      'task<-tasks' => [
        'label' => 'task.title',
        'input[name="title"]@value' => 'task.title',
        'form@action1' => '={task}/task.id',
      ],
    }
  ],
);
 
__PACKAGE__->meta->make_immutable
