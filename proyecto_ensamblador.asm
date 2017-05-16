
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
		
guardarNodo:
		
		;Se encontrará el último nodo, aquel cuyo enlace contenga un 0, se llamará a la función guardarNumero
		;Con el número a guardar en Y y la dirección del último nodo en X
		
		
		ldx pilaS		;Se carga la dirección de pilaS
		ldd -2,x		;Se carga el enlace del nodo
		cmpd #0			;Se compara este enlace con el 0
		beq	guardarNumero	;Si es el último nodo, se guarda aquí el número
		leax [-4,x]		;Se carga la dirección efectiva del siguiente nodo en X
		bra guardarNodo	;Repetir
		
guardarNumero:
		
		tfr x,d			;Se carga 4 posiciones más hallá del último nodo 
		subd #4
		tfr d,x
		
		tfr y,d			;Se guarda el número en el registro y en el nodo
		sta ,x
		stb -1,x
		
		ldd #0			;Se guarda el enlace de éste, el último nodo, con 0
		sta -2,x
		stb -3,x
		
		tfr x,y			;Se guarda ahora la dirección del nodo creado en Y
		leax [-4,x]		;Se carga la dirección del nodo anterior
		sty -2,x			;Se guarda la dirección del nodo creado en el anterior nodo
		
		rts
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Pasar a X la dirección pilaS
preEliminaNodo:
		;Primero se encuentra el primer nodo válido, y la dirección de la lista se convertirá en su dirección 
		cmpx #0
		beq retorno ;No se encontraron nodos válidos
		
		lda ,x
		ldb -1,x
		cpmd mayor
		blo aceptar
		bhs denegar
		
denegar:

		leax [-4,x]
		bra preEliminaNodo

aceptar:
		stx pilaS
		ldx pilaS
		tfr x,u
		bra eliminaNodo

eliminaNodo:
		;U se utilizará para referenciar al último nodo válido encontrado

		cmpx #0		;Se compara X con 0
		beq retorno	;De ser 0, sale de la subrutina
		
		lda ,x		;Carga en d el número, para comprobar si es mayor que "mayor"
		ldb -1,x
		cmpd mayor
		blo nodoValido
		leax [-4,x]
		stu -2,x
		bra eliminaNodo
		
		
nodoValido:
		leau [x]	;Si es válido, se almacena su dirección
		leau [-4,x]	;Se guarda la dirección efectiva del siguiente nodo para comparar
		bra eliminaNodo
		
retorno:
		rts
