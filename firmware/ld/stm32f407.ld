/* 入口点，对应 startup.s 中的 Reset_Handler */
ENTRY(Reset_Handler)

/* 栈顶地址：SRAM 的结束地址 (SRAM 起始 0x20000000 + 128K) */
_estack = 0x20020000;

/* 内存区域定义 */
MEMORY
{
    FLASH (rx)      : ORIGIN = 0x08000000, LENGTH = 1024K
    RAM   (xrw)     : ORIGIN = 0x20000000, LENGTH = 128K
}

SECTIONS
{
    /* 1. 中断向量表放在 Flash 开头 */
    .isr_vector :
    {
        . = ALIGN(4);
        KEEP(*(.isr_vector)) /* 即使未被引用也强制保留 */
        . = ALIGN(4);
    } > FLASH

    /* 2. 程序代码段 (.text) */
    .text :
    {
        . = ALIGN(4);
        *(.text)           /* 所有的 .text 段 */
        *(.text*)          /* 所有的 .text* 子段 */
        *(.rodata)         /* 只读数据 (常量) */
        *(.rodata*)
        . = ALIGN(4);
        _etext = .;        /* 记录代码段结束地址 (用于数据搬运) */
    } > FLASH

    /* 3. 已初始化数据段 (.data) */
    /* 该段需从 Flash (LMA) 加载，但运行在 RAM (VMA) */
    _sidata = LOADADDR(.data);

    .data :
    {
        . = ALIGN(4);
        _sdata = .;        /* 数据段在 RAM 中的开始地址 */
        *(.data)
        *(.data*)
        . = ALIGN(4);
        _edata = .;        /* 数据段在 RAM 中的结束地址 */
    } > RAM AT> FLASH

    /* 4. 未初始化数据段 (.bss) - 需要清零 */
    .bss :
    {
        . = ALIGN(4);
        _sbss = .;         /* bss 开始 */
        __bss_start__ = _sbss;
        *(.bss)
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        _ebss = .;         /* bss 结束 */
        __bss_end__ = _ebss;
    } > RAM
}