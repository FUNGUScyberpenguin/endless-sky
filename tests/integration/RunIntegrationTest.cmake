set(TEST_CONFIG "${TEST_CONFIGS}/${test}")

# Clean the config folder of the integration test.
file(REMOVE_RECURSE "${TEST_CONFIG}")
file(COPY "${ES_CONFIG}" DESTINATION "${TEST_CONFIGS}")
file(RENAME "${TEST_CONFIGS}/config" "${TEST_CONFIG}")

# If the game was configured for offscreen rendering, ask SDL for its "offscreen"
# video driver, so that the test needs no display server.
if(ES_USE_OFFSCREEN)
    set(ES_LAUNCHER "${CMAKE_COMMAND}" -E env "SDL_VIDEODRIVER=offscreen")
endif()

# Run the integration test
execute_process(COMMAND ${ES_LAUNCHER} $ENV{ES_INTEGRATION_PREFIX} "${ES}" --config "${TEST_CONFIG}" --resources "${RESOURCE_PATH}" --test "${test}" ${DEBUG}
    OUTPUT_VARIABLE TEST_OUTPUT
    ERROR_VARIABLE TEST_OUTPUT
    RESULT_VARIABLE TEST_RESULT)

if(TEST_RESULT)
    string(STRIP "${TEST_OUTPUT}" TEST_OUTPUT_STRIPPED)
    message(FATAL_ERROR "Integration test failed with '${TEST_RESULT}':\n${TEST_OUTPUT_STRIPPED}")
endif()
