#include "stm32f7xx_hal.h"
#include "stm32f769i_eval.h"
#include "stm32f769i_eval_io.h"


static void init_cpu_caches(void)
{
        SCB_EnableICache();
        SCB_EnableDCache();
}

int main(void)
{
        int i = 0;
        init_cpu_caches();

        BSP_LED_Init(LED_GREEN);
        BSP_LED_Init(LED_RED);
        BSP_LED_Init(LED_BLUE);
        BSP_LED_Init(LED_ORANGE);

        BSP_LED_Toggle(LED_GREEN);
        BSP_LED_Toggle(LED_RED);

        for(;;)
        {
                BSP_LED_Toggle(LED_GREEN);
                BSP_LED_Toggle(LED_RED);
                BSP_LED_Toggle(LED_ORANGE);
                BSP_LED_Toggle(LED_BLUE);
                for (int j = 0; j < 1000000; j++);
                printf("Hello, world! -- %i\n", i++);
        }
        return 0;
}
