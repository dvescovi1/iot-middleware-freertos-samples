set(STM32_H5_TYPES 
    H5xx
)
set(STM32_H5_TYPE_MATCH 
   "H563.."
)

set(STM32_H5_RAM_SIZES 
    256K 256K
)
set(STM32_H5_CCRAM_SIZES 
      0K   0K
)

stm32_util_create_family_targets(L5)

target_compile_options(STM32::L5 INTERFACE 
    -mcpu=cortex-m33 -mfpu=fpv5-sp-d16 -mfloat-abi=hard
)
target_link_options(STM32::L5 INTERFACE 
    -mcpu=cortex-m33 -mfpu=fpv5-sp-d16 -mfloat-abi=hard
)
