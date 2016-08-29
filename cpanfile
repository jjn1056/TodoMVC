requires 'Catalyst', '5.90112';
requires 'Catalyst::ActionRole::Public', '0.009';
requires 'Catalyst::ActionSignatures', '0.010';
requires 'Catalyst::Model::DBIC::Schema', '0.65';
requires 'Catalyst::Model::HTMLFormhandler', '0.007';
requires 'Catalyst::Plugin::ConfigLoader', '0.34';
requires 'Catalyst::Plugin::CurrentComponents', '0.004';
requires 'Catalyst::Plugin::RedirectTo', '0.001';
requires 'Catalyst::Plugin::URI', '0.002';
requires 'Catalyst::TraitFor::Model::DBIC::Schema::Result', '0.005';
requires 'Catalyst::View::Template::Pure', '0.005';
requires 'DBIx::Class', '0.082821';
requires 'DBIx::Class::Helpers', '2.031000';
requires 'DBIx::Class::Schema::Loader', '0.07045';
requires 'DBIx::Class::TimeStamp', '0.14';
requires 'DBIx::Class::Migration';
requires 'DBD::SQLite';
requires 'Plack', '1.0037';
requires 'Type::Tiny', '1.000005';
requires 'Gazelle', '0.41';

on test => sub {
  requires 'Catalyst::Test';
  requires 'HTTP::Request::Common', '6.11';
  requires 'Test::DBIx::Class', '0.47';
  requires 'Test::Most', '0.34';
};

on develop => sub {
  requires 'App::Ack', '2.14';
  requires 'Devel::Confess', '0.008000';
  requires 'Devel::Dwarn';
  requires 'App::cpanoutdated';
};
