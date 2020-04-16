#ifndef DELAY_H
#define DELAY_H

#include <stm32f1xx.h>
#include <stdbool.h>
#include <stm32f10x_init.h>

/****
	Initalization routine	for Systick interrupts
	Set priority and set for assert exceptions 
****/
void SysTick_delay_init();

/****
	delays but returns right away
	If user wants to stop the program from going further
	In while loop check should be done with delayed_activated()
****/
void SysTick_delay(double seconds);

/***
	Checking the delay flag
	because delay flag is initialized inside the file and is not accessible from outside
	Function is checking it and giving information about if the delay is active or not
***/	

bool delay_active();

/***
	Handling the interrupts of SysTick
	responsible for delay and for the LED and Buzzer indications
***/
void SysTick_Handler(void);

#endif /* DELAY_H */