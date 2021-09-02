//
// Created by Soeren Peters on 17.12.20.
//

#include "Boost_example.h"


#include <boost/regex.hpp>

namespace cpp_start
{

bool Boost_example::match(std::string word, std::string regex) const
{
    const boost::regex expression {regex};

    return boost::regex_match(word, expression);
}

}
