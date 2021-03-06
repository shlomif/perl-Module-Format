#!/usr/bin/perl

use strict;
use warnings;

use IO::All;

my ($version) =
    ( map { m{\Aversion *= *(\S+)\n?\z} ? ($1) : () }
        io->file("./dist.ini")->getlines() );

if ( !defined($version) )
{
    die "Version is undefined!";
}

my @cmd = (
    "git", "tag", "-m", "Tagging the Module-Format release as $version",
    "Module-Format-v$version",
);

print join( " ", map { /\s/ ? qq{"$_"} : $_ } @cmd ), "\n";
exec(@cmd);
