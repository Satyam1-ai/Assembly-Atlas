section .data
  array dq 1,2,3    ;simple list creation ...giving a basic initialisation 
section .text

main:
  xor rbx, rbx
  mov rbx, 5
  mov rax, 1
loop: 
  mul rbx
  dec rbx
  cmp rbx, 0 
  jne loop
  
  
  

  mov rdi, rax
  mov rax ,60
  syscall
