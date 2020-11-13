#include <gmock/gmock.h>

TEST(AppTest, passingTest)
{
    ASSERT_TRUE(true);
}

TEST(AppTest, failingTest)
{
    ASSERT_TRUE(false);
}
