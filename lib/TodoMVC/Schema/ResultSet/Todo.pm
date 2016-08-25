use strict;
use warnings;

package TodoMVC::Schema::ResultSet::Todo;

use base 'TodoMVC::Schema::ResultSet';

sub active {
  return $_[0]->search({$_[0]->me('completed') => 0});
}

sub completed {
  return $_[0]->search({$_[0]->me('completed') => 1});
}

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
