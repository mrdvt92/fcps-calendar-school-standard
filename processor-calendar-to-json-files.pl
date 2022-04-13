#!/usr/bin/perl
use v5.10;
use strict;
use warnings;
use JSON::XS qw{encode_json};
use Tie::IxHash;
use Path::Class qw{file dir};

my $authority = 'Farifax County Public Schools';
my $calendar  = '2021-2022 Standard School Year';
my $folder    = 'files';
my $coder     = JSON::XS->new->pretty;

while (my $line = <>) {
  chomp $line;
  my ($ymd, $students, $staff, $codes, $notes) = split /,/, $line;
  say join ",", $ymd, $students, $staff, $codes, $notes;
  my @codes = split /\//, $codes;
  say(" - ", join ",", @codes) if @codes;
  tie my %data, 'Tie::IxHash';
  %data = (
           authority => $authority,
           calendar  => $calendar,
           dt        => $ymd,
           students  => $students ? \1 : \0,
           staff     => $staff    ? \1 : \0,
           notes     => $notes,
           options   => {map {$_ => \1} @codes},
          );
  my $json = $coder->encode(\%data);
  say $json;
  my $file = file($folder, "$ymd.json");
  $file->spew($json);
}
