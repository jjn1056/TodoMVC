requires 'Catalyst', '5.90114';
requires 'Catalyst::ActionRole::Public', '0.009';
requires 'Catalyst::ActionSignatures', '0.010';
requires 'Catalyst::Model::DBIC::Schema', '0.65';
requires 'Catalyst::Model::HTMLFormhandler', '0.009';
requires 'Catalyst::Plugin::ConfigLoader', '0.34';
requires 'Catalyst::Plugin::CurrentComponents', '0.006';
requires 'Catalyst::Plugin::RedirectTo', '0.001';
requires 'Catalyst::Plugin::URI', '0.002';
requires 'Catalyst::TraitFor::Model::DBIC::Schema::Result', '0.005';
requires 'Catalyst::View::Template::Pure', '0.017';
requires 'Catalyst::ControllerRole::At', '0.005';
requires 'DBIx::Class', '0.082840';
requires 'DBIx::Class::Helpers', '2.031002';
requires 'DBIx::Class::Schema::Loader', '0.07046';
requires 'DBIx::Class::TimeStamp', '0.14';
requires 'DBIx::Class::Migration', '0.058';
requires 'DBD::SQLite', '1.52';
requires 'Plack', '1.0042';
requires 'Type::Tiny', '1.000005';
requires 'Gazelle', '0.46';

on test => sub {
  requires 'Catalyst::Test';
  requires 'HTTP::Request::Common', '6.11';
  requires 'Test::DBIx::Class', '0.52';
  requires 'Test::Most', '0.35';
};

on develop => sub {
  requires 'App::Ack', '2.14';
  requires 'Devel::Confess', '0.009003';
  requires 'Devel::Dwarn';
  requires 'App::cpanoutdated';
};
