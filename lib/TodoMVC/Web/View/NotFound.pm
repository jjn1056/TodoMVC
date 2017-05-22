package  TodoMVC::Web::View::NotFound;
 
use Moo;
extends 'Catalyst::View::Template::Lace';

sub template {q{
  <view-master
      title=\'title:content'
      body=\'body:content'>
    <html lang="en">
      <head>
        <title>Not Found</title>
      </head>
      <body>
        <section class="todoapp">
        <header class="header">
          <h1>Not Found</h1>
        </header>
        </section>
      </body>
    </html>
  </view-master>
}}

1;
