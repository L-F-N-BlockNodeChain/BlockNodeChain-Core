section .data
    ; Define the block header
    timestamp   dd  0           ; 32-bit timestamp
    prev_block  dd  0           ; 32-bit reference to previous block
    nonce       dd  0           ; 32-bit nonce
    
    ; Define the block body
    data        db  'This is some data', 0
