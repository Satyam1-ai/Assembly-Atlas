section .bss
  quotient resq 1
  remainder resq 1
section .text

main:
  mov rax,25
  xor rdx, rdx
  mov rbx, 10
  
  div rbx
  
  mov [quotient], rax
  mov [remainder], rdx
  
  mov rax ,60
  syscall
