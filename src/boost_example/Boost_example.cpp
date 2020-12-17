//
// Created by Soeren Peters on 17.12.20.
//

#include "Boost_example.h"


#include <boost/filesystem.hpp>

namespace cpp_start
{

std::string Boost_example::getCurrentPath() const
{
    const boost::filesystem::path full_path(boost::filesystem::current_path());

    return full_path.string();
}

}
