section .data
    ; Define the IP address and port number of the node
    my_ip       db  "127.0.0.1"
    my_port     dw  8000
    
    ; Define the maximum number of connections
    max_connections dw  10
    
    ; Define the data buffer size
    buffer_size dw  1024
    
    ; Define the message types
    msg_block   db  1
    msg_tx      db  2
    
section .bss
    ; Define the connection table
    conn_table  resw max_connections * 3 ; 3 words per connection: socket, ip, port
    
    ; Define the data buffer
    buffer      resb buffer_size

section .text
    global main
    
    ; main: the main entry point of the program
    main:
        ; Initialize the network
        call    init_network
        
        ; Wait for incoming connections
        call    wait_for_connections
        
        ; Send a message to all connected nodes
        mov     eax, msg_block
        call    send_message_to_all
        
        ; Receive a message from a node
        call    receive_message
        
        ; Disconnect from all nodes
        call    disconnect_all
        
        ; Exit the program
        mov     eax, 0
        ret
    
    ; init_network: initialize the network by creating a listening socket
    init_network:
        push    ebp
        mov     ebp, esp
        
        ; Create a socket
        push    dword 0             ; AF_INET
        push    dword 1             ; SOCK_STREAM
        push    dword 0             ; IPPROTO_TCP
        call    socket
        mov     dword [conn_table], eax    ; Save the socket in the connection table
        
        ; Bind the socket to the IP address and port number
        mov     esi, [ebp + my_ip]
        push    dword esi
        mov     ax, [ebp + my_port]
        push    ax
        push    dword 16            ; sizeof(struct sockaddr_in)
        lea     esi, [conn_table + 2] ; Pointer to connection table entry
        push    esi
        push    dword 2             ; AF_INET
        call    bind
        
        ; Listen for incoming connections
        push    dword 1             ; SOMAXCONN
        call    listen
        
        pop     ebp
        ret
    
    ; wait_for_connections: wait for incoming connections and add them to the connection table
    wait_for_connections:
        push    ebp
        mov     ebp, esp
        
    loop:
        ; Accept a new connection
        mov     esi, [ebp + conn_table]
        push    dword 16            ; sizeof(struct sockaddr_in)
        lea     ecx, [esi + max_connections * 6] ; Pointer to end of connection table
        push    ecx
        push    dword 0             ; sockaddr_in*
        push    dword 0             ; addrlen*
        mov     eax, [esi]          ; Load the listening socket
        push    eax
        call    accept
        cmp     eax, -1
        je      loop                ; If accept returns -1, try again
        
        ; Add the new connection to the connection table
        mov     ecx, eax            ; Save the new socket in ECX
        mov     esi, [ebp + conn_table]
        xor     eax, eax
        mov    

// will switch