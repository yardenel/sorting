IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------

arr dw 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0

CODESEG
proc min ;saves the offset of the smallest values in the DATASEG
    push bp
	mov bp, sp
	
	push di ;black box
	push ax
	push cx
		
	mov di, [bp+4] ;di is now pointing to the first variables in the array
	mov ax, 0ffffh
	mov cx, [bp+6] ;the loop will run the number of variables
lop:
	cmp ax, [di] ;if the value in di is smaller than ax, it'll replace what's in ax
	jb lop1
	mov ax, [di]
	mov [bp+4], di ;saves the offset of the smallest value in the array
lop1:
	add di, 2 ;incrementing the offset of the array
	loop lop
	
	mov di, offset arr
	add di, [bp+8]
	mov [word ptr bp+6], di ;pass by reffernce to Swap of the firt variable in the array
	
	pop cx ;end black box
	pop ax
	pop di
	
   pop bp
  ret	
endp min
proc swap
   push bp
   mov bp, sp
   
   push di ;black box
   push bx
   push ax
   push si
   
   mov di, [bp+6] ;recives the offset of the first variable in the array
   mov ax, [di]
   
   mov bx, [bp+4] ;recives the offset of the smallest variable in the array
   mov si, [bx]
   
   mov [di], si ;incerts the smallest value in the array to the offset of the first variable in the array
   mov [bx], ax ;incerts the first value in the array to the smallest variable in the array
   
   pop si ;end black box
   pop ax
   pop bx
   pop di
   
   pop bp
  ret 4
endp swap
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------
    xor di, di
lopop:
    xor ax, ax
	push di ;save start point
	mov bx, offset arr ;sets bx to point to the start of the array
	add bx, di
check:
	cmp [word ptr bx], 0 ;if the value in bx is 0, it means the array is over
	jz exi_check
	add bx, 2
	inc ax
	jmp check
exi_check:
    
	cmp ax, 0 ;if there are zero variables in the array, it exits the program
	jz exit
	
	push ax ;saves the amount of variables in the array (pass by value)
	
	shl ax, 1
	dec ax
	cmp ax, di
	jz exit
	
	mov bx, offset arr
	add bx, di
	push bx ;save the offset of the array (pass by reffernce)
	
    call min
	call swap
	pop di
    add di, 2
	jmp lopop
done:
exit:
	mov ax, 4c00h
	int 21h
END start