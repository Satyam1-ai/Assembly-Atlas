section .data
    my_array dd 10,20,30,40
    len equ 4
    
section .text
  main:
    mov eax, len
    shr eax, 1
    mov r10d, eax
    xor eax, eax
    
    mov rbx, 0 
    mov rcx, len
    sub rcx, 1
    
    
    lea rsi, [rel my_array]
  
    looping:
      mov eax , [rsi+rbx*4]
      mov r11d , [rsi+rcx*4]

      mov [rsi+rcx*4], eax
      mov [rsi+rbx*4], r11d
      inc rbx
      dec rcx
      cmp rbx ,r10d
      jne looping
      
    done:
    xor rdi,rdi
    mov rax, 60
    syscall
