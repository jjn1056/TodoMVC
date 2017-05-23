package  TodoMVC::Web::View::Summary;
 
use Moo;
use curry;
extends 'Catalyst::View::Template::Lace';
with 'Template::Lace::Model::AutoTemplate',
  'Catalyst::View::Template::Lace::Role::URI';

has 'set' => (is=>'ro', required=>0);
has 'tasks' => (is=>'ro', required=>1);

sub active_task_count { shift->tasks->active->count }
 
sub process_dom {
  my ($self, $dom) = @_;
  $dom->do(
    '.todo-list li' => $self->curry::todos($self->tasks),
    '#new_task@action' => $self->uri('add'),
    '#clear_completed@action' => $self->uri('clear_completed'),
    '#active-count' => $self->active_task_count,
    '.filters a' => $self->curry::filter_links($self->set),
  );
}

sub todos {
  my ($self, $tasks, $dom) = @_;
  $dom->repeat($self->curry::todo, $tasks->all)
}

sub todo {
  my ($self, $dom, $item) = @_;
  $dom->do(
    '.@id' => "task${\$item->todo_id}",
    '.@class' => do { $item->completed ? 'completed' : undef },
    'form@action' => $self->uri('/task/update', [$item->todo_id]),
    'label' => $item->title,
    'label@data-task' => $item->todo_id,
    'input[name="title"]@value' => $item->title,
    'input[name="completed"]' => sub { $_->checked($item->completed) },
    'button[name="destroy"]@formaction' => $self->uri('/task/delete', [$item->todo_id]),
  );
}

sub filter_links {
  my ($self, $set, $dom) = @_;
  my $id = $dom->attr('id');
  $dom->href( $self->uri('summary',{q=>$id}) )
   ->class({selected => $id eq $set});
}

1;
