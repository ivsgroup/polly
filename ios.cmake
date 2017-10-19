# Copyright (c) 2016, Ruslan Baratov
# All rights reserved.

if(DEFINED POLLY_IOS_CMAKE_)
  return()
else()
  set(POLLY_IOS_CMAKE_ 1)
endif()

include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_module_path.cmake")
include(polly_clear_environment_variables)
include(polly_init)
include("${CMAKE_CURRENT_LIST_DIR}/os/iphone-default-sdk.cmake") # -> IOS_SDK_VERSION

set(POLLY_XCODE_COMPILER "clang")
polly_init(
  "iOS ${IOS_SDK_VERSION} Universal (iphoneos + iphonesimulator) / \
${POLLY_XCODE_COMPILER} / \
c++14 support"
  "Xcode"
)

include(polly_common)
include(polly_fatal_error)

# # Fix try_compile
include(polly_ios_bundle_identifier)
set(CMAKE_MACOSX_BUNDLE YES)

set(CMAKE_XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "iPhone Developer")

# 32 bits support was dropped from iPhoneSdk11.0
if(IOS_SDK_VERSION VERSION_LESS "11.0")

  # ivs patch : drop armv7s support
  # because Qt5 does not support it : http://doc.qt.io/qt-5/supported-platforms.html
  # Note : armv7s is just a small optim on armv7, and armv7s devices can run armv7 code
  # (all of this is also legacy since apple dropped 3é bits support as of iOS 11, and 
  # arm64 is the only supported platform)
  # set(IPHONEOS_ARCHS armv7;armv7s;arm64)
  set(IPHONEOS_ARCHS armv7;arm64)

  set(IPHONESIMULATOR_ARCHS i386;x86_64)
else()
  polly_status_debug("iPhone11.0+ SDK detected, forcing 64 bits builds.")
  set(IPHONEOS_ARCHS arm64)
  set(IPHONESIMULATOR_ARCHS x86_64)
endif()

include("${CMAKE_CURRENT_LIST_DIR}/compiler/xcode.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/os/iphone.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/flags/cxx14.cmake")

if(NOT IOS_SDK_VERSION VERSION_LESS 10.0)
  include(polly_ios_development_team)
endif()
