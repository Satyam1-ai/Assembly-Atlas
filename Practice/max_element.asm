section .data
    my_array dd 10,20,30,40
    len equ 4
    
section .text
  main:
    xor rax, rax
    lea rsi, [rel my_array]
    
    xor r10d, r10d
    
    max_loop: 
      mov eax, [rsi +rbx*4]
      cmp eax, r10d
      jle next_iter
      
      mov r10d, eax
      
    next_iter: 
      inc rbx
      cmp rbx, len
      jne max_loop
      
      
      
    mov edi, r10d
    mov rax, 60
    syscall
