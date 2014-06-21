package MooseX::HandlesConstructor;

use strict;
use warnings;
use MooseX::MungeHas ();
use Import::Into;
use Class::Method::Modifiers qw(install_modifier);

sub import {
	my ($class) = @_;

	my $target = caller;

	my %_handles_via_accessors;

	MooseX::MungeHas->import::into( $target, sub {
		my $name = shift;
		my %has_args = @_;
		if( exists $has_args{handles} ) {
			my %handles = %{ $has_args{handles} };
			my @accessors = grep {
					my $handle_val = $handles{$_};
					ref $handle_val eq 'ARRAY'
					and @$handle_val == 2
					and $handle_val->[0] eq 'accessor'
				} keys %handles;
			@_handles_via_accessors{ @accessors } = (1) x @accessors;
		}
	} );

	install_modifier( $target, 'fresh', BUILD => sub {} ) unless $target->can('BUILD');

	install_modifier($target, 'after', BUILD => sub {
		my ($self, $args) = @_;
		while( my ($attr, $attr_value) = each %$args ) {
			# NOTE This may be better handled as a set intersection
			# between (keys %_handles_via_accessors) and
			# (keys %$args) but for small hashes, it's probably not
			# efficient.
			if( exists $_handles_via_accessors{$attr} ) {
				$self->$attr( $attr_value );
			}
		}
	});
}

1;
