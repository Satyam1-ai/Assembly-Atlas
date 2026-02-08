section .text


section .data
  number_one dq 10


global main
main:
  mov rax, 10
  add rax, [number_one]
  
  mov rdi, rax
  mov rax, 60
  syscall
  


