#include <gmock/gmock.h>

#include <spdlog/spdlog.h>

#include "Cuda_example.h"


TEST(Cuda_exampleTest, addWithCuda)
{
    cpp_start::Cuda_example sut;

    const auto result = sut.add({ 1, 2 }, { 3, 4 });

    ASSERT_THAT(result, testing::ElementsAre(4, 6));
}

TEST(Cuda_exampleTest, whenDeviceNumberIsInvalid_ShoudThrowRuntimeError)
{
    cpp_start::Cuda_example sut;

    const int numberOfDevices = sut.getNumberOfDevices();

    ASSERT_THROW(sut.getDeviceName(numberOfDevices), std::runtime_error);
}

TEST(Cuda_exampleTest, print_numberOfDevices)
{
    cpp_start::Cuda_example sut;

    const auto result = sut.getNumberOfDevices();

    spdlog::info("Number of Devices: {0}", result);
}

TEST(Cuda_exampleTest, print_deviceProperties)
{
    cpp_start::Cuda_example sut;

    const int numberOfDevices = sut.getNumberOfDevices();

    for (int i = 0; i < numberOfDevices; ++i) {
        const auto name     = sut.getDeviceName(i);
        const auto cc       = sut.getComputeCapability(i);
        const double memory = sut.getTotalGlobalMemory(i) / 1024. / 1024. / 1024.;
        const auto peakMemoryBandwith = sut.getPeakMemoryBandwidth(i);

        spdlog::info("Device Number {0}:", i);
        spdlog::info("Name: {0}", name);
        spdlog::info("Compute Capability: {0}", cc);
        spdlog::info("Total global memory: {0} [GB]", memory);
        spdlog::info("Peak memory bandwith: {0} [GB/s]", peakMemoryBandwith);
    }
}
