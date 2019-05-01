.data
	vetor: .space 40
	msg: .asciiz "Entre com o tamanho do vetor:"
	msgInsiraValor: .asciiz "º valor: "
	msgVetorOrdenado: .asciiz "Vetor ordenado: "
	virgula: .asciiz ", "
.text

main:
	la $a0, vetor #endereço base do vetor
	la $a0, msg
	li $v0, 4
	syscall					#Imprime a mensagem
	
	li $v0, 5
	syscall
	add $s0, $v0, $zero			#Salva o tamanho em $s0
	
	jal PegaValores
	jal BubbleSort
	move $a2, $v0
	jal imprimeVetor
	j exit

#Pega os valores digitados do usuário e insere no vetor passado como parametro
#Parametros
#$a0: endereço base do vetor
# $s0: tamanho do vetor

PegaValores:
  move $t3, $a0 #move endereço base do vetor para t3
	li $t0, 0 #i=0
	addi $t2, $s0, -1 #length - 1
	PegaValores.while:
		li $v0, 1
		addi $a0, $t0, 1
		syscall  
		    
		li $v0, 4
		la $a0, msgInsiraValor
		syscall  
		
		li $v0, 5
		syscall
		
		sll $t1, $t0, 2 #calcula o endereçamente de 4 bytes
		add $t1, $t3, $t1
		sw $v0, ($t1) #insere valor no vetor em memoria
		
		bge $t0, $t2, PegaValores.fimWhile
		addi $t0, $t0, 1 #i++
		j PegaValores.while
		
		PegaValores.fimWhile:
    		move $a0, $t3 #retorna o valor de $a0
			jr $ra


#Ordena o vetor passado como parametro usando Insertion sort
# INSERE CODIGO AQUI
#Imprime um vetor 

imprimeVetor:   
	move $t4, $a0 #coloca o endereço base em $t4
	li $v0, 4
	la $a0, msgVetorOrdenado
	syscall  
	
	li $t0, 0 #i=0
 	addi $t2, $s0, -1 #length - 1
	imprimeVetor.for: bgt $t0, $t2, imprimeVetor.fimFor
		sll $t3, $t0, 2 #calcula o endereçamenteo de 4 bytes do i
		add $t3, $t4, $t3
		lw $t3, ($t3) #$t3 = vetor[i]
		
		li $v0, 1
		move $a0, $t3
		syscall  
		
		li $v0, 4
		la $a0, virgula
		syscall  
		
		addi $t0, $t0, 1 #i++
		j imprimeVetor.for
		imprimeVetor.fimFor:
		li $v0, 1
		#move $a0, $a2
		#syscall  
		
		jr $ra

exit:
	#finaliza o programa
	li $v0, 10
	syscall
		
