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

1;
