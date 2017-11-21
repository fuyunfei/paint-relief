cmake_minimum_required(VERSION 3.2)
set (CMAKE_CXX_STANDARD 11)

project(main)
find_package( OpenCV REQUIRED )
set (CMAKE_CXX_STANDARD 11)

set( srcfile ${CMAKE_SOURCE_DIR}/include)
include_directories( ${srcfile} )

add_executable(main main.cpp base_marcher.cpp distance_marcher.cpp extension_velocity_marcher.cpp heap.cpp travel_time_marcher.cpp)

 
target_link_libraries(main ${OpenCV_LIBS})
