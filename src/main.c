
#include <string.h>

#include "stm32f7xx_hal.h"
#include "stm32f769i_eval.h"
#include "stm32f769i_eval_io.h"
#include "stm32f7xx_it.h"

#include "hw.h"

UART_HandleTypeDef uart_handle;

static void init_cpu_caches(void)
{
	SCB_EnableICache();
	SCB_EnableDCache();
}

int main(void)
{
	const char *ch = "hello world!\r\n";

	init_cpu_caches();
	HAL_Init();

    // UART Init
    uart_handle.Instance = USART1;
    uart_handle.Init.BaudRate = 115200;
    uart_handle.Init.WordLength = UART_WORDLENGTH_8B;
    uart_handle.Init.StopBits = UART_STOPBITS_1;
    uart_handle.Init.Parity = UART_PARITY_NONE;
    uart_handle.Init.Mode = UART_MODE_TX_RX;
    uart_handle.Init.HwFlowCtl = UART_HWCONTROL_NONE;
    uart_handle.Init.OverSampling = UART_OVERSAMPLING_16;
    uart_handle.Init.OneBitSampling = UART_ONE_BIT_SAMPLE_DISABLE;
    uart_handle.AdvancedInit.AdvFeatureInit = UART_ADVFEATURE_NO_INIT;

	if (HAL_UART_Init(&uart_handle) != HAL_OK)
	{
		//printf("UART Init failed\n");
		while (1);
	}

	//printf("Uart enabled\n");
	for(;;)
	{
		HAL_UART_Transmit(&uart_handle, (uint8_t *)ch, strlen(ch), 0xFFFF);
		//HAL_UART_Receive(&uart_handle, pData, 5, 0x000f);
		//printf("Data: %s\n",pData);
	}
	return 0;
}

//  FIN
