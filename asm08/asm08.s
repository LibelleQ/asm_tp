BITS 64
default rel

section .bss
buf:    resb 32

section .text
global _start

_start:
    mov rbx, rsp
    mov rax, [rbx]
    cmp rax, 2
    jl .exit0
    mov rsi, [rbx+16]        ; argv[1]

    xor rdi, rdi             ; N
.pd:
    mov al, [rsi]
    cmp al, '0'
    jb  .got
    cmp al, '9'
    ja  .got
    imul rdi, rdi, 10
    sub al, '0'
    add rdi, rax
    inc rsi
    jmp .pd
.got:
    mov rax, rdi
    test rax, rax
    jz .print_zero
    mov rbx, rax
    dec rbx
    test rax, 1
    jz .evenN
    shr rbx, 1
    jmp .mul
.evenN:
    shr rax, 1
.mul:
    mul rbx                   ; RAX = N*(N-1)/2

    mov rcx, buf
    add rcx, 32
    test rax, rax
    jnz .uconv
    mov byte [rcx-1], '0'
    lea rsi, [rcx-1]
    mov rdx, 1
    jmp .write
.uconv:
    xor rdx, rdx
    mov r8, 10
.ul:
    div r8
    add dl, '0'
    dec rcx
    mov [rcx], dl
    xor rdx, rdx
    test rax, rax
    jne .ul
    mov rsi, rcx
    mov rdx, buf+32
    sub rdx, rsi
.write:
    mov rax, 1
    mov rdi, 1
    syscall
.exit0:
    mov eax, 60
    xor edi, edi
    syscall

.print_zero:
    mov rax, 1
    mov rdi, 1
    mov rsi, buf
    mov byte [rsi], '0'
    mov rdx, 1
    syscall
    jmp .exit0
