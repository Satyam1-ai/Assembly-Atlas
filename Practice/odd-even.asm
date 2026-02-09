section .bss


section .data
  a dq 10
  b dq 2



section .text

main:
  xor rdx, rdx
  mov rax, [a]
  mov rbx, [b]
  
  div rbx
  
  cmp rdx, 0 
  je is_divisible
  
  
not_divisible:
  mov rdi,0 
  jmp finish
  
is_divisible:
  mov rdi,1 
  
  
finish:
  mov rax, 60
  syscall

