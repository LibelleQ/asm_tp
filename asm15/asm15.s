BITS 64
default rel

section .bss
buf: resb 20

section .data
s0: db '0',10
s1: db '1',10

section .text
global _start

_start:
    mov rbx, rsp
    mov rax, [rbx]
    cmp rax, 2
    jl .p1
    mov rdi, [rbx+16]
    mov rax, 2
    xor rsi, rsi
    xor rdx, rdx
    syscall
    cmp rax, 0
    jl .p1
    mov r12, rax
    mov rax, 0
    mov rdi, r12
    lea rsi, [rel buf]
    mov rdx, 20
    syscall
    cmp rax, 20
    jl .c1
    mov rax, 3
    mov rdi, r12
    syscall
    lea rsi, [rel buf]
    cmp byte [rsi+0], 0x7F
    jne .p1
    cmp byte [rsi+1], 'E'
    jne .p1
    cmp byte [rsi+2], 'L'
    jne .p1
    cmp byte [rsi+3], 'F'
    jne .p1
    cmp byte [rsi+4], 2
    jne .p1
    mov al, [rsi+18]
    mov bl, [rsi+19]
    cmp al, 0x3e
    jne .r2
    cmp bl, 0x00
    jne .p1
    jmp .p0
.r2:
    cmp al, 0x00
    jne .p1
    cmp bl, 0x3e
    jne .p1
    jmp .p0

.c1:
    mov rax, 3
    mov rdi, r12
    syscall
.p1:
    mov rax, 1
    mov rdi, 1
    lea rsi, [rel s1]
    mov rdx, 2
    syscall
    mov eax, 60
    mov edi, 1
    syscall

.p0:
    mov rax, 1
    mov rdi, 1
    lea rsi, [rel s0]
    mov rdx, 2
    syscall
    mov eax, 60
    xor edi, edi
    syscall
