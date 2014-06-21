use strict;
use warnings;

use Test::Most tests => 10;

use lib 't/lib';
use ExampleMoo;
use ExampleMoose;

# 5 tests * 2 classes
for my $class (qw(ExampleMoo ExampleMoose)) {
	note "Testing class $class";
	my $ex = $class->new;
	$ex->msg_type( 'reply' );
	ok( $ex->header->{msg_type} eq 'reply' );
	ok( $ex->msg_type eq 'reply' );

	my $ex_handle_constructor = $class->new( msg_type => 'reply', header => { answer => 42 }  );
	ok( $ex_handle_constructor->header->{msg_type} eq 'reply' );
	ok( $ex_handle_constructor->msg_type eq 'reply' );
	ok( $ex_handle_constructor->header->{answer} == 42 );
}

done_testing;
