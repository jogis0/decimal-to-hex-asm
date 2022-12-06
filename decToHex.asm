.MODEL small

.STACK 100h

.DATA
message db 'Enter a decimal number (up to 65535)',0dh,0ah,'$'

.CODE
start:
	mov ax, @data
	mov ds, ax
	
	mov ah, 9
	mov dx, offset message
	int 21h
	
	mov cx, 10
	
input:
	mov ah, 1
	int 21h
	cmp al, 13
	je input_end
	sub al, 48
	mov ah, 0
	push ax
	mov ax, bx
	mul cx
	mov bx, ax
	pop ax
	add bx, ax
	jmp input
	
input_end:
	mov ax, bx
	mov cx, 16
	mov bx, 0
	
conversion:
	div cx
	push dx
	mov dx, 0
	inc bl
	cmp ax, 0
	jne conversion
	
	mov ah, 02h
	mov dl, 10 
	int 21h
	mov ah, 02h
	mov dl, 13
	int 21h
	
output_start:
	pop ax 
	cmp al, 9
	jg output_hex 
	
output_dec:
	add al, 48
	mov ah, 2
	mov dl, al 
	int 21h 
	inc bh 
	cmp bh, bl
	jne output_start
	jmp output_end
	
output_hex:
	add al, 55
	mov ah, 2
	mov dl, al
	int 21h 
	inc bh 
	cmp bh, bl 
	jne output_start
	
output_end:
	mov ax, 4C00h
	int 21h

end start
