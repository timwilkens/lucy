use strict;
use warnings;

use Test::More tests => 37;

package BoilingThing;
use base qw( Boilerplater::Symbol );

sub new { return shift->SUPER::new( exposure => 'parcel', @_ ) }

package main;

for (qw( foo FOO 1Foo Foo_Bar FOOBAR 1FOOBAR )) {
    eval { my $thing = BoilingThing->new( class_name => $_ ) };
    like( $@, qr/class name/, "Reject invalid class name $_" );
    my $bogus_middle = "Foo::" . $_ . "::Bar";
    eval { my $thing = BoilingThing->new( class_name => $bogus_middle ) };
    like( $@, qr/class name/, "Reject invalid class name $bogus_middle" );
}

my @exposures = qw( public private parcel local );
for my $exposure (@exposures) {
    my $thing = BoilingThing->new( exposure => $exposure );
    ok( $thing->$exposure, "exposure $exposure" );
    my @not_exposures = grep { $_ ne $exposure } @exposures;
    ok( !$thing->$_, "$exposure means not $_" ) for @not_exposures;
}

my $foo    = BoilingThing->new( class_name => 'Foo' );
my $foo_jr = BoilingThing->new( class_name => 'Foo::FooJr' );
ok( !$foo->equals($foo_jr), "different class_name spoils equals" );
is( $foo_jr->get_class_name, "Foo::FooJr", "get_class_name" );
is( $foo_jr->get_class_cnick, "FooJr", "derive class_cnick from class_name" );

my $public_exposure = BoilingThing->new( exposure => 'public' );
my $parcel_exposure = BoilingThing->new( exposure => 'parcel' );
ok( !$public_exposure->equals($parcel_exposure),
    "different exposure spoils equals"
);

my $lucifer_parcel = Boilerplater::Parcel->singleton( name => 'Lucifer' );
my $lucifer = BoilingThing->new( parcel => 'Lucifer' );
ok( $lucifer_parcel == $lucifer->get_parcel, "derive parcel" );
is( $lucifer->get_prefix, "lucifer_", "get_prefix" );
is( $lucifer->get_Prefix, "Lucifer_", "get_Prefix" );
is( $lucifer->get_PREFIX, "LUCIFER_", "get_PREFIX" );
my $luser = BoilingThing->new( parcel => 'Luser' );
ok( !$lucifer->equals($luser), "different parcel spoils equals" );

