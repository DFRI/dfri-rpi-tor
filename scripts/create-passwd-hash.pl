#!/usr/bin/perl
use strict;
use warnings;

my $salt = join "", (".", "/", 0..9, "A".."Z", "a".."z")[rand 64, rand 64, rand 64, rand 64];
my $pass = $ARGV[0];

$salt="\$6\$$salt\$";

print crypt($pass, $salt) . "\n";

exit 0;
