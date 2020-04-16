#include "delay.h"

#define AHB SystemCoreClock/8

static volatile bool delayed=false;
static uint32_t tick_load=0;
void start_SysTick(double ticks);

void SysTick_delay_init(){
	//Clock source is AHB/8 is CLKSOURCE =0
	SysTick->CTRL |= 	SysTick_CTRL_TICKINT_Msk ; //Asserts exception
	//processor implements only bits[7:4] of 8 bit register
	//SysTick is PRI_15, lower value->greater priority
	SCB->SHP[11] |=  0x2<<4; //PRI_15 is a last register in SHP, setting highest priority from programable interrupts
}

void SysTick_delay(double seconds){
	tick_load=AHB*seconds;
	delayed=true;
    start_SysTick(tick_load);
}

void clean_SysTick(){
    CLEAR_BIT(SysTick->CTRL,SysTick_CTRL_ENABLE_Msk);
    SysTick->VAL=0; //Write of any value makes it 0 
}

void start_SysTick(double ticks){
    clean_SysTick();
    if (tick_load>0x00FFFFFF){
		tick_load-=0x00FFFFFF;
		SysTick->LOAD =0x00FFFFFF; //maximum is 0x00FF FFFF
        SET_BIT(SysTick->CTRL,SysTick_CTRL_ENABLE_Msk);
	} else {
		SysTick->LOAD=tick_load;
		tick_load=0;
		SET_BIT(SysTick->CTRL,SysTick_CTRL_ENABLE_Msk);
	}	
}

bool delay_active(){
	if (delayed)
		return true;
	else 
		return false;
}

void SysTick_Handler(void){
	if (tick_load!=0){
        start_SysTick(tick_load);
	} else {
        clean_SysTick();
        delayed=false;	
	}
}