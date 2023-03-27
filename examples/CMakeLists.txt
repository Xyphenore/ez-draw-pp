cmake_minimum_required(VERSION 3.16.3..3.24.2)

# --------------------------------------------
# Configure the config
# --------------------------------------------

configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/config.hpp.in
    ${CMAKE_CURRENT_BINARY_DIR}/config.hpp @ONLY
)

# --------------------------------------------
# Create all demos
# --------------------------------------------

add_executable(demo01 "${CMAKE_CURRENT_SOURCE_DIR}/demo++01.cpp")
target_link_libraries(demo01 ez-draw-pp)

add_executable(demo02 "${CMAKE_CURRENT_SOURCE_DIR}/demo++02.cpp")
target_link_libraries(demo02 ez-draw-pp)

add_executable(demo03 "${CMAKE_CURRENT_SOURCE_DIR}/demo++03.cpp")
target_link_libraries(demo03 ez-draw-pp)

add_executable(demo04 "${CMAKE_CURRENT_SOURCE_DIR}/demo++04.cpp")
target_link_libraries(demo04 ez-draw-pp)

add_executable(demo05 "${CMAKE_CURRENT_SOURCE_DIR}/demo++05.cpp")
target_link_libraries(demo05 ez-draw-pp)

add_executable(demo06 "${CMAKE_CURRENT_SOURCE_DIR}/demo++06.cpp")
target_link_libraries(demo06 ez-draw-pp)

add_executable(demo07 "${CMAKE_CURRENT_SOURCE_DIR}/demo++07.cpp")
target_link_libraries(demo07 ez-draw-pp)

add_executable(demo08 "${CMAKE_CURRENT_SOURCE_DIR}/demo++08.cpp")
target_link_libraries(demo08 ez-draw-pp)

add_executable(demo10 "${CMAKE_CURRENT_SOURCE_DIR}/demo++10.cpp")
target_link_libraries(demo10 ez-draw-pp)

add_executable(demo11 "${CMAKE_CURRENT_SOURCE_DIR}/demo++11.cpp")
target_link_libraries(demo11 ez-draw-pp)

add_executable(demo12 "${CMAKE_CURRENT_SOURCE_DIR}/demo++12.cpp")
target_link_libraries(demo12 ez-draw-pp)

add_executable(demo13 "${CMAKE_CURRENT_SOURCE_DIR}/demo++13.cpp")
target_include_directories(demo13 BEFORE PRIVATE ${CMAKE_CURRENT_BINARY_DIR})
target_link_libraries(demo13 ez-draw-pp)

add_executable(demo14 "${CMAKE_CURRENT_SOURCE_DIR}/demo++14.cpp")
target_include_directories(demo14 BEFORE PRIVATE ${CMAKE_CURRENT_BINARY_DIR})
target_link_libraries(demo14 ez-draw-pp)

add_executable(demo15 "${CMAKE_CURRENT_SOURCE_DIR}/demo++15.cpp")
target_include_directories(demo15 BEFORE PRIVATE ${CMAKE_CURRENT_BINARY_DIR})
target_link_libraries(demo15 ez-draw-pp)

add_executable(demo17 "${CMAKE_CURRENT_SOURCE_DIR}/demo++17.cpp")
target_include_directories(demo17 BEFORE PRIVATE ${CMAKE_CURRENT_BINARY_DIR})
target_link_libraries(demo17 ez-draw-pp)

add_executable(tracer "${CMAKE_CURRENT_SOURCE_DIR}/tracer.cpp")
target_link_libraries(tracer ez-draw-pp)
