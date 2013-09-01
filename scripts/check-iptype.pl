#!/usr/bin/perl
use Net::IP;
my $ip = new Net::IP ($ARGV[0]) or die (Net::IP::Error());
print ($ip->iptype()."\n");
