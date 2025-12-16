cmake_minimum_required(VERSION 3.15)

# 在 project 之前指定工具链文件
set(CMAKE_TOOLCHAIN_FILE "${CMAKE_SOURCE_DIR}/cmake/arm-none-eabi.cmake")

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

project(cmake-embedded-tempalte LANGUAGES C CXX ASM)

# ==========================================
# 1. 芯片架构配置 (根据 M3 或 M4 修改这里)
# ==========================================
# Cortex-M3 示例 (如 STM32F103)
# set(CPU_FLAGS "-mcpu=cortex-m3 -mthumb")

# Cortex-M4F 示例 (如 STM32F407，带浮点单元)
set(CPU_FLAGS -mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard)

# ==========================================
# 2. 全局编译选项
# ==========================================
add_compile_options(
    ${CPU_FLAGS}
    -Wall -Wextra
    -fdata-sections -ffunction-sections  # 配合链接器的 --gc-sections 删除无用代码
    -g3                                  # 生成调试信息
    -O0                                  # 调试建议 O0，发布改 O2/Os
)

# 定义宏 (如 STM32 常用宏)
# add_definitions(
#     -DSTM32F407xx
#     -DUSE_HAL_DRIVER
# )

# ==========================================
# 3. 包含子模块
# ==========================================
# add_subdirectory(drivers)
add_subdirectory(src)

