package  TodoMVC::Web::View::Summary;
 
use Moo;
use Template::Lace::Utils 'mk_component';
extends 'Catalyst::View::Template::Lace';
with 'Template::Lace::ModelRole',
  'Template::Lace::Model::AutoTemplate',
  'Catalyst::View::Template::Lace::Role::URI';

has 'set' => (is=>'ro', required=>0);
has 'tasks' => (is=>'ro', required=>1); 
  
sub process_dom {
  my ($self, $dom) = @_;
  $dom->at('.todo-list li')
    ->repeat(sub {
        my ($dom, $item, $idx) = @_;
        $dom->id('task'.$item->todo_id)
          ->class($item->completed ? "completed": undef);
        
        $dom->at('label')
          ->content($item->title)
          ->attr('data-task', $item->todo_id);

        $dom->at('input[name="title"]')->attr('value', $item->title);
        $dom->at('input[name="completed"]')->attr('checked', 'on') if $item->completed;

        $dom->at('.destroy')->attr('formaction', $self->uri('/task/delete', [$item->todo_id]));
        $dom->at('form')
          ->action($self->uri('/task/update', [$item->todo_id]))
          ->id('form'.$item->todo_id);
          
      }, $self->tasks->all);

  $dom->at('form#new_task')->action($self->uri('add'));
  $dom->at('form#clear_completed')->action($self->uri('clear_completed'));

  $dom->at('.todo-count strong')->content($self->tasks->active->count);

  $dom->at('#active')->href( $self->uri('/summary',{q=>'active'}));
  $dom->at('#completed')->href( $self->uri('/summary',{q=>'completed'}));
  $dom->at("#${\$self->set}")->class('selected');
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

