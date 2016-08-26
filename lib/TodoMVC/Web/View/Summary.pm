package  TodoMVC::Web::View::Summary;
 
use Moose;
use HTTP::Status qw(:constants);
 
extends 'Catalyst::View::Template::Pure';

has 'set' => (is=>'ro', required=>1);
has 'tasks' => (is=>'ro', required=>1);
 
__PACKAGE__->config(
  timestamp => scalar(localtime),
  returns_status => [HTTP_OK],
  auto_template_src => 1,
  directives => [
    'ul.todo-list li' => {
      '.<-tasks' => [
        '.@id+' => 'id',
        '.@class' => sub {
          my ($i, $dom, $data) = @_;
          my $status = $i->data_at_path($data, 'completed') ? 'completed' : undef;
        },
        'label' => 'title',
        'label@data-task' => 'id',
        'input[name="title"]@value' => 'title',
        'input[name="completed"]@checked' => sub {
          my ($i, $dom, $data) = @_;
          return $i->data_at_path($data, 'completed') ? 'on' : undef;
        },
        'form@action+' => 'id',
        '.destroy@formaction+' => '={id}/delete ',
      ],
    },
    '.todo-count strong' => 'tasks.active.count',
    '.filters a.={set}@class' => '"selected"',
  ],
);
 
__PACKAGE__->meta->make_immutable
