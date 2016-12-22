package  TodoMVC::Web::View::Summary::InputErrWrapper;

use Moose;
use HTTP::Status qw(:constants);
use Catalyst::View::Template::Pure::Helpers (':All');
use Template::Pure;

extends 'Catalyst::View::Template::Pure';

has [qw/errs content/] => (is=>'ro');

__PACKAGE__->config(
  template => q[
  <div class='input_with_errors'>
    <span style="background-color:#fff0f0; width=100%">Errors</span>
  </div>],
  directives => [
    '+div' => 'content',
    'div span' => {
      'err<-errs' => 'err',
    }
  ],
);

__PACKAGE__->meta->make_immutable
