cmake_minimum_required(VERSION 2.8)

find_package(CUDA REQUIRED)
set(Boost_USE_STATIC_LIBS @Boost_USE_STATIC_LIBS@)
set(Boost_USE_STATIC @Boost_USE_STATIC@)
set(Boost_USE_MULTITHREAD @Boost_USE_MULTITHREAD@)
set(BOOST_INCLUDEDIR "@Boost_INCLUDE_DIR@")
set(BOOST_REQUIRED_MODULES system filesystem thread date_time iostreams chrono)
set(Boost_NO_BOOST_CMAKE ON)

INCLUDE_DIRECTORIES(${Boost_INCLUDE_DIR})
find_package(Boost 1.47.0 REQUIRED COMPONENTS ${BOOST_REQUIRED_MODULES})

file(GLOB kernels "*.cu")
#SET(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})

include_directories(
	kernels
	utility
	)


cuda_add_executable(
	hellocuda
	${kernels}
	)

target_link_libraries(hellocuda
        ${Boost_LIBRARIES}
)
