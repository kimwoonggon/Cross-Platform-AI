cmake_minimum_required(VERSION 3.24)
project(CrossPlatformAI_08_13 LANGUAGES CXX)
enable_testing()
set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set_property(DIRECTORY PROPERTY VS_STARTUP_PROJECT compute_shader_example)

set(chapters
    08-compute-shader
    09-compute-pipeline
    10-command-buffers
    11-dispatch-synchronization
    12-staging-buffers
    13-multiple-dispatches)
set(targets
    compute_shader_example
    compute_pipeline_example
    command_buffers_example
    dispatch_synchronization_example
    staging_buffers_example
    multiple_dispatches_example)

foreach(index RANGE 0 5)
    list(GET chapters ${index} chapter)
    list(GET targets ${index} target)
    add_subdirectory(examples/${chapter})
    set_target_properties(${target} PROPERTIES
        FOLDER "${chapter}"
        VS_DEBUGGER_WORKING_DIRECTORY "$<TARGET_FILE_DIR:${target}>"
        VS_DEBUGGER_ENVIRONMENT "VK_LAYER_PATH=${Vulkan_INCLUDE_DIR}/../Bin")
    add_test(NAME ${chapter}_starter_smoke COMMAND $<TARGET_FILE:${target}>)
    set_tests_properties(${chapter}_starter_smoke PROPERTIES
        TIMEOUT 30
        ENVIRONMENT "VK_LAYER_PATH=${Vulkan_INCLUDE_DIR}/../Bin"
        FAIL_REGULAR_EXPRESSION "VUID-|SYNC-HAZARD")
endforeach()
