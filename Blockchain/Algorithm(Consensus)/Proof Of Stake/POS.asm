section .data
    ; Define the block header
    timestamp   dd  0           ; 32-bit timestamp
    prev_block  dd  0           ; 32-bit reference to previous block
    stake       dd  0           ; 32-bit amount of cryptocurrency staked
    validator   dd  0           ; 32-bit validator ID
    
    ; Define the target difficulty (number of leading zeros required in hash)
    difficulty  db  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    
    ; Define a buffer to hold the block header and validator ID
    header_buf  db  16 dup(0)
    
    ; Define a buffer to hold the hash of the block header and validator ID
    hash_buf    db  32 dup(0)

section .text
    global pos
    
    ; pos: Proof of Stake function that takes a block header, difficulty, validator ID, and staked amount, and returns a boolean indicating success or failure
    pos:
        push    ebp
        mov     ebp, esp
        
        ; Copy the block header and validator ID into the header buffer
        mov     esi, [ebp + 8]        ; Pointer to block header
        mov     edi, header_buf
        mov     ecx, 16
        rep     movsb
        
        ; Compute the hash of the block header and validator ID
        mov     edi, hash_buf
        call    sha256
        
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
        ; Hash does not meet difficulty requirement, validation failed
        xor     eax, eax
        jmp     done
    hash_valid:
        ; Hash meets difficulty requirement, compute the validator's probability of success
        mov     eax, dword [header_buf + 12] ; Get validator ID from header buffer
        add     eax, dword [ebp + 12]        ; Add staked amount to validator ID
        xor     edx, edx
        div     dword [esi + 8]              ; Divide by total supply to get probability
        
        ; Generate a random number and compare to the validator's probability of success
        mov     ebx, eax
        call    random
        cmp     eax, ebx
        jb      validation_failed
        
        ; Validation succeeded
        mov     eax, 1
        jmp     done
    validation_failed:
        ; Validation failed
        xor     eax, eax
    done:
        pop     ebp
        ret


//will switch 