.globl __start

.rodata
    division_by_zero: .string "division by zero"

.data
  jump_table: .word L0, L1, L2, L3, L4, L5, L6

.text
__start:
    # Read first operand
    li a0, 5
    ecall
    mv s0, a0
    # Read operation
    li a0, 5
    ecall
    mv s1, a0
    # Read second operand
    li a0, 5
    ecall
    mv s2, a0
    
    jal x1, switch_op
    jal x0, output

switch_op:
    addi sp, sp, -8
    sw x1, 0(sp)
    
    la x28, jump_table
    slli x5, s1, 2
    add x6, x5, x28
    lw x7, 0(x6)
    jalr x1, 0(x7)
    lw x1, 0(sp)
    addi sp, sp, 8
    jalr x0, 0(x1)



L0:          
    add s3, s0, s2
    jalr x0, 0(x1)
L1:
    sub s3, s0, s2
    jalr x0, 0(x1)
L2:
    mul s3, s0, s2
    jalr x0, 0(x1)
L3:
    beq s2, x0, division_by_zero_except
    div s3, s0, s2
    jalr x0, 0(x1)
L4:
    blt s0, s2, minA
    blt s2, s0, minB
    beq s0, s2, minA
minA:
    add s3, s0, x0
    jalr x0, 0(x1)
minB:
    add s3, s2, x0
    jalr x0, 0(x1)
L5:
    beq s0, x0, complete
    addi s3, x0, 1
    addi sp, sp, -8
    sw x1, 0(sp)
    jal x1, power
    lw x1, 0(sp)
    addi sp, sp, 8
    jalr x0, 0(x1)
power:
    li x5, 1
    blt s2, x5, complete
    sub s2, s2, x5
    mul s3, s3, s0
    beq x0, x0, power
complete:
    jalr x0, 0(x1)  
L6:
    addi s3, x0, 1
    addi sp, sp, -8
    sw x1, 0(sp)
    jal x1, fact
    lw x1, 0(sp)
    addi sp, sp, 8
    jalr x0, 0(x1)
fact:
    li x5, 1
    blt s0, x5, complete
    mul s3, s3, s0
    sub s0, s0, x5
    beq x0, x0, fact


###################################
#  TODO: Develop your calculator  #
#                                 #
###################################

output:
    # Output the result
    li a0, 1
    mv a1, s3
    ecall

exit:
    # Exit program(necessary)
    li a0, 10
    ecall

division_by_zero_except:
    li a0, 4
    la a1, division_by_zero
    ecall
    jal zero, exit
