package WWW::Peatix;
use strict;
use 5.10.1;
use WWW::Mechanize;
our $VERSION = '0.01';

sub new {
    my $class = shift;
    my %args = @_;
    bless {
        mech        => WWW::Mechanize->new(),
        event_class => "WWW::Peatix::Event",
        signin_url  => "https://peatix.com/signin_get",
        username    => $args{username},
        password    => $args{password},
    }, $class;
}

sub login {
    my $self = shift;
    my $mech = $self->{mech};
    $mech->get( $self->{signin_url} );
    $mech->submit_form(
        form_number => 1,
        fields => {
            username => $self->{username},
            password => $self->{password},
        }
    );
}

sub event {
    my $self = shift;
    my $id   = shift;
    my $klass = $self->{event_class};
    eval "require $klass";
    die if $@;
    $klass->new(id => $id, ptx => $self);
}

1;

__END__

=head1 NAME

WWW::Peatix - Interface With Peatix

=head1 SYNOPSIS

    use strict;
    use WWW::Peatix;

    my $ptx = WWW::Peatix->new(
        username => "...",
        password => "...",
    );
    $ptx->login;

    my $event = $ptx->event( $event_id );

    foreach my $attendee ($event->attendees) {
        $attendee->{purchase_id},
        $attendee->{name};
        $attendee->{datetime};
        $attendee->{ticket_name};
        $attendee->{ticket_id};
        $attendee->{amount};
        $attebdee->{extra} = [ ... extra fields ];
    }

=cut