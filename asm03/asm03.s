BITS 64
default rel

section .data
msg: db "1337",10
msg_len equ $-msg

section .text
global _start

_start:
    mov rbx, rsp
    mov rax, [rbx]
    cmp rax, 2
    jb  .exit1
    mov rsi, [rbx+16]
    cmp byte [rsi], '4'
    jne .exit1
    cmp byte [rsi+1], '2'
    jne .exit1
    cmp byte [rsi+2], 0
    jne .exit1
    mov eax, 1
    mov edi, 1
    mov rsi, msg
    mov edx, msg_len
    syscall
    mov eax, 60
    xor edi, edi
    syscall
.exit1:
    mov eax, 60
    mov edi, 1
    syscall
