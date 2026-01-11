
```
project-root/
├── CMakeLists.txt             # 顶层 CMake，控制编译开关 (BUILD_TESTING / BUILD_FIRMWARE)
├── include/                   # 【新增】公共头文件（对外接口）
│   ├── core/                  # 核心逻辑接口
│   └── hal/                   # 硬件抽象层接口 (hal_gpio.h, hal_i2c.h)
├── src/
│   ├── core/                  # 纯逻辑实现 (.c)
│   ├── hal/                   # MCU 硬件驱动实现 (hal_gpio_stm32.c)
│   └── app/                   # 应用层逻辑
├── firmware/                  # 固件构建入口
│   ├── CMakeLists.txt         # 生成 .elf / .hex
│   ├── main.c                 # 真实的 main 函数，负责硬件初始化和调用 app
│   └── linker/                # .ld 链接脚本
├── tests/
│   ├── CMakeLists.txt         # 测试总入口
│   ├── mocks/                 # 【新增】存放 CMock 生成的假对象或手写的桩
│   ├── unit/                  # Unity (PC端)
│   │   ├── test_hash.c
│   │   └── test_protocol.c
│   └── hil/                   # pytest + USB adapter
│       ├── requirements.txt   # 【新增】Python 依赖列表
│       ├── conftest.py
│       └── test_spi.py
├── scripts/
└── ci/
```
