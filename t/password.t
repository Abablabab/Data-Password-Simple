#!/usr/bin/env perl
                                                                      
use strict;
use Test::More;

use Data::Password::Simple;

plan('no_plan');

my @passwords = qw( short indictionary notindictionary both ); 
my $pc = Data::Password::Simple->new(
    dictionary => ['indictionary', 'both'],
    length => 6,
);

is_deeply( $pc->check("short"),
    {   error => { 
            too_short => 1 
        } 
    },
    'Rejected too short a password'
);
        
is_deeply( $pc->check("indictionary"),
    {   error => { 
            in_dictionary => 1 
        } 
    },
    'Rejected a password in the dictionary'
);

is_deeply( $pc->check("both"),
    {   error => { 
            too_short => 1,
            in_dictionary => 1
        }
    },
    'Rejected a password for being too short, and in the dictionary'
);

is_deeply( $pc->check("notindictionary"),
    { success => 1 },
    'Accepted password that meets minimum lengths and is not in the dictionary'
);
