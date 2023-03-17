#! /usr/bin/env perl

use strict;
use feature 'postderef';
use warnings FATAL => 'all';
no warnings "experimental::postderef";
#use Carp::Always;

# use FindBin;
# use lib "$FindBin::Bin";
# use Xyzzy;

use constant { TRUE => 1, FALSE => 0 };

# 'wide character' warning.
binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");

# ------------------------------------------------------------------------

my $hard_break = 0.99;
my $soft_break = 0.95;
my $shell_break = 0.15;
my $cloud_break = 0.00;

# ------------------------------------------------------------------------

my $total = 0;

my $hard = 0;
my $soft = 0;
my $shell = 0;
my $cloud = 0;

while (<STDIN>) {
  chomp;
  my ($name,@scores) = split(/\t/);
  if ($name eq "") { next; }
  my $num_genomes = scalar(@scores);
  my $num_orths = 0;
  for (my $i=0; $i<scalar(@scores); $i++) {
    if ($scores[$i] > 0) {
      $num_orths++;
    }
  }
  my $pers = ($num_orths) / $num_genomes;
  printf "%s\t%.4f\n", $name, $pers;

  $total++;

  if ($hard_break <= $pers) {
    $hard++;
  } elsif ($soft_break <= $pers) {
    $soft++;
  } elsif ($shell_break <= $pers) {
    $shell++;
  } elsif ($cloud_break <= $pers) {
    $cloud++;
  } else {
    die "pers=<<$pers>>,";
  }
}

# ------------------------------------------------------------------------

printf STDERR "### Total: %d\n", $total;
$total *= 1.0;
printf STDERR "### Hard core: %d (%.2f%%)\n", $hard, 100*$hard/$total;
printf STDERR "### Soft core: %d (%.2f%%)\n", $soft, 100*$soft/$total;
printf STDERR "### Shell: %d (%.2f%%)\n", $shell, 100*$shell/$total;
printf STDERR "### Cloud: %d (%.2f%%)\n", $cloud, 100*$cloud/$total;
