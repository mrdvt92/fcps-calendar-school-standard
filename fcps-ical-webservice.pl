#!/usr/bin/perl
use strict;
use warnings;
use DateTime;
use iCal::Parser;
use HTTP::Tiny;

my $url    = 'http://www.fcps.edu/events/15/calendar.ics';
my $res    = HTTP::Tiny->new->get($url);
die('Error: HTTP Error') unless $res->{'success'};
my $parser = iCal::Parser->new;
my $hash   = $parser->parse_strings($res->{'content'});
my $events = $hash->{'events'} or die('Error: no events');

foreach my $days (0 .. 365) {
  my $dt   = DateTime->now->add(days=>$days);
  my $date = $events->{$dt->year}->{$dt->month}->{$dt->day};
  if (ref($date) eq 'HASH') {
    foreach my $key (keys %$date) {
      my $event   = $date->{$key};
      my $summary = $event->{'SUMMARY'};
      if ($summary =~ m/Holiday/i) {
        printf "Year: %s, Month: %s, Day: %s, Holiday: %s\n", $dt->year, $dt->month, $dt->day, $summary;
      }
    }
  }
}
