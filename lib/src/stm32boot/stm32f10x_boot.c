/*Based on:
* File Name          : stm32f10x_vector.c
* Author             : MCD Application Team
* Version            : V1.0
* Date               : 10/08/2007
*/

/******************************************************************************
* File Name          : stm32f10x_vector.c
* Author             : Balancing-bot
* Version            : V1.0
* Date               : 31/03/2020
* Description        : This file contains the vector table for STM32F10x.
*                      After Reset the Cortex-M3 processor is in Thread mode,
*                      priority is Privileged, and the Stack is set to Main.
*******************************************************************************/

/* Includes ------------------------------------------------------------------*/
#include "stm32f10x_it.h"

/* Exported types ------------------------------------------------------------*/
/* Exported constants --------------------------------------------------------*/
extern unsigned long _etext;
extern unsigned long _sidata;		/* start address for the initialization values
                                   of the .data section. defined in linker script */
extern unsigned long _sdata;		/* start address for the .data section. defined
                                   in linker script */
extern unsigned long _edata;		/* end address for the .data section. defined in
                                   linker script */

extern unsigned long _sbss;			/* start address for the .bss section. defined
                                   in linker script */
extern unsigned long _ebss;			/* end address for the .bss section. defined in
                                   linker script */

extern void _estack;		/* init value for the stack pointer. defined in linker script */



/* Private typedef -----------------------------------------------------------*/
/* function prototypes -------------------------------------------------------*/
void Reset_Handler(void) __attribute__((__interrupt__));
extern int main(void);


/*******************************************************************************
*
* The minimal vector table for a Cortex M3.  Note that the proper constructs
* must be placed on this to ensure that it ends up at physical address
* 0x0000.0000.
*
*******************************************************************************/


__attribute__ ((section(".init_vector")))
void (* const vector_table[])(void) =
{
    &_estack,            // The initial stack pointer
    Reset_Handler,       // Reset Handler
    NMI_Handler,         // NMI Handler
    HardFault_Handler,   // Hard Fault Handler
    MemManage_Handler,   // MPU Fault Handler
    BusFault_Handler,    // Bus Fault Handler
    UsageFault_Handler,  // Usage Fault Handler
    0,                   // Reserved
    0,                   // Reserved
    0,                   // Reserved
    0,                   // Reserved
    SVC_Handler,         // SVCall Handler
    DebugMon_Handler,    // Debug Monitor Handler
    0,                   // Reserved
    PendSV_Handler,      // PendSV Handler
    SysTick_Handler,     // SysTick Handler

    // External Interrupts
    WWDG_IRQHandler,            // Window Watchdog
    PVD_IRQHandler,             // PVD through EXTI Line detect
    TAMPER_IRQHandler,          // Tamper
    RTC_IRQHandler,             // RTC
    FLASH_IRQHandler,           // Flash
    RCC_IRQHandler,             // RCC
    EXTI0_IRQHandler,           // EXTI Line 0
    EXTI1_IRQHandler,           // EXTI Line 1
    EXTI2_IRQHandler,           // EXTI Line 2
    EXTI3_IRQHandler,           // EXTI Line 3
    EXTI4_IRQHandler,           // EXTI Line 4
    DMA1_Channel1_IRQHandler,   // DMA1 Channel 1
    DMA1_Channel2_IRQHandler,   // DMA1 Channel 2
    DMA1_Channel3_IRQHandler,   // DMA1 Channel 3
    DMA1_Channel4_IRQHandler,   // DMA1 Channel 4
    DMA1_Channel5_IRQHandler,   // DMA1 Channel 5
    DMA1_Channel6_IRQHandler,   // DMA1 Channel 6
    DMA1_Channel7_IRQHandler,   // DMA1 Channel 7
    ADC1_2_IRQHandler,          // ADC1_2
    USB_HP_CAN1_TX_IRQHandler,  // USB High Priority or CAN1 TX
    USB_LP_CAN1_RX0_IRQHandler, // USB Low  Priority or CAN1 RX0
    CAN1_RX1_IRQHandler,        // CAN1 RX1
    CAN1_SCE_IRQHandler,        // CAN1 SCE
    EXTI9_5_IRQHandler,         // EXTI Line 9..5
    TIM1_BRK_IRQHandler,        // TIM1 Break
    TIM1_UP_IRQHandler,         // TIM1 Update
    TIM1_TRG_COM_IRQHandler,    // TIM1 Trigger and Commutation
    TIM1_CC_IRQHandler,         // TIM1 Capture Compare
    TIM2_IRQHandler,            // TIM2
    TIM3_IRQHandler,            // TIM3
    TIM4_IRQHandler,            // TIM4
    I2C1_EV_IRQHandler,         // I2C1 Event
    I2C1_ER_IRQHandler,         // I2C1 Error
    I2C2_EV_IRQHandler,         // I2C2 Event
    I2C2_ER_IRQHandler,         // I2C2 Error
    SPI1_IRQHandler,            // SPI1
    SPI2_IRQHandler,            // SPI2
    USART1_IRQHandler,          // USART1
    USART2_IRQHandler,          // USART2
    USART3_IRQHandler,          // USART3
    EXTI15_10_IRQHandler,       // EXTI Line 15..10
    RTCAlarm_IRQHandler,        // RTC Alarm through EXTI Line
    USBWakeUp_IRQHandler,       // USB Wakeup from suspend
  //(unsigned short)0xF108F85F //this is a workaround for boot in RAM mode.
};

/*******************************************************************************
* Function Name  : Reset_Handler
* Description    : This is the code that gets called when the processor first
*                  starts execution following a reset event. Only the absolutely
*                  necessary set is performed, after which the application
*                  supplied main() routine is called. 
* Input          :
* Output         :
* Return         :
*******************************************************************************/
void Reset_Handler(void)
{
    unsigned long *src, *dest;

    //
    // Copy the data segment initializers from flash to SRAM.
    //
    src = &_sidata;
    for(dest = &_sdata; dest < &_edata; )
    {
        *(dest++) = *(src++);
    }

    //
    // Zero fill the bss segment.
    //
    for(dest = &_sbss; dest < &_ebss; )
    {
        *(dest++) = 0;
    }

    //
    // Call the application's entry point.
    //
    main();
}


/****************** (C) COPYRIGHT 2007 STMicroelectronics  *****END OF FILE****/



