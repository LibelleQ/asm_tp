BITS 64
default rel

section .bss
buf:    resb 32

section .data
nl:     db 10

section .text
global _start

_start:
    mov rbx, rsp
    mov rax, [rbx]
    cmp rax, 2
    jl .fail
    mov rsi, [rbx+16]        ; argv[1]

    ; parse unsigned decimal -> RDI = N
    xor rdi, rdi
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
    ; S = N*(N-1)/2, en évitant l’overflow
    mov rax, rdi         ; rax = N
    test rax, rax
    jz .print_zero
    mov rbx, rax         ; rbx = N
    dec rbx              ; rbx = N-1
    test rax, 1
    jz .evenN
    shr rbx, 1           ; (N-1)/2
    jmp .mul
.evenN:
    shr rax, 1           ; N/2
.mul:
    mul rbx              ; RAX = (N/2)*(N-1)  ou  ((N-1)/2)*N
    ; print RAX (unsigned)
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
    mov rax, 1
    mov rdi, 1
    mov rsi, nl
    mov rdx, 1
    syscall
    mov eax, 60
    xor edi, edi
    syscall

.print_zero:
    mov rax, 1
    mov rdi, 1
    mov rsi, nl
    mov rdx, 1
    syscall
    mov eax, 60
    xor edi, edi
    syscall

.fail:
    mov eax, 60
    mov edi, 1
    syscall
