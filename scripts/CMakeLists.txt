
add_test(
  NAME win_grpc_bench
  COMMAND Powershell.exe ".\\scripts\\bench.ps1 -ExePath $<TARGET_FILE:win_grpc_main>"
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)

add_test(
  NAME grpc_mt_bench 
  COMMAND Powershell.exe ".\\scripts\\bench.ps1 -Flavour grpc_mt -ExePath $<TARGET_FILE:grpc_mt_main>"
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)

set_tests_properties(win_grpc_bench grpc_mt_bench  PROPERTIES RUN_SERIAL TRUE)
