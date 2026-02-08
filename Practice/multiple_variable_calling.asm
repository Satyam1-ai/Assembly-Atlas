section .data
  price1 dq 10
  price2 dq 20
  price3 dq 30
  

main:

  xor rax,rax
  mov rax, [price1]
  add rax, [price2]
  add rax, [price3]
  
  mov rdi, rax
  
  mov rax, 60
  syscall
  
  
