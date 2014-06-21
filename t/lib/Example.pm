package #
	Example;

use Moo;
use MooX::HandlesVia;
use MooX::HandlesViaConstructor;

# HashRef
has header => ( is => 'rw',
	default => sub { {} },
	handles_via => 'Hash',
	handles => {
		session =>  [ accessor => 'session'  ],
		msg_type => [ accessor => 'msg_type' ]
	}
);

1;
