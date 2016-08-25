use strict;
use warnings;

package TodoMVC::Schema::Result::Todo;

use base 'TodoMVC::Schema::Result';

__PACKAGE__->load_components('Ordered');
__PACKAGE__->table('todos');
__PACKAGE__->add_columns(
  todo_id => {
    data_type => 'integer',
    is_auto_increment => 1,
  },
  title => {
    data_type => 'varchar',
    size => '40',
  },
  position => {
    data_type => 'integer',
    is_numeric => 1,
  },
  completed => {
    data_type => 'boolean',
  });

__PACKAGE__->position_column('position');
__PACKAGE__->set_primary_key('todo_id');

1;

=head1 NAME

RangersCCG::Schema::Result::Todo - The list of things undo 

=head1 DESCRIPTION

A list of tasks that you need to do, and the status of them.

=head1 RELATIONSHIPS

  TBD

=head1 METHODS

This class defines the following methods

=head1 AUTHORS & COPYRIGHT

See L<RangersCCG>.

=head1 LICENSE

See L<RangersCCG>.

=cut
