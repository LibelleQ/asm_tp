section .data
    msg0 db '0'
    msg1 db '1'

section .bss
    buffer  resb 256

section .text
    global _start

_start:
    mov     rax, 0
    mov     rdi, 0
    mov     rsi, buffer
    mov     rdx, 256
    syscall
    cmp     rax, 1
    jl      .bad_inputs

    xor     rbx, rbx
    mov     rdi, buffer
.nextchar:
    mov     al, [rdi]
    cmp     al, 10
    je      .parsed
    cmp     al, '0'
    jb      .bad_inputs
    cmp     al, '9'
    ja      .bad_inputs
    imul    rbx, rbx, 10
    movzx   rax, al
    sub     rax, '0'
    add     rbx, rax
    inc     rdi
    jmp     .nextchar

.parsed:
    cmp     rbx, 2
    jb      .not_prime
    mov     rcx, 2
.check:
    mov     rax, rcx
    imul    rax, rax
    cmp     rax, rbx
    ja      .prime
    mov     rax, rbx
    xor     rdx, rdx
    div     rcx
    test    rdx, rdx
    je      .not_prime
    inc     rcx
    jmp     .check

.prime:
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, msg0
    mov     rdx, 1
    syscall
    jmp     .exit0

.not_prime:
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, msg1
    mov     rdx, 1
    syscall
    jmp     .exit0

.bad_inputs:
    mov     rax, 60
    mov     rdi, 1
    syscall

.exit0:
    mov     rax, 60
    xor     rdi, rdi
    syscall
