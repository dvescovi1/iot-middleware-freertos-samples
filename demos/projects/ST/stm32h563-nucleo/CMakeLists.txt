# Copyright (c) Microsoft Corporation. All rights reserved.
# SPDX-License-Identifier: MIT

stm32_fetch_cube(H5)
lwip_fetch()

find_package(CMSIS COMPONENTS STM32H563ZI REQUIRED)
find_package(HAL COMPONENTS STM32H563ZI REQUIRED)
find_package(BSP COMPONENTS STM32H563ZI-NUCLEO REQUIRED)
find_package(LWIP)

# set parent scope path
set(BOARD_DEMO_CONFIG_PATH ${CMAKE_CURRENT_SOURCE_DIR}/config CACHE INTERNAL "Config path")
set(BOARD_DEMO_PORT_PATH ${CMAKE_CURRENT_SOURCE_DIR}/port CACHE INTERNAL "Port path")
set(BOARD_DEMO_FREERTOS_PORT_PATH ${FreeRTOS_ARM_CM33_NTZ_PATH} CACHE INTERNAL "FreeRTOS Port used ")
#set(BOARD_DEMO_FREERTOS_PORT_PATH ${FreeRTOS_ARM_CM7_PATH} CACHE INTERNAL "FreeRTOS Port used ")

include(${CMAKE_CURRENT_SOURCE_DIR}/gcc_flags.cmake)

include_directories(${BOARD_DEMO_CONFIG_PATH})
include_directories(port)

