package TodoMVC::Schema::ResultSet;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

__PACKAGE__->load_components(qw/
  Helper::ResultSet::Shortcut
  Helper::ResultSet::Me
  Helper::ResultSet::SetOperations
  Helper::ResultSet::IgnoreWantarray
/);

sub __GenericInflator::inflate_result {
  my $self = shift;
  return $self->[1]->($self->[0], $self->[1], @_);
}

=head2 inflator

Allows you to use a callback as a custom inflator class.  Example:

    $rs->inflator(sub {
      my ($original_rs, $cb, $result_source, \%columndata, \%prefetcheddata) = @_;
      return ...
    })->all;

B<NOTE>: The last argument C<\%prefetcheddata> is optional.

=cut

sub inflator {
  $_[0]->result_class(bless [$_[0], $_[1]], '__GenericInflator');
  return $_[0];
}

1;
