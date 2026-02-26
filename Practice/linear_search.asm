section .data
    my_array dd 10,20,30,40
    len equ 4
    to_find dd 20
    
section .text
  main:
     xor rax, rax
     lea rsi, [rel my_array]
     xor rbx, rbx
     mov r10,-1
     
     search_loop:
      cmp rbx, len
      je done
      mov eax, [rsi+rbx*4]
      cmp eax, [to_find]
      jne next_iteration
      
      mov r10, rbx
      jmp done
      
    next_iteration:
      inc rbx
      jmp search_loop
      
    done:
      cmp r10, -1
      je handle_failure
      mov rdi, r10
      
      jmp all_done
      
    handle_failure:
      mov rdi, -1
      jmp all_done
    
    
    all_done:
      mov rax, 60
      syscall 
      
    
