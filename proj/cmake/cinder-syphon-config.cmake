if ( NOT TARGET Cinder-Syphon )
	get_filename_component( CINDER_SYPHON_PATH "${CMAKE_CURRENT_LIST_DIR}/../.." ABSOLUTE )
    get_filename_component( CINDER_PATH "${CMAKE_CURRENT_LIST_DIR}/../../../.." ABSOLUTE )

	set( CINDER_SYPHON_INCLUDES
		${CINDER_SYPHON_PATH}/src
		${CINDER_SYPHON_PATH}/lib
	)
	set( CINDER_SYPHON_SOURCES
		${CINDER_SYPHON_PATH}/lib/SyphonNameboundClient.m
		${CINDER_SYPHON_PATH}/src/syphonClient.mm
		${CINDER_SYPHON_PATH}/src/syphonServer.mm
		${CINDER_SYPHON_PATH}/src/syphonServerDirectory.mm
	)
	set_source_files_properties( ${CINDER_SYPHON_SOURCES}
		PROPERTIES COMPILE_FLAGS "-x objective-c++"
	)
	set( CINDER_SYPHON_LIBRARIES
		${CINDER_SYPHON_PATH}/lib/Syphon.framework
	)

	add_library( Cinder-Syphon ${CINDER_SYPHON_SOURCES} )
	target_link_libraries( Cinder-Syphon PUBLIC ${CINDER_SYPHON_LIBRARIES} )

	target_include_directories( Cinder-Syphon PUBLIC "${CINDER_SYPHON_INCLUDES}" )
	target_include_directories( Cinder-Syphon SYSTEM BEFORE PUBLIC "${CINDER_PATH}/include" )

    if ( NOT TARGET cinder )
		include( "${CINDER_PATH}/proj/cmake/configure.cmake" )
		find_package( cinder REQUIRED PATHS
			"${CINDER_PATH}/${CINDER_LIB_DIRECTORY}"
			"$ENV{CINDER_PATH}/${CINDER_LIB_DIRECTORY}" )
    endif()
	target_link_libraries( Cinder-Syphon PRIVATE cinder )
endif()
