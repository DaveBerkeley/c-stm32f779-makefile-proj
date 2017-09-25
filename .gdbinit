file STM_Eval.elf
tar ext:3333
monitor halt
load STM_Eval.elf
monitor reset halt
mon arm semihosting enable
