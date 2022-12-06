.MODEL small

.STACK 100h

.DATA
message db 'Enter a decimal number (from 0 to 65535)',0dh,0ah,'$'

.CODE
start:
	mov ax, @data
	mov ds, ax
	
	mov ah, 9
	mov dx, offset message ;Isspausdinam zinute
	int 21h
	
	mov cx, 10 ;I cx idedam 10, nes dauginsim is 10
	
input:
	mov ah, 1
	int 21h	;I al nuskaito skaiciu
	cmp al, 13 ;Jei 'enter', baigiam cikla
	je input_end
	sub al, 48 ;Atimam ASCII kodo skaiciu
	mov ah, 0
	push ax ;I stacka idedam nuskaityta sk.
	mov ax, bx ;bx - galutinis skaicius
	mul cx ;ax padauginam is 10, kad prie skaiciaus galo galetume pridet nauja skaiciu
	mov bx, ax
	pop ax
	add bx, ax ;Sudedam musu norima skaiciu su naujai nuskaitytu skaiciu
	jmp input ;Kartojam cikla
	
input_end:
	mov ax, bx ;I ax idedam galutini nuskaityta skaiciu
	mov cx, 16 ;Dalinsim is 16
	mov bx, 0 ;Bx naudosim skaiciuoti, kiek skaiciu ideta i stacka / kiek liekanu gauta
	
conversion:
	div cx ;DX:AX / CX, DX - liekana
	push dx ;Liekana idedam i stacka
	mov dx, 0
	inc bl ;Skaiciuojam, kiek sk. idedam i stacka
	cmp ax, 0 ;Jei dalyboje negaunam 0, kartojam cikla
	jne conversion
	
	mov ah, 02h
	mov dl, 10 ;Nauja linija
	int 21h
	mov ah, 02h
	mov dl, 13 ;Cariage return
	int 21h
	
output_start:
	pop ax ;Is stacko isimam gauta liekana
	cmp al, 9
	jg output_hex ;Patikrina, ar skaicius didesnis uz 9
	
output_dec:
	add al, 48 ;Pridedam ASCII koda
	mov ah, 2
	mov dl, al ;I dl idedam skaiciu, kad galetume ji isvesti
	int 21h ;Isvedam skaiciu
	inc bh ;Skaiciuojam, kiek skaiciu isvedem
	cmp bh, bl ;Jeigu isvestu skaiciu kiekis nera i stacka idetu skaiciu kiekis, kartojam cikla
	jne output_start
	jmp output_end
	
output_hex:
	add al, 55 ;Pridedam ASCII koda
	mov ah, 2
	mov dl, al ;I dl idedam skaiciu, kad galetume ji isvesti
	int 21h ;Isvedam skaiciu
	inc bh ;Skaiciuojam, kiek skaiciu isvedem
	cmp bh, bl ;Jeigu isvestu skaiciu kiekis nera i stacka idetu skaiciu kiekis, kartojam cikla
	jne output_start
	
output_end:
	mov ax, 4C00h
	int 21h

end start
