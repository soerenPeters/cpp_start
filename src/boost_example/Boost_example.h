//
// Created by Soeren Peters on 17.12.20.
//

#ifndef CPPSTART_BOOST_EXAMPLE_H
#define CPPSTART_BOOST_EXAMPLE_H

#include <string>

#include "Boost_example_export.h"

namespace cpp_start
{

class BOOST_EXAMPLE_EXPORT Boost_example
{
public:
    bool match(std::string word, std::string regex) const;
};

}

#endif // CPPSTART_BOOST_EXAMPLE_H
