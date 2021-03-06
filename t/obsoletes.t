#!/usr/bin/perl -w

use strict;
use Test::More tests => 9;

require 't/testlib.pm';

my $repo = <<'EOR';
P: a = 1-1
R: p
P: b = 1-1 p
P: c = 1-1 p
P: d = 1-1
O: b
P: e = 1-1
O: c
P: f = 1-1
O: p
P: g = 1-1
O: b c
P: h = 1-1
R: b d
EOR

my $config = setuptest($repo);
my @r;

@r = expand($config, 'a');
is_deeply(\@r, [undef, 'have choice for p needed by a: b c'], 'install a');

@r = expand($config, 'a', 'd');
is_deeply(\@r, [1, 'a', 'c', 'd'], 'install a d');

@r = expand($config, 'a', 'e');
is_deeply(\@r, [1, 'a', 'b', 'e'], 'install a e');

@r = expand($config, 'a', 'd', 'e');
is_deeply(\@r, [undef, '(provider b is obsoleted by d)', '(provider c is obsoleted by e)', 'conflict for providers of p needed by a'], 'install a d e');

@r = expand($config, 'a', 'f');
is_deeply(\@r, [undef, 'have choice for p needed by a: b c'], 'install a f');

@r = expand($config, 'b', 'd');
is_deeply(\@r, [undef, 'd obsoletes b'], 'install b d');

@r = expand($config, 'h');
is_deeply(\@r, [undef, 'd obsoletes b'], 'install h');

@r = expand($config, 'h', 'd');
is_deeply(\@r, [undef, '(provider b is obsoleted by d)', 'conflict for providers of b needed by h'], 'install h d');

@r = expand($config, 'h', 'b');
is_deeply(\@r, [undef, '(provider d obsoletes b)', 'conflict for providers of d needed by h'], 'install h b');
