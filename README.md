# Relatório do Trabalho Final – Programação Lógica

## Introdução
Este projeto apresenta um jogo desenvolvido no paradigma lógico, utilizando a linguagem Prolog, como requisito para avaliação na disciplina de Programação Lógica. O objetivo do trabalho é demonstrar na prática os conceitos fundamentais do paradigma declarativo, tais como a definição de fatos, a criação de regras e, principalmente, o uso do motor de inferência e do *backtracking*.

## Descrição do Jogo
O jogo criado é  um mini-RPG no qual o jogador precisa encontrar a saída de um labirinto partindo da entrada. O labirinto é composto por várias salas interligadas. No entanto, algumas salas são habitadas por monstros (obstáculos). Para conseguir passar por uma sala que contenha um monstro, o jogador deve possuir em seu inventário o item (arma/feitiço) específico que derrota aquela criatura.

### Fatos
O domínio foi mapeado através de fatos simples:
- `porta(salaA, salaB).`: Define o mapa do labirinto (quais salas se conectam).
- `obstaculo(sala, monstro).`: Define qual monstro vive em cada sala.
- `derrota(item, monstro).`: Define a fraqueza de cada monstro (ex: a água derrota o dragão).

### Regras Principais
As regras ditam as condições de vitória e as restrições:
- `sobrevive(Sala, Inventario)`: Uma regra não trivial que infere que o jogador sobrevive se a sala for vazia (não possui obstáculo) ou se o jogador possui no inventário o item exigido pelo fato `derrota` referente ao monstro da sala.
- `escapar(Atual, Destino, Inventario, RotaAtual, RotaFinal)`: É o motor de busca do jogo. A regra busca recursivamente salas conectadas, verifica se a sobrevivência é possível e constrói a lista do caminho percorrido. Se ao  entrar numa sala e a regra de sobrevivência falhar, o Prolog realiza o backtracking naturalmente, retornando e tentando outra porta.


