#ifndef __STM32F10x_INIT_H
#define __STM32F10x_INIT_H

#include <stm32f1xx.h> /* Standart headhers*/

extern uint32_t SystemCoreClock;          /*!< System Clock Frequency (Core Clock) */
/***
	Structure for passing the parameters to 
	clock init functions
	This way we can initialize clock different
	every time
***/
typedef struct {
	uint32_t PLLMUL;
	uint32_t HPRE;
	uint32_t PPRE1;
	uint32_t PPRE2;
	uint32_t PLLXTPRE;
} RCC_CFGR_TypeDef;

/* Initialize clock configuration
	HSE clock (8MHz)
	HSE divider for PLL entry -not devided
	PLL multiplication set 
	AHB prescaler-not devided
	APB1(low speed) devided 
	APB2(high speed) not devided	
*/
void HSE_clock_init(RCC_CFGR_TypeDef* _conf);




#ifndef __NO_SYSTEM_INIT
void SystemInit();
#endif

#endif /* __STM32F10x_INIT_H */