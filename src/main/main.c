// By Wolfgang Wieser, heavily based on:
// http://fun-tech.se/stm32/OlimexBlinky/mini.php
#include <stdlib.h>
#include "stm32f10x_init.h"
#include "FreeRTOS.h"
#include "task.h"

TaskHandle_t xTask2Handle= NULL;
static void prvSetupHardware();
void vTask1( void *pvParameters );
void vTask2( void *pvParameters );

int main (void) {
  	/* Perform any hardware setup necessary. */
	prvSetupHardware();
	

	/* Create the first task at priority 1.  
	* The task parameter is not used sois set to NULL.  
	* The task handle is also not used so likewise is set to NULL. 
	* */
	xTaskCreate( vTask1, "Task 1", 1000, NULL, 1, NULL );
	/* The task is created at priority 1 ______^. */
	/* Start the scheduler so thetaskstartsexecuting. */
	vTaskStartScheduler();    
	/* main()should never reach here as the scheduler has been started. */
	for( ;; );
}

static void prvSetupHardware(){
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
}

void vTask1( void *pvParameters ){
	const TickType_t xDelay100ms = pdMS_TO_TICKS( 10000UL );
	for( ;; ){
		/* Print out the name of this task. */
		// SysTick_delay(3);
		// while(delay_active());

		/* Create task 2 at a higher priority.  
		 * Again the task parameter is not used so is set to NULL 
		 * -BUT this time the task handle is required sothe address 
		 * of xTask2Handle ispassed as the last parameter.
		 * */
		xTaskCreate( vTask2, "Task 2", 1000, NULL, 2, &xTask2Handle );
		/* The task handle is the last parameter _____^^^^^^^^^^^^^ */
		
		/* Task 2has/had the higher priority, so for Task 1to reach 
		 * here Task2must have already executed and deleted itself.  
		 * Delay for 100 milliseconds. */
		vTaskDelay( xDelay100ms );
	}
}

void vTask2( void *pvParameters ){
	/* Task 2does nothing but delete itself.  
	 * To do this it could call vTaskDelete()usingNULL as 
	 * the parameter, but instead,and purely for demonstration 
	 * purposes,it calls vTaskDelete() passing its own task handle. 
	 * */
	// SysTick_delay(3);
	// while(delay_active());
	vTaskDelete( xTask2Handle );
}

void vApplicationMallocFailedHook( void )
{
	/* Called if a call to pvPortMalloc() fails because there is insufficient
	free memory available in the FreeRTOS heap.  pvPortMalloc() is called
	internally by FreeRTOS API functions that create tasks, queues, software
	timers, and semaphores.  The size of the FreeRTOS heap is set by the
	configTOTAL_HEAP_SIZE configuration constant in FreeRTOSConfig.h. */
	for( ;; );
}
/*-----------------------------------------------------------*/

void vApplicationStackOverflowHook( TaskHandle_t pxTask, char *pcTaskName )
{
	( void ) pcTaskName;
	( void ) pxTask;

	/* Run time stack overflow checking is performed if
	configconfigCHECK_FOR_STACK_OVERFLOW is defined to 1 or 2.  This hook
	function is called if a stack overflow is detected. */
	for( ;; );
}
/*-----------------------------------------------------------*/

void vApplicationIdleHook( void )
{
volatile size_t xFreeStackSpace;

	/* This function is called on each cycle of the idle task.  In this case it
	does nothing useful, other than report the amout of FreeRTOS heap that
	remains unallocated. */
	xFreeStackSpace = xPortGetFreeHeapSize();

	if( xFreeStackSpace > 100 )
	{
		/* By now, the kernel has allocated everything it is going to, so
		if there is a lot of heap remaining unallocated then
		the value of configTOTAL_HEAP_SIZE in FreeRTOSConfig.h can be
		reduced accordingly. */
	}
}