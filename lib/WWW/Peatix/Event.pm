package WWW::Peatix::Event;
use strict;
use Text::CSV;

sub new {
    my $class = shift;
    my %args = @_;
    bless {
        id  => $args{id},
        ptx => $args{ptx},
    }, $class;
}

sub attendees {
    my $self = shift;
    my $cb   = shift;

    # Silly, but we have to scrape and get this form_token bit in order to
    # download the CSV file

    # XXX no provision for being logged out. need that.
    my $res = $self->{ptx}->{mech}->get("http://peatix.com/event/$self->{id}/list_attendees");
    if ($res->decoded_content() !~ /download_attendances\?form_token=([^"]+)/) {
        die "Could not find download link";
    }

    my $token = $1;
    $res = $self->{ptx}->{mech}->get("http://peatix.com/event/$self->{id}/download_attendances?form_token=$token");

    my $buf = $res->decoded_content;
    open my $attendees, '<', \$buf or die "Could not open in-memory fh: $!";
    binmode($attendees, ":raw:encoding(utf-8)");

    my @attendees;
    my $csv = Text::CSV->new({binary => 1});
    while ( my $row = $csv->getline($attendees) ) {
        if ($cb) {
            push @attendees, $cb->($row);
        } else {
            push @attendees, {
                purchase_id => shift @$row,
                name        => shift @$row,
                datetime    => shift @$row,
                ticket_name => shift @$row,
                amount      => shift @$row,
                ticket_id   => shift @$row,
                extras      => $row
            }
        }
    }
    $csv->eof or die $csv->error_diag;

    return @attendees;
}

1;
