package  TodoMVC::Web::View::Summary;
 
use Moose;
use HTTP::Status qw(:constants);
use Catalyst::View::Template::Pure::Helpers (':All');
 
extends 'Catalyst::View::Template::Pure';

has 'set' => (is=>'ro', required=>1);
has 'tasks' => (is=>'ro', required=>1);

sub sets_href {
  my ($self) = @_;
  my $base_uri = $self->ctx->uri_for(
    $self->ctx->controller('Root')->action_for('view'));
  return + {
    all => do { my $u = $base_uri->clone; $u->query_param(q=>'all'); $u },
    active => do { my $u = $base_uri->clone; $u->query_param(q=>'active'); $u },
    completed => do { my $u = $base_uri->clone; $u->query_param(q=>'completed'); $u },
  };
}

__PACKAGE__->config(
  returns_status => [HTTP_OK],
  auto_template_src => 1,
  directives => [
    'form#new_task@action' => Uri('Root.add'),
    'form#clear_completed@action' => Uri('Root.clear_completed'),
    'ul.todo-list li' => {
      '.<-tasks' => [
        '.@class' => 'completed | cond("completed", undef)',
        '.destroy@formaction' => Uri('Task.delete',['={id}']),
        '.@id+' => 'id',
        'label@data-task' => 'id',
        'form@action' => Uri('Task.update',['={id}']),
        'label' => 'title',
        'input[name="title"]@value' => 'title',
        'input[name="completed"]@checked' => 'completed | cond("on",undef)',
      ],
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
