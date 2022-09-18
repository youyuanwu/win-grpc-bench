# download release of hgz

message(STATUS "feching hgz")
include(FetchContent)
FetchContent_Declare(hgz
  URL      https://github.com/bojand/ghz/releases/download/v0.110.0/ghz-windows-x86_64.zip
  URL_HASH SHA256=3b28fdbb73bede09f0c2400e56f4d6fdf91434f32c2c5fc419181e7b1030601c
)
FetchContent_GetProperties(hgz)
if(NOT hgz_POPULATED)
  FetchContent_Populate(hgz)
endif()