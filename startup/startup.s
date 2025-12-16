.syntax unified
.cpu cortex-m4
.fpu softvfp
.thumb

.global Reset_Handler
.global Default_Handler

/* 引入链接脚本中定义的符号 */
.word _sidata
.word _sdata
.word _edata
.word _sbss
.word _ebss

/* * 1. 中断向量表 
 *必须放在 Flash 的起始位置 (0x08000000)
 */
.section .isr_vector, "a", %progbits
.type g_pfnVectors, %object
.size g_pfnVectors, .-g_pfnVectors

g_pfnVectors:
  .word _estack             /* 栈顶地址 */
  .word Reset_Handler       /* 复位处理函数 */
  .word NMI_Handler
  .word HardFault_Handler
  /* ... 剩下的中断这里省略，简易版只需保证能复位 ... */

/* * 2. 复位处理函数 (程序入口)
 */
.section .text.Reset_Handler
.weak Reset_Handler
.type Reset_Handler, %function

Reset_Handler:
  /* 设置栈指针 (可选，硬件Reset通常会自动加载，但显式设置更安全) */
  ldr   sp, =_estack

/* 将 .data 段从 Flash 复制到 RAM */
CopyDataInit:
  ldr   r0, =_sdata       /* 目标地址 (RAM) */
  ldr   r3, =_edata       /* 结束地址 (RAM) */
  ldr   r2, =_sidata      /* 源地址 (Flash) */
  cmp   r0, r3            /* 如果没有数据需要复制 */
  beq   ZeroBssInit

LoopCopyDataInit:
  ldr   r1, [r2], #4      /* 从 Flash 读 */
  str   r1, [r0], #4      /* 写入 RAM */
  cmp   r0, r3
  bcc   LoopCopyDataInit

/* 将 .bss 段清零 */
ZeroBssInit:
  ldr   r2, =_sbss
  ldr   r3, =_ebss
  movs  r0, #0
  cmp   r2, r3
  beq   CallMain

LoopZeroBss:
  str   r0, [r2], #4
  cmp   r2, r3
  bcc   LoopZeroBss

/* 调用 Main 函数 */
CallMain:
  bl    SystemInit        /* 标准CMSIS通常需要这个，下面Main里会提供空实现 */
  bl    main

/* 死循环，防止 main 返回 */
LoopForever:
  b     LoopForever

/* * 3. 默认中断处理 (死循环) 
 */
.section .text.Default_Handler, "ax", %progbits
Default_Handler:
Infinite_Loop:
  b     Infinite_Loop

/* 定义弱符号，以便在C代码中覆盖 */
.weak NMI_Handler
.thumb_set NMI_Handler, Default_Handler

.weak HardFault_Handler
.thumb_set HardFault_Handler, Default_Handler