package  TodoMVC::Web::View::Summary;
 
use Moose;
use HTTP::Status qw(:constants);
 
extends 'Catalyst::View::Template::Pure';

has 'set' => (is=>'ro', required=>1);
has 'tasks' => (is=>'ro', required=>1);

sub delete_href {
  my ($self) = @_;
  return sub {
    my ($pure, $dom, $data) = @_;
    return $self->ctx->uri_for(
      $self->ctx->controller('Task')->action_for('delete'),
      [$pure->data_at_path($data,'id')]
    );
  };
}
 
sub update_href {
  my ($self) = @_;
  return sub {
    my ($pure, $dom, $data) = @_;
    return $self->ctx->uri_for(
      $self->ctx->controller('Task')->action_for('update'),
      [$pure->data_at_path($data,'id')]
    );
  };
}

sub new_href {
  my ($self) = @_;
  return sub {
    my ($pure, $dom, $data) = @_;
    return $self->ctx->uri_for(
      $self->ctx->controller('Root')->action_for('add'),
    );
  };
}

sub clear_completed_href {
  my ($self) = @_;
  return sub {
    my ($pure, $dom, $data) = @_;
    return $self->ctx->uri_for(
      $self->ctx->controller('Root')->action_for('clear_completed')
    );
  };
}

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
    'form#new_task@action' => 'new_href',
    'form#clear_completed@action' => 'clear_completed_href',
    'ul.todo-list li' => {
      '.<-tasks' => [
        '.@class' => 'completed | cond("completed", undef)',
        '.destroy@formaction' => '/delete_href', 
        '.@id+' => 'id',
        'label@data-task' => 'id',
        'form@action' => '/update_href',
        'label' => 'title',
        'input[name="title"]@value' => 'title',
        'input[name="completed"]@checked' => 'completed | cond("on",undef)',
      ],
    },
    '.todo-count strong' => 'tasks.active.count',
    '.filters' => [
      'a#={set}@class' => '"selected"',
      '#all@href' => 'sets_href.all',
      '#active@href' => 'sets_href.active',
      '#completed@href' => 'sets_href.completed',
    ],
  ],
);
 
__PACKAGE__->meta->make_immutable
