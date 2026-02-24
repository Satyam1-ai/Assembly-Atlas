section .data
    my_array dd 10,20,30,40
    len equ 4
    
section .text
  main:
      xor rbx, rbx
      xor rax, rax 
      lea rsi, [rel my_array]
      xor r10d, r10d
    sum_loop:
      mov eax, [rsi + rbx*4]
      mov r11d, 2
      xor edx, edx
      div r11d
      
      cmp edx, 0
      jne skip_add
      
      mov eax, [rsi + rbx*4]
      add r10d, eax


    skip_add:
      inc rbx
      cmp rbx, len
      jne sum_loop
      
      mov edi, r10d
      mov eax, 60
      syscall 
