package Method::Generate::Constructor::Role::HandlesAccessor;

use strict;
use warnings;
use Moo::Role;
use B ();

around _assign_new => sub {
	my $orig = shift;
	my $self = shift;
	my $spec = $_[0];

	my @_handles_via_accessors;
	for my $has_args (values %$spec) {
		# e.g.,
		# $has_args = {
		#   handles {
		#     msg_type   [
		#       [0] "${\Data::Perl::Collection::Hash::MooseLike->can("accessor")}",
		#       [1] "msg_type"
		#     ],
		# }
		if( exists $has_args->{handles} ) {
			my %handles = %{ $has_args->{handles} };
			my @accessors_strings =
				map { B::perlstring($_) . " => 1," }
				grep {
					my $handle_val = $handles{$_};
					ref $handle_val eq 'ARRAY'
					and @$handle_val == 2
					and $handle_val->[0] =~ /accessor/ # ick
				} keys %handles;
			push @_handles_via_accessors, @accessors_strings;
		}
	}

	my $body;

	$body .= $self->$orig(@_);

	$body .= <<"EOF";
    my \%_handles_via_accessors = ( @_handles_via_accessors );
    while( my (\$attr, \$attr_value) = each \%\$args ) {
       if( exists \$_handles_via_accessors{\$attr} ) {
          # TODO this would be better handled as a set intersection
          \$new->\$attr( \$attr_value );
       }
    }
EOF

	return $body;
};


1;
