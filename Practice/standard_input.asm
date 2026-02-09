
section .data

section .bss
  buffer resb 16 
  
section .text
  global _start

_start:
  mov rax, 0 
  mov rdi, 0 
  mov rsi, buffer
  mov rdx, 16
  syscall
  
  mov rdx, rax
  mov rax, 1 
  mov rdi, 1 
  mov rsi, buffer
  syscall
  
  
  



  
finish:
  mov rax, 60
  xor rdi, rdi
  syscall
