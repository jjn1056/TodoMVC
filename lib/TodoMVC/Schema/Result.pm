use strict;
use warnings;

package TodoMVC::Schema::Result;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components(qw/
  Helper::Row::RelationshipDWIM
  Helper::Row::SelfResultSet
  TimeStamp
  InflateColumn::DateTime/);

sub default_result_namespace { 'TodoMVC::Schema::Result' }

1;
