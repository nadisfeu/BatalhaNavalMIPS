 .data
	Play1_board: .space 40 #Declaro 40 bytes pra armazenar 10 inteiros 
	Play2_board: .space 40 #Declaro 40 bytes pra armazenar 10 inteiros
	Play1_preenche: .asciiz "\n Player1: Digite a posição para o barco:"
	Play2_preenche: .asciiz "\n Player2: Digite a posição para o barco:"
	Frota: .asciiz "\n sua frota ficou: "
	Play1_mire: .asciiz "\n Player1: Digite uma posição para atirar (de 1 a 10):"
	Play2_mire: .asciiz "\n Player2: Digite uma posição para atirar (de 1 a 10):"
	Acerto: .asciiz "\n voce derrubou uma embarcacao! :) \n"
	Erro: .asciiz "\n Que pena, voce errou! :( \n "
	Winner_Play1: .asciiz "\n  ******** Parabens o Player 1 venceu!! *********"
	Winner_Play2: .asciiz "\n  ******** Parabens o Player 2 venceu!! *********"
	Tabuleiro1: .asciiz "\n\t\t TABULEIRO P1 \n\t"
	Tabuleiro2: .asciiz "\n\t\t TABULEIRO P2 \n\t"
	traco: .asciiz " - "
	xix: .asciiz " X "
	bola: .asciiz " O "
	
	
	
