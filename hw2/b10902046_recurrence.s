.globl __start

.text
__start:
  li t0, 0        # T(0) = 0
  li t1, 1        # T(1) = 1
  li t5, 2        
  
  # read input
  li a0, 5
  ecall
  mv t3, a0

func:
  beq t3, zero, finish  
  mul t4, t1, t5        # 2T(n-1)
  add t2, t4, t0       
  mv t0, t1
  mv t1, t2
  addi t3, t3, -1
  j func
  
finish:
  # print output
  li a0, 1
  mv a1, t0
  ecall
  
  # Exit program(necessary)
  li a0, 10
  ecall
