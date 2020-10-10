DSEG AT 30H
	N:	DS 	1
	K:	DS	1

CSEG AT 0
	MOV		DPTR, #N_IN		; Moving N to internal memory.
	MOV		R0, #N
	MOVC	A, @A + DPTR
	MOV		@R0, A
	MOV		R0, #K			; Dividend k (initially N)
	MOV 	@R0, N

DIVIDE:
	MOV 	A, N			; A = N
	MOV 	B, @R0			; B = k 			(k_0 = N)
	DIV		AB				; A = N/k, @R0 = k 	(A_0 = N/N, k_0 = N)
	INC		A				; A is incremented for proper rounding
	
	ADD 	A, @R0			; A = N/k + k 		(A_0 = N + 1)
	MOV		B, #2			; B = 2
	DIV		AB				; A = (N/k + k)/2 	(A_0 = (N + 1)/2)
	
 	MOV		B, A			; Check if k_i = k_(i+1) (square root found)
 	SUBB	A, R7
	JZ		STOP
	MOV		A, B			; Restore A to its previous value if sqrt is not found.
	
	MOV		@R0, A			; k = (N/k + k)/2	(k_1 = (N/k_0 + k_0)/2)
	MOV		R7, A			; Calculated k is saved for future comparison.
	SJMP	DIVIDE
	
N_IN:	DB 	19
	
STOP:
	SJMP	STOP
	
END
	