package TodoMVC;

1;

=head1 NAME

TodoMVC - Examples for YAPC::EU::2016

=head1 SYNOPSIS

Project setup

    make setup
    
Execute a command using the Perl and libs under ./local\

    bin/exec

Start a Local Server

    make server

Or for more control

  CATALYST_DEBUG=1 DBIC_TRACE=1 \
    local/exec perl -Ilib lib/TodoMVC/Web/Server.pm --server Gazelle

=head1 DESCRIPTION

L<Catalyst> web framework example with L<DBIx::Class>

=head1 METHODS

This Class defines the following methods

=head1 AUTHORS & COPYRIGHT

John Napiorkowski, Copyright 2016

=head1 LICENSE

This software is owned by John Napiorkowski.  All Rights Reserved.

=cut
