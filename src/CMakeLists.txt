# 收集源文件
file(GLOB_RECURSE APP_SOURCES "*.c" "*.cpp")
file(GLOB_RECURSE STARTUP_SOURCES "${CMAKE_SOURCE_DIR}/startup/*.s")

# 定义可执行文件 (ELF)
add_executable(${PROJECT_NAME}.elf 
    ${APP_SOURCES} 
    ${STARTUP_SOURCES}
)

# 包含头文件路径
target_include_directories(${PROJECT_NAME}.elf PRIVATE
    .
)
    # ${CMAKE_SOURCE_DIR}/drivers/inc
    # ${CMAKE_SOURCE_DIR}/cmsis/inc

# 链接驱动库 (如果在 drivers/CMakeLists.txt 中定义了库)
# target_link_libraries(${PROJECT_NAME}.elf PRIVATE my_drivers)

# ==========================================
# 链接器配置 (最关键的一步)
# ==========================================
set(LINKER_SCRIPT "${CMAKE_SOURCE_DIR}/ld/stm32f407.ld")

target_link_options(${PROJECT_NAME}.elf PRIVATE
    ${CPU_FLAGS}
    -T${LINKER_SCRIPT}
    -Wl,-Map=${PROJECT_NAME}.map     # 生成 Map 文件
    -Wl,--gc-sections                # 删除未使用的函数
    -Wl,--print-memory-usage         # 打印内存占用
    --specs=nano.specs               # 使用由 Newlib 提供的轻量级 C 库
    --specs=nosys.specs              # 不使用系统调用
)

# ==========================================
# 生成 BIN 和 HEX 文件
# ==========================================
add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
    COMMAND arm-none-eabi-objcopy -O binary ${PROJECT_NAME}.elf ${PROJECT_NAME}.bin
    COMMAND arm-none-eabi-objcopy -O ihex ${PROJECT_NAME}.elf ${PROJECT_NAME}.hex
    COMMENT "Building ${PROJECT_NAME}.bin and ${PROJECT_NAME}.hex"
)