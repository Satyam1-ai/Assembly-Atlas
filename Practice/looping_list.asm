section .data
  array dq 1,2,3    ;simple list creation ...giving a basic initialisation 
section .text

main:
  mov rsi, array

  mov rcx, 3
loop: 
  add rax, [rsi]
  add rsi, 8
  dec rcx
  cmp rcx, 0
  jne loop
  
  
  mov rdi, rax
  mov rax ,60
  syscall
