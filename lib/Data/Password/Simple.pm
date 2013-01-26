package Data::Password::Simple;

use 5.006;
use strict;
use warnings FATAL => 'all';

use Carp;

=head1 NAME

Data::Password::Simple provides a system of checking given strings against
password complexity requirements.

Current features: 

    Case-insensitive dictionary word checking.
    Minimum password length checking.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

    use Data::Password::Simple;

    my $checker = Data::Password::Simple->new(
        length => 6,
        dictionary => '/usr/share/dict/words'
    );

    $is_suitable = $checker->check($password) ? "yes" : "no";

=head1 CLASS METHODS

=head3 new

=head4 Input

=over

=item length

Optional. The minimum password length required.

Assumes 1 if not set.

=item dictionary

Optional. Enables dictionary checking.

Accepts either a word list, or a file location.

=back

=head4 Output

=over

Returns a Data::Password::Simple object.

=back

=cut

sub new {
    my $package = shift;
    my %params = @_;
    my %self;

    if ($params{dictionary}) {
        my $dict = _load_dict( $params{dictionary} );
        $self{_dictionary} = $dict // undef;
    }

    $self{_length} = $params{length} // 1;

    return bless (\%self, $package);
}

=head1 OBJECT METHODS

=head3 dictionary

Set or unset the dictionary used for word checking.

=head4 Input

Expects a either a list, a file location scalar or undef

Setting undef disables dictionary checking. Setting a dictionary enables it.

=head4 Output

Returns true value if the dictionary is successfully updated, a false value
otherwise.

=cut

sub dictionary {
    my $self = shift;
    my $replacement = shift;

    $self->{_dictionary} = _load_dict($replacement);

    if ( %{ $self->{_dictionary} } ) {
        return 1;
    }

    return;
}

=head3 length 

Set the minimum word required word length. 

If called without argument assumes 1

=head4 Input

Expects an integer

=head4 Output

Returns new minimum length value

=cut 

sub length {
    my $self = shift;
    my $length = shift;

    $self->{_length} = $length // 1;

    return $self->{_length};
}

=head3 check

Checks a given password against the specified criteria

=head4 Input

Expects a scalar password

=head4 Output

=over

=item success

Supplied with true value if the password meets requirements.

=item error

Only provided when the password fails to meet requirements.

Contains the following:

=over

=item too_short

True value if the password is too short to meet the current length requirement.

=item in_dictionary

True value if the password matches a dictionary word.

=back

=cut

sub check {
    my $self = shift;
    my $password = shift;
    my %error;

    if (CORE::length $password < $self->{_length}) {
        $error{too_short} = 1;
    }

    if (exists $self->{_dictionary}{lc $password}) {
        $error{in_dictionary} = 1;
    }

    if (%error) {
        return { error => \%error };
    }

    return { success => 1 };
}

sub _load_dict {
    my $source = shift;
    my %dict;

    # Create a dictionary from a given list.
    if ( ref ($source) =~ /ARRAY/i )  {
        for my $word ( @{$source} ) {
            $dict{$word} = 1;
        }
        return \%dict;
    }

    # Or assume we've been given a file name.
    # Make sure it's actually a file.
    if ( (!-e $source || !-r _) or (!-f _ || !-l _ ) ) {
        carp "$source does not exist, is not readable, or is not a file";
        return;
    }

    open (my $FILE, '<', $source) or do {
        carp "Failed to open $source for reading";
        return;
    };

    while (<$FILE>) {
        chomp;
        $dict{$_} = 1;
    }

    return \%dict;
}

=head1 AUTHOR

Ross Hayes, C<< <ross at abablabab.co.uk> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-data-password-simple at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Data-Password-Simple>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Data::Password::Simple


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Data-Password-Simple>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Data-Password-Simple>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Data-Password-Simple>

=item * Search CPAN

L<http://search.cpan.org/dist/Data-Password-Simple/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2013 Ross Hayes.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1; # End of Data::Password::Simple