.text
	la $a0, Play1_board #Carrego o endereço base do array Play1 no registrador $a0
	jal Board_init	#salta até a linha do procedimento
	la $a0, Play2_board #Carrego o endereço base do array Play2 no registrador $a0
	jal Board_init	#salta até a linha do procedimento
	
	la $a1, Play1_board #Carrego o endereço base do array Play1 no registrador $a0
	la $a2, Play2_board #Carrego o endereço base do array Play2 no registrador $a1
	jal Fill_Board #salta até a função fill board
	
	la $a1, Play1_board #Carrego o endereço base do array Play1 no registrador $a0
	la $a2, Play2_board #Carrego o endereço base do array Play2 no registrador $a1	
	jal Start_Game #salta até a função start game
	
	move $a3, $v1 # pega o resultado da função e passa pro parametro a0
	jal Winner	#chamada da função Winner
	
	j Fim
	
	###################################################################################
	
	Board_init:		         #Define o procedimento
		
		addi $sp, $sp, -12 # ajusta a pilha, criando espaço para 3 itens
		sw $a1, 8($sp) # salva reg. $a1 para usar depois
		sw $a2, 4($sp) # salva reg. $a2 para usar depois
		sw $a3, 0($sp) # salva reg. $a3 para usar depois

		addi $a1, $a1, 0	 #Define o valor 0 para o t1
		move $a2, $zero	 #Define o valor 0 para o t2 
		move $a3, $a0    #Define o a3 com o endereço de a0
		
		Loop:			         #Define o inicio para o Loop
			sw $a1, ($a3)		 #Atribuo o valor 0 no elemento do array
			addi $a3, $a3, 4	# adiciona mais 4 bits ao endereço
			addi $a2, $a2, 1	#adiciona mais 1 na flag
			bne $a2, 10, Loop	# condição do loop
		
		lw $a1, 0($sp) # restaura reg. $a1 para o caller
		lw $a2, 4($sp) # restaura reg. $a2 para o caller
		lw $a3, 8($sp) # restaura reg. $a3 para o caller
		addi $sp, $sp, 12 # ajusta pilha para excluir 3 itens
		
		jr $ra				# retorno da função 
	
	
	###################################################################################
	
	Fill_Board: 
		
		addi $sp, $sp, -16 # ajusta a pilha, criando espaço para 4 itens
		sw $t0, 12($sp) # salva reg. $t0 para usar depois
		sw $t1, 8($sp) # salva reg. $t1 para usar depois
		sw $t2, 4($sp) # salva reg. $t2 para usar depois
		sw $t3, 0($sp) # salva reg. $t3 para usar depois
		
		move $t0, $zero 
		addi $t1, $t1, 1
		
		Loop1:
			move $t2, $zero # salva t2 como 0
			addi $t2, $t2, 4 # define t2 como 4
			
			li $v0, 4    #carrega o serviço do sistema
			la $a0, Play1_preenche # carrega o endereço da frase
			syscall
			
			li $v0, 5  # ler os dados do teclado e armazena em V0
			syscall    # chamdaa do dsitema 
			
			
			mul $t2, $t2, $v0    # multiplica o valor de t2 com o valor lido em v0
			subi $t2, $t2, 4     #subtrai 4 bits para ajustar posição
			add $t2, $t2, $a1     # salva o endereço onde vai receber o valor 
			
			
			sw $t1, ($t2) 		#salva o valor 1 na posição desejada
			
			
			addi $t0, $t0, 1	# incremento de auxiliar pro Loop
			bne $t0, 4, Loop1       # condição do Loop
		
			
			move $t0, $zero		#reseta t0 para 0, sera o indice do array
			add $t0,$t0,$a1
			move $t1, $zero		#define t1 como 4, sera somado ao indice ate o fim do loop de impressao
			addi $t1,$t1,4
		
			li $v0, 4		#imprime texto base p mostrar frota montada
			la $a0, Frota
			syscall
		
			imprimir1:	
				lw $t2, ($t0)		#carrega valor do array em t2
				
				beq $t2,1,Bola1		# verifica se o valor do array é 1 e pula para a impressão de "O" caso positivo
				
				li $v0, 4	# se o valor verificado for diferente de 1 (0), é impresso o símbolo "-""	
				la $a0, traco
				syscall
				j reseta1
				
				Bola1:		#função que imprime "O" caso o valor do array seja 1
				li $v0, 4		
				la $a0, bola
				syscall
				
				reseta1:
				add $t0,$t1,$a1		#passa para o proximo indice
				addi $t1,$t1,4		#aumenta o contador e posteriomente o indice do array
				bne $t1,44,imprimir1	#finaliza o loop apos a decima posição
		
		
		
		
		move $t0,$zero
		move $t1,$zero
		addi $t1,$t1,1
		
		Loop2:
			move $t3, $zero # salva t3 como 0
			addi $t3, $t3, 4 # define t3 como 4
			
			li $v0, 4    #carrega o serviço do sistema
			la $a0, Play2_preenche # carrega o endereço da frase
			syscall
			
			li $v0, 5  # ler os dados do teclado e armazena em V0
			syscall    # chamdaa do dsitema 
			
			
			mul $t3, $t3, $v0    # multiplica o valor de t2 com o valor lido em v0
			subi $t3, $t3, 4     #subtrai 4 bits para ajustar posição
			add $t3, $t3, $a2    # salva o endereço onde vai receber o valor 
			
			
			sw $t1, ($t3)	      #salva o valor 1 na posição desejada
			
			
			addi $t0, $t0, 1	# incremento de auxiliar pro Loop
			bne $t0, 4, Loop2       # condição do Loop
		
			
			move $t0, $zero		#reseta t0 para 0, sera o indice do array
			add $t0,$t0,$a2
			move $t1, $zero		#define t1 como 4, sera somado ao indice ate o fim do loop de impressao
			addi $t1,$t1,4
			
			li $v0, 4		
			la $a0, Frota
			syscall
			
			imprimir2:	
			
				lw $t3, ($t0)		#carrega valor do array em t3
				
				beq $t3,1,Bola2		# verifica se o valor do array é 1 e pula para a impressão de "O" caso positivo
				
				li $v0, 4		# se o valor verificado for diferente de 1 (0), é impresso o símbolo "-""
				la $a0, traco
				syscall
				j reseta2
				
				Bola2:			#função que imprime "O" caso o valor do array seja 1
				li $v0, 4		
				la $a0, bola
				syscall
				
				reseta2:
				add $t0,$t1,$a2		#passa para o proximo indice
				addi $t1,$t1,4		#aumenta o contador e posteriomente o indice do array
				bne $t1,44,imprimir2	#finaliza o loop apos a decima posição
		
		
		lw $t0, 0($sp) # restaura reg. $t0 para o caller
		lw $t1, 4($sp) # restaura reg. $t1 para o caller
		lw $t2, 8($sp) # restaura reg. $t2 para o caller
		lw $t3, 12($sp) # restaura reg. $t3 para o caller
		addi $sp, $sp, 12 # ajusta pilha para excluir 4 itens
		
		jr $ra
	
	###################################################################################
	# Função que alterna entre os jogadores e salva a jogada deles na posição seleionada 
	Start_Game:
		
		addi $sp, $sp, -24 # ajusta a pilha, criando espaço para 4 itens
		sw $t0, 24($sp) # salva reg. $t0 para usar depois
		sw $t1, 20($sp) # salva reg. $t1 para usar depois
		sw $t2, 16($sp) # salva reg. $t2 para usar depois
		sw $t3, 12($sp) # salva reg. $t3 para usar depois
		sw $t5, 8($sp) # salva reg. $t5 para usar depois
		sw $t6, 4($sp) # salva reg. $t6 para usar depois
		move $t9, $ra	# salva o valor de retorno do RA
		
		
		addi $t5, $t5, 2 # salva o registrador T5 com o valor 2 que sera usado posteriormente 
		addi $t6, $t6, 3 # salva o registrador T6 com o valor 3 que sera usado posteriormente 
		
		move $t1, $zero # salva o registrador T1 com o valor 0 uqe sera usado posteriormente 
		move $t2, $zero # salva o registrador T2 com o valor 0 uqe sera usado posteriormente 
		
		Player1_Turn:
			jal Impressao # chama a função de imprimir o tabuleiro 
			
			li $t0, 4 # define t0 como 4 
			
			li $v0, 4    #carrega o serviço do sistema
			la $a0, Play1_mire # carrega o endereço da frase
			syscall		# chamada do sistema 
			 
			li $v0, 5  # ler os dados do teclado e armazena em V0
			syscall  	# chamada do sistema
			
			mul $t0, $v0, $t0 #multiplica o valor recebido na leitura por 4 e salva em t0
			subi $t0, $t0, 4 #diminui 4 em t0 para acertar o endereço
			add $t0, $t0, $a2 # soma o o valor obtido com o endereço base do P2
			lw $t3, ($t0)  # carrega o valor para t3
			
			beq $t3, 1, acerto1 # verifica se foi um acerto
			
			li $v0, 4    #carrega o serviço do sistema
			la $a0, Erro # carrega o endereço da frase
			syscall
			sw $t6, ($t0) #salva o valor 3, onde foi o erro 
			
			
			j Player2_Turn
			
			acerto1:
			li $v0, 4    #carrega o serviço do sistema
			la $a0, Acerto # carrega o endereço da frase
			syscall
			sw $t5, ($t0) #salva o valor 2, onde foi acertado 
			addi $t1, $t1, 1 # conta mais uma embarcação derrubada   
			
			bne $t1, 4, Player2_Turn # faz a comparação para a quantidade de embarcações derrubadas do p2
			li $v1, 1 # salva o valor 1 que vai ser usado na função Winner 
			
			j venceu
			
		Player2_Turn:	
			jal Impressao # chama a função de imprimir o tabuleiro
			
			li $t0, 4 # define t0 como 4
			
			li $v0, 4    #carrega o serviço do sistema
			la $a0, Play2_mire # carrega o endereço da frase
			syscall		# chamada do sistema
			
			li $v0, 5  # ler os dados do teclado e armazena em V0
			syscall
			
			mul $t0, $v0, $t0	#multiplica o valor lido por 4
			subi $t0, $t0, 4	# subtrai 4 casas para acertar os endereços
			add $t0, $t0, $a1	# soma o valor obtido no endereço base do p1
			lw $t3, ($t0)		# carrega o conteudo da posição em t3
			
			beq  $t3,1, acerto2	# verifica o acerto
			
			
			li $v0, 4    #carrega o serviço do sistema
			la $a0, Erro # carrega o endereço da frase
			syscall
			sw $t6, ($t0) #salva o valor 3, onde foi o erro 
			
			j Player1_Turn # salta para a vez do player 1
			
			acerto2:
			li $v0, 4    #carrega o serviço do sistema
			la $a0, Acerto # carrega o endereço da frase
			syscall
			sw $t5, ($t0) #salva o valor 2, onde foi acertado
			
			addi $t2, $t2, 1
			bne $t2, 4, Player1_Turn #compara se quantidade de barcos derrubados do p1 é igual a 4
			
			li $v1, 2 # salva o valor 2 que vai ser usado na função Winner 
			
		
		venceu:	
				
		lw $t0, 0($sp) # restaura reg. $t0 para o caller
		lw $t1, 4($sp) # restaura reg. $t1 para o caller
		lw $t2, 8($sp) # restaura reg. $t2 para o caller
		lw $t3, 12($sp) # restaura reg. $t3 para o caller
		lw $t5, 16($sp) # restaura reg. $t5 para o caller
		lw $t6, 20($sp) # restaura reg. $t6 para o caller
		addi $sp, $sp, 24 # ajusta pilha para excluir 4 itens
		
		move $ra, $t9  # restaura o valor de retorno do RA
		
		jr $ra
	
	
	#############################################################################################
	#função que vai fazer a impressão do tabuleiro atualizado
	Impressao:
		
		addi $sp, $sp, -12 # ajusta a pilha, criando espaço para 4 itens
		sw $t0, 12($sp) # salva reg. $t5 para usar depois
		sw $t3, 8($sp) # salva reg. $t6 para usar depois
		sw $t4, 4($sp) # salva reg. $t6 para usar depois
		
					
		li $v0, 4    #carrega o serviço do sistema
		la $a0, Tabuleiro1 # carrega o endereço da frase
		syscall	
		move $t3, $zero
		#loop
		move $t4, $a1 #carrega o endereço dp player2 em t4
			
		LoopInicio:
			#ler os valores da posição e salvar em T0
			lw $t0, ($t4) # salva o valor da posição em T4
			
			bne $t0, 1, Ehzero #compara o valor de t0 com 1, e 0 para imprimir traço
				li $v0, 4    #carrega o serviço do sistema
				la $a0, traco # carrega o endereço da frase
				syscall
			Ehzero:
			bne $t0, 0, doisOuTres
				li $v0, 4    #carrega o serviço do sistema
				la $a0, traco # carrega o endereço da frase
				syscall
			j fimLoop
			doisOuTres:
			bne $t0, 2, Tres  # compara o valor com 3 para imprimir O
				li $v0, 4    #carrega o serviço do sistema
				la $a0, bola # carrega o endereço da frase
				syscall
			j fimLoop
			Tres: # imprime X se for 3
				bne $t0,3,fimLoop
				li $v0, 4    #carrega o serviço do sistema
				la $a0, xix # carrega o endereço da frase
				syscall
			j fimLoop
			
		fimLoop:
		
		addi $t4, $t4, 4
		addi $t3, $t3, 1
		bne $t3, 10, LoopInicio
		
		
		
		li $v0, 4    #carrega o serviço do sistema
		la $a0, Tabuleiro2 # carrega o endereço da frase
		syscall	
		
		move $t3, $zero
		move $t4, $a2 #carrega o endereço dp player2 em t4
		LoopInicio2:
			#ler os valores da posição e salvar em T0
			lw $t0, ($t4) # salva o valor da posição em T4
			
			bne $t0, 1, Ehzero2 #compara o valor de t0 com 1, e 0 para imprimir traço
				li $v0, 4    #carrega o serviço do sistema
				la $a0, traco # carrega o endereço da frase
				syscall
			Ehzero2:
			bne $t0, 0, doisOuTres2
				li $v0, 4    #carrega o serviço do sistema
				la $a0, traco # carrega o endereço da frase
				syscall
			j fimLoop2
			doisOuTres2:
			bne $t0, 2, Tres2  # compara o valor com 3 para imprimir O
				li $v0, 4    #carrega o serviço do sistema
				la $a0, bola # carrega o endereço da frase
				syscall
			j fimLoop2
			Tres2: # imprime X se for 3
				bne $t0,3,fimLoop2
				li $v0, 4    #carrega o serviço do sistema
				la $a0, xix # carrega o endereço da frase
				syscall
			
		fimLoop2:
		addi $t4, $t4, 4
		addi $t3, $t3, 1
		bne $t3, 10, LoopInicio2
		
		lw $t0, 0($sp) # restaura reg. $t0 para o caller
		lw $t3, 4($sp) # restaura reg. $t1 para o caller
		lw $t4, 8($sp) # restaura reg. $t2 para o caller
		addi $sp, $sp, 12 # ajusta pilha para excluir 4 itens
	
	jr $ra
	
	
	###############################################################			
			
	# A função vai receber como parametro um numero 1, ou 2 e irá devolver quem foi o vencedor a partir disso
	Winner:
		
		bne $a3, 1, jump # faz o teste se o a3 é 1 ou não
		li $v0, 4	# parametro para o sistema
		la $a0, Winner_Play1 # carrega o endereço da frase
		syscall 	#chamda do sistema 
		j jump2
		
		jump:
		li $v0, 4 # paramtro para o sistema 
		la $a0, Winner_Play2 # carrega o endereço da frase
		syscall 	#chamda do sistema 
		
		jump2:
		jr $ra	
			
	
									
																									
	Fim:				 
	jal Impressao #chamada da função de impressão da tabela 
	
