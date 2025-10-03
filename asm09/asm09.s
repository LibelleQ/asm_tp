BITS 64
default rel

section .bss
buf:    resb 64

section .text
global _start

_start:
    mov rbx, rsp
    mov rax, [rbx]              ; argc
    cmp rax, 2
    je  .hex_only
    cmp rax, 3
    je  .maybe_bin
    jmp .exit1

.hex_only:
    mov rsi, [rbx+16]           ; argv[1]
    xor rdi, rdi                ; RDI = base = 16
    mov edi, 16
    jmp .parse

.maybe_bin:
    mov r8, [rbx+16]            ; argv[1]
    cmp byte [r8], '-'
    jne .exit1
    cmp byte [r8+1], 'b'
    jne .exit1
    cmp byte [r8+2], 0
    jne .exit1
    mov rsi, [rbx+24]           ; argv[2]
    xor rdi, rdi
    mov edi, 2                  ; base = 2

.parse:                         ; parse decimal argv in RSI -> RAX
    xor rax, rax
.pd:
    mov bl, [rsi]
    cmp bl, '0'
    jb  .after_parse
    cmp bl, '9'
    ja  .after_parse
    imul rax, rax, 10
    sub bl, '0'
    add rax, rbx
    inc rsi
    jmp .pd
.after_parse:
    mov rcx, buf
    add rcx, 64
    test rax, rax
    jnz .conv
    mov byte [rcx-1], '0'
    lea rsi, [rcx-1]
    mov rdx, 1
    jmp .write

.conv:
    xor rdx, rdx
    mov r9, rdi                 ; base
.loop:
    div r9
    mov bl, dl
    cmp r9d, 16
    jne .bin_digit
    cmp bl, 9
    jbe .hex_num
    sub bl, 10
    add bl, 'A'
    jmp .store
.hex_num:
    add bl, '0'
    jmp .store
.bin_digit:
    add bl, '0'
.store:
    dec rcx
    mov [rcx], bl
    xor rdx, rdx
    test rax, rax
    jne .loop
    mov rsi, rcx
    mov rdx, buf+64
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
    jmp .exit0

.exit1:
    mov eax, 60
    mov edi, 1
    syscall
.exit0:
    mov eax, 60
    xor edi, edi
    syscall

section .data
nl: db 10
