#!/usr/bin/env perl
                                                                      
use strict;
use Test::More;

use lib::abs('../lib');
use Data::Password::Simple 0.03;

plan('no_plan');

my @test_words = qw( 
    Telephone Sausage   Monkey Button    
    BOOK      CABBAGE   GLASS  MOUSE     
    stomache  cardboard ferry  christmas 
);

my @dictionary = qw( 
    Telephone Sausage    
    BOOK      CABBAGE    
    stomache  cardboard  
);

my $min_length = 6;

sub _expect {
    if (grep 


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

# Okay, testing strategy
#   test creation / accesors
#   test password checking
#       short
#       in dictionary
#       both
#       okay
#   test changing dictionary
#   test dictionary case insensitivity
