section .data
  array dq 1,2,3    ;simple list creation ...giving a basic initialisation 
section .text

main:
  mov rsi, array
  mov rax, [rsi]
  add rsi, 8
  add rax, [rsi]
  add rsi, 8
  add rax, [rsi]
  
  
  
  mov rdi,rax
  
  
  mov rax, 60
  syscall

