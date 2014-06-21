use strict;
use warnings;

use Test::Most tests => 5;

use lib 't/lib';
use Example;

my $ex = Example->new;
$ex->msg_type( 'reply' );
ok( $ex->header->{msg_type} eq 'reply' );
ok( $ex->msg_type eq 'reply' );

my $ex_handle_constructor = Example->new( msg_type => 'reply', header => { answer => 42 }  );
ok( $ex_handle_constructor->header->{msg_type} eq 'reply' );
ok( $ex_handle_constructor->msg_type eq 'reply' );
ok( $ex_handle_constructor->header->{answer} == 42 );

done_testing;

