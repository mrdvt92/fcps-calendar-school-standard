#!/usr/bin/perl
use v5.10;
use strict;
use warnings;
use JSON::XS qw{encode_json};
use Tie::IxHash;
use Path::Class qw{file dir};

my $folder    = 'files';
my $coder     = JSON::XS->new->pretty;
my @header    = ();

my $header = 1;
while (my $line = <>) {
  chomp $line;
  if ($header) {
    if ($line) {
      my ($key, $val) = split /:/, $line, 2;
      $key =~ s/\A\s+//;
      $key =~ s/\s+\Z//;
      $val =~ s/\A\s+//;
      $val =~ s/\s+\Z//;
      push @header, ($key => $val);
    } else {
      $header = 0;
    }
  } else {
    my ($dt, $students, $staff, $codes, $notes) = split /,/, $line;
    say join ",", $dt, $students, $staff, $codes, $notes;
    my @codes = split /\//, $codes;
    say(" - ", join ",", @codes) if @codes;
    tie my %data, 'Tie::IxHash';
    %data = (
             @header,
             dt        => $dt,
             students  => $students ? \1 : \0,
             staff     => $staff    ? \1 : \0,
             notes     => $notes,
             options   => {map {$_ => \1} @codes},
            );
    my $json = $coder->encode(\%data);
    say $json;
    my $file = file($folder, "$dt.json");
    $file->spew($json);
  }
}
