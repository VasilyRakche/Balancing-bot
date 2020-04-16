// By Wolfgang Wieser, heavily based on:
// http://fun-tech.se/stm32/OlimexBlinky/mini.php
#include <stdlib.h>
#include <stm32f10x_init.h>

int main(void) {
  	// Clock configuration settings
	RCC_CFGR_TypeDef _rcc_cfgr_val;
	RCC_CFGR_TypeDef* _rcc_cfgr=&_rcc_cfgr_val;
	
	//HSE 8MHz clock is used
	_rcc_cfgr->PLLXTPRE=RCC_CFGR_PLLXTPRE_HSE;
	_rcc_cfgr->PLLMUL=RCC_CFGR_PLLMULL5;
	_rcc_cfgr->HPRE=RCC_CFGR_HPRE_DIV1;
	_rcc_cfgr->PPRE1=RCC_CFGR_PPRE1_DIV2;
	_rcc_cfgr->PPRE2=RCC_CFGR_PPRE2_DIV1;
	
	HSE_clock_init(_rcc_cfgr);
  int i = 0;
  int b[50] = {0}; // zero initialize a struct
  for (;;) {
    i++;
  }
  return 0;
}
