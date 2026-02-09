section .data
  
section .text
  global _start

_start:
  xor rdx, rdx
  
  mov rax, 5
  add rax, 48
  push rax
  mov rax, 1
  mov rdi, 1
  mov rsi,rsp
  mov rdx, 1
  syscall
  
  
  xor rdx, rdx
  mov rax,10
  push rax
    
  mov rax, 1
  mov rdi, 1
  mov rsi,rsp
  mov rdx, 1
  syscall
  
  xor rdx, rdx
  
  mov rax, 6
  add rax, 48
  push rax
  mov rax, 1
  mov rdi, 1
  mov rsi,rsp
  mov rdx, 1
  syscall
  
  
  


  

  
  
finish:
  mov rax, 60
  xor rdi, rdi
  syscall
