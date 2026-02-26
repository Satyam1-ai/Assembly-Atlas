section .data
    my_array dd 10,20,30,40
    len equ 4
    
section .text
  main:
    xor eax,eax
    xor r10d, r10d
    lea rsi, [rel my_array]
    
    xor rbx, rbx
    
    loop: 
      add r10d, [rsi+rbx*4]
      
      inc rbx
      cmp rbx, len
      jne loop
      
    done:
      
      mov rcx, rbx
      xor rax, rax
      mov rax, r10d
      xor rdx, rdx
      div rcx
      
      
      mov rdi, rax
      xor rax, rax
      mov rax, 60
      syscall
      
      
