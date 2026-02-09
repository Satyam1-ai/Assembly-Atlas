
section .data
  array dq 1,2,3,4,5,6,7,8,9
  len dq 9
section .text
  global _start

_start:
  mov rbx, array
  xor rcx, rcx
  xor r8,r8
loop:
  mov rax, [rbx+rcx*8]
  add rax, 48
  push rax
  mov rax, 1
  mov rdi, 1
  mov rsi, rsp
  mov rdx, 1
  mov r8, rcx
  syscall
  mov rcx, r8
  pop rax
  inc rcx
  cmp rcx, [len]
  jne loop
  
  
finish:
  mov rax, 60
  xor rdi, rdi
  syscall
