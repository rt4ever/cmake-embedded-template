#include <stdint.h>

/* ==========================================
 * 纯手工寄存器定义 (Bare Metal)
 * ========================================== */

// 1. 基地址
#define PERIPH_BASE 0x40000000UL
#define AHB1PERIPH_BASE (PERIPH_BASE + 0x00020000UL)

// 2. RCC (Reset and Clock Control) - 用于开时钟
#define RCC_BASE (AHB1PERIPH_BASE + 0x3800UL)
#define RCC_AHB1ENR (*((volatile uint32_t *)(RCC_BASE + 0x30)))

// 3. GPIOD (LEDs on PD12, PD13, PD14, PD15 for F4 Discovery)
#define GPIOD_BASE (AHB1PERIPH_BASE + 0x0C00UL)
#define GPIOD_MODER (*((volatile uint32_t *)(GPIOD_BASE + 0x00)))
#define GPIOD_ODR (*((volatile uint32_t *)(GPIOD_BASE + 0x14)))

// 位定义
#define RCC_AHB1ENR_GPIODEN (1 << 3)   // Enable Port D Clock
#define GPIO_MODER_MODER12_0 (1 << 24) // Pin 12 Output mode
#define GPIO_PIN_12 (1 << 12)

/* * 必须实现 SystemInit，因为 startup.s 调用了它。
 * 在完整工程中，这里配置 PLL 和 Flash 延迟。
 * 在最简工程中，我们可以留空（默认使用内部 HSI 16MHz 时钟）。
 */
void SystemInit(void) {
  // Do nothing, minimal usage.
  // FPU setting is usually done here too.
}

/* 简单延时 */
void delay(uint32_t count) {
  while (count--) {
    __asm("nop");
  }
}

int main(void) {
  // 1. 开启 GPIOD 时钟
  RCC_AHB1ENR |= RCC_AHB1ENR_GPIODEN;

  // 2. 配置 PD12 为通用输出模式 (General Purpose Output)
  // 先清零，再设置对应位 (MODER12[1:0] = 01)
  GPIOD_MODER &= ~(0x3 << 24);
  GPIOD_MODER |= GPIO_MODER_MODER12_0;

  while (1) {
    // 3. 翻转 PD12 (XOR 操作)
    GPIOD_ODR ^= GPIO_PIN_12;

    // 4. 延时
    delay(500000);
  }

  return 0;
}