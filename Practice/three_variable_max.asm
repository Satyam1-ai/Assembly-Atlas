section .bss


section .data
  a dq 10
  b dq 15
  c dq 21



section .text

main:
  mov rax, [a]
  mov r8, [b]
  mov rbx, [c]
  cmp rax, r8
  jg next
  
  mov rax, r8
  
next:
  cmp rax, rbx
  jg finish
  mov rax,rbx
  

finish
  mov rdi, rax
  mov rax, 60
  syscall

