#!/usr/bin/perl
use v5.10;
use strict;
use warnings;
use DateTime;

my $year  = shift or die("Syntax: $0 [YYYY]");
my $month = 7;                                                   #FCPS Standard School Calendar always starts on July 1
my $day   = 1;

my $dt   = DateTime->new(year=>$year, month=>$month, day=>$day); #floating time zone
my $stop = $dt->clone->add(years=>1);                            #supports 364 or 365-day years

say "authority: ";
say "calendar: ";
say "";

while ($dt < $stop) {
  my $student = $dt->day_of_week > 5 ? "0" : "1";                #very rough cut
  my $staff   = $dt->day_of_week > 5 ? "0" : "1";                #very rough cut
  my $codes   = "";                                              #init as empty
  my $notes   = "";                                              #init as empty
  say join ",", scalar($dt->ymd), $student, $staff, $codes, $notes;
  $dt->add(days=>1);                                             #supports 23, 24, or 25-hour days
}
