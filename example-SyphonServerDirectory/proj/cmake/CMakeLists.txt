cmake_minimum_required( VERSION 3.0 FATAL_ERROR )
set( CMAKE_VERBOSE_MAKEFILE ON )

project( SyphonServerDirectory )
set( APP_NAME "${PROJECT_NAME}App" )

get_filename_component( CINDER_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../../../../" ABSOLUTE )
get_filename_component( APP_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../" ABSOLUTE )

include( "${CINDER_PATH}/proj/cmake/modules/cinderMakeApp.cmake" )

ci_make_app(
	APP_NAME ${APP_NAME}
	SOURCES ${APP_PATH}/src/SyphonServerDirectoryApp.cpp
	CINDER_PATH ${CINDER_PATH}
	BLOCKS Cinder-Syphon
)

add_custom_command( TARGET ${APP_NAME} POST_BUILD
	COMMAND ${CMAKE_COMMAND} -E copy_directory
	${APP_PATH}/../lib/Syphon.framework
	${CMAKE_BUILD_TYPE}/${APP_NAME}/${APP_NAME}.app/Contents/Frameworks/Syphon.framework
)
