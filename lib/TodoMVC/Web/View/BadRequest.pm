package  TodoMVC::Web::View::BadRequest;
 
use Moose;
use HTTP::Status qw(:constants);
 
extends 'Catalyst::View::Template::Pure';
 
__PACKAGE__->config(
  returns_status => [HTTP_BAD_REQUEST],
  template => q[
    <?pure-overlay src='Views.Master' 
      title=\'title'
      body=\'body'?>
    <html lang="en">
      <head>
        <title>Not Found</title>
      </head>
      <body>
        <section class="todoapp">
        <header class="header">
          <h1>Bad Request</h1>
        </header>
        </section>
      </body>
    </html>
  ],
  directives => [
  ],
);
 
__PACKAGE__->meta->make_immutable
