section .data
    msg_even    db "0", 10
    msg_even_len equ $ - msg_even

    msg_odd     db "1", 10
    msg_odd_len  equ $ - msg_odd

section .bss
    buffer      resb 256

section .text
    global _start

_start:
    mov     rax, 0          ; syscall: read
    mov     rdi, 0          ; fd = stdin
    mov     rsi, buffer
    mov     rdx, 256
    syscall

    cmp     rax, 1
    jl      no_digit_exit   ; 0 or negative -> treat as failure (no digit)

    mov     rcx, rax
    dec     rcx             ; rcx = last index
scan_backwards:
    mov     bl, [rsi + rcx]
    cmp     bl, '0'
    jl      next_byte
    cmp     bl, '9'
    jg      next_byte
    ; found a digit in bl
    sub     bl, '0'         ; convert ascii -> 0..9
    and     bl, 1           ; keep only parity (0 even, 1 odd)
    cmp     bl, 0
    je      print_even
    ; odd
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, msg_odd
    mov     rdx, msg_odd_len
    syscall
    jmp     exit_ok

next_byte:
    test    rcx, rcx
    jz      no_digit_exit
    dec     rcx
    jmp     scan_backwards

no_digit_exit:
    mov     rax, 60
    mov     rdi, 1
    syscall

print_even:
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, msg_even
    mov     rdx, msg_even_len
    syscall

exit_ok:
    mov     rax, 60
    xor     rdi, rdi        ; exit(0)
    syscall
