section .data
    ; Define the block header
    timestamp   dd  0           ; 32-bit timestamp
    prev_block  dd  0           ; 32-bit reference to previous block
    nonce       dd  0           ; 32-bit nonce
    
    ; Define the target difficulty (number of leading zeros required in hash)
    difficulty  db  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    
    ; Define a buffer to hold the block header and nonce
    header_buf  db  64 dup(0)
    
    ; Define a buffer to hold the hash of the block header and nonce
    hash_buf    db  32 dup(0)

section .text
    global pow
    
    ; pow: Proof of Work function that takes a block header and difficulty and returns the nonce
    pow:
        push    ebp
        mov     ebp, esp
        
        ; Copy the block header into the header buffer
        mov     esi, [ebp + 8]        ; Pointer to block header
        mov     edi, header_buf
        mov     ecx, 64
        rep     movsb
        
        ; Loop over possible nonce values until a valid hash is found
        xor     eax, eax
        xor     ebx, ebx
    nonce_loop:
        mov     dword [esi + 12], eax  ; Update the nonce in the block header
        mov     edi, hash_buf
        call    sha256                ; Compute the hash of the block header and nonce
        
        ; Check if the hash meets the difficulty requirement
        mov     esi, difficulty
        xor     ecx, ecx
        xor     edx, edx
    check_difficulty_loop:
        mov     cl, [esi + edx]
        cmp     cl, 0
        je      hash_valid           ; If difficulty is zero, hash is always valid
        mov     cl, 8
    leading_zero_loop:
        test    byte [edi + ecx - 1], 0x80
        jz      difficulty_mismatch
        dec     cl
        cmp     cl, [esi + edx]
        jge     hash_valid
        jmp     leading_zero_loop
    difficulty_mismatch:
        ; Hash does not meet difficulty requirement, try next nonce
        inc     eax
        cmp     eax, 0
        jne     nonce_loop
        ; No valid nonce found, return 0
        xor     eax, eax
        jmp     done
    hash_valid:
        ; Hash meets difficulty requirement, return the nonce
        mov     eax, dword [header_buf + 12]
    done:
        pop     ebp
        ret



// will switch to c++ :(