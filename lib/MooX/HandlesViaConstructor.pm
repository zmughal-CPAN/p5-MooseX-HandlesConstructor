package MooX::HandlesViaConstructor;

use strict;
use warnings;

use Moo 1.001000 ();    # $Moo::MAKERS support
use Moo::Role ();

use constant
	CON_ROLE => 'Method::Generate::Constructor::Role::HandlesAccessor';

sub import {
	my $class = shift;
	my $target = caller;

	unless ($Moo::MAKERS{$target} && $Moo::MAKERS{$target}{is_class}) {
		die "MooX::HandlesAccessor can only be used on Moo classes.";
	}

	_apply_role( $target );
}

sub _apply_role {
	my $target = shift;
	my $con = Moo->_constructor_maker_for($target);
	Moo::Role->apply_roles_to_object($con, CON_ROLE)
		unless Role::Tiny::does_role($con, CON_ROLE);
}


1;

=head1 ACKNOWLEDGMENTS

This code was based off of L<MooX::StrictConstructor>.

=head1 SEE ALSO

L<MooX::HandlesVia>.

=cut
