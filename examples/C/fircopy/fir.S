.global fir
fir:
    # Save stack registers
    addi sp, sp, -32
    sd s0, 0(sp)
    sd s1, 8(sp)
    sd s2, 16(sp)
   
    li s0, 0           # j = 0
forj:
    bge s0, a3, donej  # branch if j >= n
    li s2, 0           # sum = 0
    li s1, 0           # i = 0
   
fori:
    bge s1, a4, donei  # branch if i >= m
   
    # Calculate x[j+(m-1)-i]
    add t0, s0, a4     # j + m
    addi t0, t0, -1    # j + (m-1)
    sub t0, t0, s1     # j + (m-1) - i
    slli t0, t0, 2     # Convert to bytes
    add t0, a0, t0     # offset
    lw t1, 0(t0)       # Load x value
   
    # Load c[i]
    slli t2, s1, 2     # Convert i to bytes
    add t2, a1, t2     # Get address
    lw t3, 0(t2)       # Load c value
   
    # Perform multiplication and accumulate
    mul t4, t1, t3     # Multiply values
    srai t4, t4, 31    # 31>>
    add s2, s2, t4     # running sum
   
    addi s1, s1, 1     # i = i + 1 
    j fori
   
donei:
    # Store sum in y[j]
    slli t0, s0, 2     # j to bytes
    add t0, a2, t0     # add offset
    sw s2, 0(t0)       # y[j] = sum
   
    addi s0, s0, 1     # j = j + 1
    j forj
   
donej:
    # Restore stack
    ld s0, 0(sp)
    ld s1, 8(sp)
    ld s2, 16(sp)
    addi sp, sp, 32
    ret