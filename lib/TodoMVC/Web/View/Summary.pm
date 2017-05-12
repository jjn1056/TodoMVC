package  TodoMVC::Web::View::Summary;
 
use Moo;
use curry;
use Template::Lace::Utils 'mk_component';
extends 'Catalyst::View::Template::Lace';
with 'Template::Lace::ModelRole',
  'Template::Lace::Model::AutoTemplate',
  'Catalyst::View::Template::Lace::Role::URI';

has 'set' => (is=>'ro', required=>0);
has 'tasks' => (is=>'ro', required=>1);

sub active_task_count { shift->tasks->active->count }
 
sub process_dom {
  my ($self, $dom) = @_;
  $dom->do(
    '.todo-list li' => $self->curry::todos,
    '#new_task@action' => $self->uri('add'),
    '#clear_completed@action' => $self->uri('clear_completed'),
    '#active-count' => $self->active_task_count,
    '#active@href' => $self->uri('summary',{q=>'active'}),
    '#completed@href' => $self->uri('summary',{q=>'completed'}),
    "#${\$self->set}\@class" => 'selected',
  );
}

sub todos {
  my ($self, $dom) = @_;
  $dom->repeat(sub {
    $self->todo(@_);
  }, $self->tasks->all);
}

sub todo {
  my ($self, $dom, $item) = @_;
  $dom->id('task'.$item->todo_id)
    ->class($item->completed ? "completed": undef);
    
  $dom->at('form')
    ->action($self->uri('/task/update', [$item->todo_id]))
    ->id('form'.$item->todo_id);
  
  $dom->at('label')
    ->content($item->title)
    ->attr('data-task', $item->todo_id);


  $dom->at('input[name="title"]')->attr('value',($item->title));
  $dom->at('input[name="completed"]')->checked($item->completed);
  $dom->at('button[name="destroy"]')->formaction($self->uri('/task/delete', [$item->todo_id]));


}



## This is just a prototype for now.  Until we solve the 
## looping / context problem its just a toy.
__PACKAGE__->config(
  component_handlers => {
    catalyst => {
      uri => mk_component {
        my @args = (delete $_{action});
        push @args, delete($_{parts}) if $_{parts};
        push @args, delete($_{query}) if $_{query};
        my $href = $_{model}->uri(@args);
        my $attr = join ' ',
          map { "$_='$_{$_}'" }
          grep {
            $_ ne 'cb'
            && $_ ne 'uuid'
            && $_ ne 'ctx'
            && $_ ne 'content'
            && $_ ne 'model'
          } keys %_;
        return "<a href='$href' $attr>$_{content}</a>"
      },
    }
  }
);

