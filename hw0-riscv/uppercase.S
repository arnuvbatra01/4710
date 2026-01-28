        .section .data
input_string: .asciz "123 abc XYZ !!!"

        # tohost/fromhost are data locations used by Spike
        .align 8
tohost: .byte 0
        .align 8
fromhost: .byte 0

        
        .section .text
        .globl _start
_start:
        # Load the address of the input string into a0
        la x7, input_string

loop:
        lb x6, 0(x7)  # Load the current byte of the string to x6
        beq x6, x0, end_program # If null terminator (0), end program

        li x8, 0x61 # lower bound
        li x9, 0x7A # upper bound

        blt x6, x8, done # if x6 <61 then next character
        bgt x6, x9, done # if x6 >7A then next character
        
        li x1, 0x20 # otherwise, subtract 20
        sub x6, x6, x1
        sb x6, 0(x7) # store back to memory

        done:
        addi x7, x7, 1 # increment byte address
        j loop # loop back

        
end_program:
        # jump here when you're done
        j end_program
