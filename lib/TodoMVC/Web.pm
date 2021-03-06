package TodoMVC::Web;

use Catalyst qw/
  ConfigLoader
  RedirectTo
  URI
  CurrentComponents
/;

__PACKAGE__->inject_components(
  'Model::Form' => { from_component => 'Catalyst::Model::Data::MuForm' },
  'Model::Schema' => { from_component => 'Catalyst::Model::DBIC::Schema'});

__PACKAGE__->config(
  'root' => __PACKAGE__->path_to('share'),
  'default_model' => 'Schema::Todo',
  'Controller::Root' => { namespace => '' },
  'Model::Form::Task' => { form_class=>'TodoMVC::Web::Form::Task' },
  'Model::Schema' => {
    traits => ['SchemaProxy', 'FromMigration'],
    schema_class => 'TodoMVC::Schema',
    querylog_args => { passthrough => 1 },
  });

__PACKAGE__->setup;

=head1 NAME

TodoMVC::Web - Example Catalyst Application fro YAPC::EU::2016 

=head1 SYNOPSIS

    TBD

=head1 DESCRIPTION

    TBD

=head1 METHODS

This class defines the following methods

=head1 AUTHORS & COPYRIGHT

See L<TodoMVC>

=head1 LICENSE

See L<TodoMVC>

=cut

