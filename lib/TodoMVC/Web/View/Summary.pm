package  TodoMVC::Web::View::Summary;
 
use Moose;
use HTTP::Status qw(:constants);
use Catalyst::View::Template::Pure::Helpers (':All');
 
extends 'Catalyst::View::Template::Pure';

has 'set' => (is=>'ro', required=>1);
has 'tasks' => (is=>'ro', required=>1);

__PACKAGE__->config(
  returns_status => [HTTP_OK],
  auto_template_src => 1,
  directives => [
    'form#new_task@action' => Uri('Root.add'),
    'form#clear_completed@action' => Uri('Root.clear_completed'),
    'ul.todo-list li' => {
      '.<-tasks' => Apply('Summary::Task'),
    },
    '.todo-count strong' => 'tasks.active.count',
    '.filters' => [
      '#={set}@class' => '"selected"',
      '#all@href' => Uri('Root.view',{q=>'all'}),
      '#active@href' => Uri('Root.view',{q=>'active'}),
      '#completed@href' => Uri('Root.view',{q=>'completed'}),
    ],
  ],
);
 
__PACKAGE__->meta->make_immutable