file(GLOB STCODE_SOURCES st_code/*.c)
file(GLOB LWIP_PORT_SOURCES
    st_code/lwip/App/*.c
    st_code/lwip/Target/*.c
    st_code/lwip/system/*.c)

set(PROJECT_SOURCES
    ${LWIP_PORT_SOURCES}
    ${STCODE_SOURCES}
    main.c)

stm32_add_linker_script(CMSIS::STM32::H5 INTERFACE
    "${CMAKE_CURRENT_SOURCE_DIR}/STM32H563xx_FLASH.ld")
add_executable(${PROJECT_NAME} ${PROJECT_SOURCES})
target_include_directories(${PROJECT_NAME} PUBLIC
    .
    st_code
    st_code/lwip/App
    st_code/lwip/Target
    st_code/lwip/system)
target_link_libraries(${PROJECT_NAME} PRIVATE
    FreeRTOS::Timers
    FreeRTOS::Heap::5
    FreeRTOS::ARM_CM33
    FreeRTOSPlus::Utilities::backoff_algorithm
    FreeRTOSPlus::Utilities::logging
    FreeRTOSPlus::ThirdParty::mbedtls
    LWIP
    HAL::STM32::H5::RCC
    HAL::STM32::H5::RCCEx
#    HAL::STM32::H5::SPI
#    HAL::STM32::H5::RTC
#    HAL::STM32::H5::UART
#    HAL::STM32::H5::DMA
    HAL::STM32::H5::PWR
    HAL::STM32::H5::PWREx
    HAL::STM32::H5::GPIO
    HAL::STM32::H5::CORTEX
#    HAL::STM32::H5::RNG
    HAL::STM32::H5::TIM
#    HAL::STM32::H5::TIMEx
#    HAL::STM32::H5::UARTEx
    CMSIS::STM32::H5xx
    STM32::NoSys
    az::iot_middleware::freertos
    HAL::STM32::H5::ETH
#    BSP::STM32::H5::LAN8742
    SAMPLE::AZUREIOT
    SAMPLE::COMMON::CONNECTION
    SAMPLE::TRANSPORT::MBEDTLS
    SAMPLE::SOCKET::LWIP)

add_map_file(${PROJECT_NAME} ${PROJECT_NAME}.map)

add_custom_command(TARGET ${PROJECT_NAME}
    # Run after all other rules within the target have been executed
    POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -Obinary $<TARGET_FILE:${PROJECT_NAME}> ${PROJECT_NAME}.bin
    COMMENT "Generate Bin file"
    VERBATIM)

# PnP Sample
add_executable(${PROJECT_NAME}-pnp ${PROJECT_SOURCES})
target_include_directories(${PROJECT_NAME}-pnp PUBLIC
    .
    st_code
    st_code/lwip/App
    st_code/lwip/Target
    st_code/lwip/system)
target_link_libraries(${PROJECT_NAME}-pnp PRIVATE
    FreeRTOS::Timers
    FreeRTOS::Heap::5
    FreeRTOS::ARM_CM33
    FreeRTOSPlus::Utilities::backoff_algorithm
    FreeRTOSPlus::Utilities::logging
    FreeRTOSPlus::ThirdParty::mbedtls
    LWIP
    HAL::STM32::H5::RCC
    HAL::STM32::H5::RCCEx
#    HAL::STM32::H5::SPI
#    HAL::STM32::H5::RTC
#    HAL::STM32::H5::UART
#    HAL::STM32::H5::DMA
    HAL::STM32::H5::PWR
    HAL::STM32::H5::PWREx
    HAL::STM32::H5::GPIO
    HAL::STM32::H5::CORTEX
#    HAL::STM32::H5::RNG
    HAL::STM32::H5::TIM
    HAL::STM32::H5::TIMEx
#    HAL::STM32::H5::UARTEx
    CMSIS::STM32::H5xx
    STM32::Nano
    STM32::Nano::FloatScan
    STM32::Nano::FloatPrint
    az::iot_middleware::freertos
    HAL::STM32::H5::ETH
#    BSP::STM32::H5::LAN8742
    SAMPLE::AZUREIOTPNP
    SAMPLE::COMMON::CONNECTION
    SAMPLE::TRANSPORT::MBEDTLS
    SAMPLE::SOCKET::LWIP)

add_map_file(${PROJECT_NAME}-pnp ${PROJECT_NAME}-pnp.map)

add_custom_command(TARGET ${PROJECT_NAME}-pnp
    # Run after all other rules within the target have been executed
    POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -Obinary $<TARGET_FILE:${PROJECT_NAME}-pnp> ${PROJECT_NAME}-pnp.bin
    COMMENT "Generate Bin file"
    VERBATIM)

# ADU Sample
add_executable(${PROJECT_NAME}-adu
    ${PROJECT_SOURCES}
    ${CMAKE_CURRENT_LIST_DIR}/port/azure_iot_flash_platform.c
)
target_include_directories(${PROJECT_NAME}-adu PUBLIC
    .
    st_code
    st_code/lwip/App
    st_code/lwip/Target
    st_code/lwip/system)
target_link_libraries(${PROJECT_NAME}-adu PRIVATE
    FreeRTOS::Timers
    FreeRTOS::Heap::5
    FreeRTOS::ARM_CM33
    FreeRTOSPlus::Utilities::backoff_algorithm
    FreeRTOSPlus::Utilities::logging
    FreeRTOSPlus::ThirdParty::mbedtls
    LWIP
    HAL::STM32::H5::RCC
    HAL::STM32::H5::RCCEx
#    HAL::STM32::H5::SPI
#    HAL::STM32::H5::RTC
#    HAL::STM32::H5::UART
#    HAL::STM32::H5::DMA
    HAL::STM32::H5::PWR
    HAL::STM32::H5::PWREx
    HAL::STM32::H5::GPIO
    HAL::STM32::H5::CORTEX
#    HAL::STM32::H5::RNG
    HAL::STM32::H5::TIM
    HAL::STM32::H5::TIMEx
#    HAL::STM32::H5::UARTEx
    CMSIS::STM32::H5xx
    STM32::Nano
    STM32::Nano::FloatScan
    STM32::Nano::FloatPrint
    az::iot_middleware::freertos
    az::iot_middleware::core_http
    HAL::STM32::H5::ETH
#    BSP::STM32::H5::LAN8742
    SAMPLE::AZUREIOTADU
    SAMPLE::COMMON::CONNECTION
    SAMPLE::TRANSPORT::MBEDTLS
    SAMPLE::SOCKET::LWIP)

add_map_file(${PROJECT_NAME}-adu ${PROJECT_NAME}-adu.map)

add_custom_command(TARGET ${PROJECT_NAME}-adu
    # Run after all other rules within the target have been executed
    POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -Obinary $<TARGET_FILE:${PROJECT_NAME}-adu> ${PROJECT_NAME}-adu.bin
    COMMENT "Generate Bin file"
    VERBATIM)
