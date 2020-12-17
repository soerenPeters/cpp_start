project(Boost_example CXX)

set(TARGET_NAME
        Boost_example)

set(SOURCE_FILES
        Boost_example.cpp)

set(TEST_FILES
        test_boost_example.cpp)

set(PUBLIC_LINK)

set(PRIVATE_LINK)

link_boost(VERSION 1.70 COMPONENTS filesystem)

add_target()

