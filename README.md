# README

## NAME

WWW::Peatix - Interface With Peatix.com

## SYNOPSIS

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
