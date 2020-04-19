#include "stm32f10x_init.h"

#define HSE_FREQUENCY 8000000UL
#define FLASH_0_LATENCY_MAX_FREQ 24000000UL
#define FLASH_1_LATENCY_MAX_FREQ 48000000UL

uint32_t SystemCoreClock = HSE_FREQUENCY;

void SystemInit()
{}

void Flash_latency_init(){
    //Enable prefetch buffer
	FLASH->ACR |= FLASH_ACR_PRFTBE;
	while((FLASH->ACR & FLASH_ACR_PRFTBS)==0)
	{}	
    /*  Flash configuration of latency states
    *   - 0 wait states, if 0 < SYSCLK ≤ 24 MHz
    *   - 1 wait state, if 24 MHz < SYSCLK ≤ 48 MHz
    *   - 2 wait states, if 48 MHz < SYSCLK ≤ 72 MHz
    */
    if ((FLASH_0_LATENCY_MAX_FREQ<SystemCoreClock) && 
            (SystemCoreClock<=FLASH_1_LATENCY_MAX_FREQ)){
        MODIFY_REG(FLASH->ACR, FLASH_ACR_LATENCY,FLASH_ACR_LATENCY_1);
    }
    else if (FLASH_1_LATENCY_MAX_FREQ<SystemCoreClock){
        MODIFY_REG(FLASH->ACR, FLASH_ACR_LATENCY,FLASH_ACR_LATENCY_2);
    }
}
void HSE_clock_init(RCC_CFGR_TypeDef* _conf)
{
    //Change to HSE only if SYSCLK is currently set up to use HSI clock
    if(READ_BIT(RCC->CFGR, RCC_CFGR_SWS)==0){
        SystemCoreClock*= ((_conf->PLLMUL>>RCC_CFGR_PLLMULL_Pos)+2)/
            ((_conf->PLLXTPRE>>RCC_CFGR_PLLXTPRE_Pos)+1);

        //Call Flash_latency_init() only while MC clock is HSI
        if (SystemCoreClock>FLASH_0_LATENCY_MAX_FREQ || _conf->HPRE!=RCC_CFGR_HPRE_DIV1){
            Flash_latency_init();
        }
        //Switch from one clock source to another occurs only if the target clock source is ready
        SET_BIT(RCC->CR ,RCC_CR_HSEON);
        while(READ_BIT(RCC->CR, RCC_CR_HSERDY)==0)
        {}
        //Clock starting from PCLK1 and PCLK2 to AHB
        MODIFY_REG(RCC->CFGR,RCC_CFGR_PPRE2,_conf->PPRE2);
        MODIFY_REG(RCC->CFGR,RCC_CFGR_PPRE1,_conf->PPRE1);
        MODIFY_REG(RCC->CFGR,RCC_CFGR_HPRE,_conf->HPRE);
        
        //PLL configuration should be done before enabling PLL
        //Clock starting from HSE to SYSCLCK
        MODIFY_REG(RCC->CFGR,RCC_CFGR_PLLXTPRE,_conf->PLLXTPRE);
        SET_BIT(RCC->CFGR, RCC_CFGR_PLLSRC);   
        MODIFY_REG(RCC->CFGR,RCC_CFGR_PLLMULL,_conf->PLLMUL);
        
        //PLL turned on only after PLL configuration is done
        SET_BIT(RCC->CR, RCC_CR_PLLON);
        while(READ_BIT(RCC->CR, RCC_CR_PLLRDY)==0)
        {}

        //Change system clock and check SWS indication if SW configuration is applied
        MODIFY_REG(RCC->CFGR,RCC_CFGR_SW,RCC_CFGR_SW_PLL);
        while(READ_BIT(RCC->CFGR, RCC_CFGR_SWS_PLL)==0)
        {}
    }
    else{
        //TODO: process ERRORS
    }
    
}