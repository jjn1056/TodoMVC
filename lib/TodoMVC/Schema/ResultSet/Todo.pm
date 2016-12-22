use strict;
use warnings;

package TodoMVC::Schema::ResultSet::Todo;

use base 'TodoMVC::Schema::ResultSet';

sub active {
  return $_[0]->search_rs({$_[0]->me('completed') => 0});
}

sub completed {
  return $_[0]->search_rs({$_[0]->me('completed') => 1});
}

sub filter_by {
  my ($self, $set) = @_;
  return $self unless $set;
  return $self->can($set) ? $self->$set : $self;
}

1;

=head1 NAME

TodoMVC::Schema::ResultSet::Todo - The list of things undo 

=head1 DESCRIPTION

A list of tasks that you need to do, and the status of them.

=head1 RELATIONSHIPS

  TBD

=head1 METHODS

This class defines the following methods

=head1 AUTHORS & COPYRIGHT

See L<TodoMVC>.

=head1 LICENSE

See L<TodoMVC>.

=cut
