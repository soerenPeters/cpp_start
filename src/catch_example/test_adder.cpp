#include <catch2/catch.hpp>

#include "Adder.h"



TEST_CASE( "Add two values.", "[AdderTest]" )
{
    const myapi::Adder sut;

    REQUIRE( sut.add(1.5, 0.25) == 1.75 );
}
