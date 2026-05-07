% Mapa do Labirinto com conexões entre as salas
porta(entrada, sala_armas).
porta(sala_armas, caverna_escura).
porta(caverna_escura, ponte_troll).
porta(ponte_troll, saida).

porta(entrada, corredor_fogo). % Na entrada são duas opções de sala
porta(corredor_fogo, saida).


% ==========================================================
% INTERFACE VISUAL DO LABIRINTO
% ==========================================================

mostrarMapa(entrada) :-
    nl,
    write('================ LABIRINTO ================'), nl,
    write('                                            '), nl,
    write('               [CAVERNA] -- [TROLL] -- [SAIDA]'), nl,
    write('                    |                        '), nl,
    write('                 [ARMAS]                    '), nl,
    write('                    |                        '), nl,
    write(' @ -> [ENTRADA] -- [FOGO] -----> [SAIDA]   '), nl,
    write('                                            '), nl,
    write('============================================'), nl,
    nl.

mostrarMapa(sala_armas) :-
    nl,
    write('================ LABIRINTO ================'), nl,
    write('                                            '), nl,
    write('               [CAVERNA] -- [TROLL] -- [SAIDA]'), nl,
    write('                    |                        '), nl,
    write('               @ -> [ARMAS]                '), nl,
    write('                    |                        '), nl,
    write('            [ENTRADA] -- [FOGO] -----> [SAIDA]'), nl,
    write('                                            '), nl,
    write('============================================'), nl,
    nl.

mostrarMapa(caverna_escura) :-
    nl,
    write('================ LABIRINTO ================'), nl,
    write('                                            '), nl,
    write('          @ -> [CAVERNA] -- [TROLL] -- [SAIDA]'), nl,
    write('                    |                        '), nl,
    write('                 [ARMAS]                    '), nl,
    write('                    |                        '), nl,
    write('            [ENTRADA] -- [FOGO] -----> [SAIDA]'), nl,
    write('                                            '), nl,
    write('============================================'), nl,
    nl.

mostrarMapa(ponte_troll) :-
    nl,
    write('================ LABIRINTO ================'), nl,
    write('                                            '), nl,
    write('         [CAVERNA] -- @ [TROLL] -- [SAIDA]'), nl,
    write('                    |                        '), nl,
    write('                 [ARMAS]                    '), nl,
    write('                    |                        '), nl,
    write('            [ENTRADA] -- [FOGO] -----> [SAIDA]'), nl,
    write('                                            '), nl,
    write('============================================'), nl,
    nl.

mostrarMapa(corredor_fogo) :-
    nl,
    write('================ LABIRINTO ================'), nl,
    write('                                            '), nl,
    write('         [CAVERNA] -- [TROLL] -- [SAIDA]   '), nl,
    write('                    |                        '), nl,
    write('                 [ARMAS]                    '), nl,
    write('                    |                        '), nl,
    write('         [ENTRADA] -- @ [FOGO] -----> [SAIDA]'), nl,
    write('                                            '), nl,
    write('============================================'), nl,
    nl.

mostrarMapa(saida) :-
    nl,
    write('================ LABIRINTO ================'), nl,
    write('                                            '), nl,
    write('         [CAVERNA] -- [TROLL] -- [SAIDA]   '), nl,
    write('                    |                        '), nl,
    write('                 [ARMAS]                    '), nl,
    write('                    |                        '), nl,
    write('         [ENTRADA] -- [FOGO] -----> @ SAIDA'), nl,
    write('                                            '), nl,
    write('============================================'), nl,
    nl.


% O mapa é bidirecional, pode ir e voltar
conectado(X, Y) :- porta(X, Y).
conectado(X, Y) :- porta(Y, X).

% Monstros nas salas e o que os derrota
obstaculo(caverna_escura, morcegos).
obstaculo(ponte_troll, troll).
obstaculo(corredor_fogo, dragao).

derrota(tocha, morcegos).
derrota(espada, troll).
derrota(pocao_agua, dragao).

% Passa direto se a sala não tiver nenhum obstáculo
sobrevive(Sala, _) :- 
    \+ obstaculo(Sala, _).

% Passa se tiver no inventário o item que derrota o monstro
sobrevive(Sala, Inventario) :-

    obstaculo(Sala, Monstro),

    write('Monstro encontrado: '),
    write(Monstro), nl,

    derrota(Item, Monstro),

    member(Item, Inventario),

    write('Usando item: '),
    write(Item), nl,

    write('Monstro derrotado!'), nl.


% Caso base da recursão:
% Se a sala atual for igual ao destino,
% significa que o caminho foi encontrado.
% Nesse momento:
% - adiciona o destino na rota atual
% - inverte a lista (porque ela foi montada ao contrário)
% - gera a rota final correta
escapar(Destino, Destino, _, RotaAtual, RotaFinal) :-

    nl,
    write('===================================='), nl,
    write('VOCE ENCONTROU A SAIDA DA MASMORRA!'), nl,
    write('===================================='), nl,

    mostrarMapa(Destino),

    write('Cheguei no destino: '),
    write(Destino), nl,

    reverse([Destino|RotaAtual], RotaFinal),

    write('Rota final encontrada: '),
    write(RotaFinal), nl,
    nl.


% Regra recursiva
escapar(Atual, Destino, Inventario, RotaAtual, RotaFinal) :-

    mostrarMapa(Atual),

    write('Estou na sala: '),
    write(Atual), nl,

    write('Inventario atual: '),
    write(Inventario), nl,

    write('Rota percorrida ate agora: '),
    write(RotaAtual), nl, nl,

    conectado(Atual, ProximaSala),

    write('Tentando ir para: '),
    write(ProximaSala), nl,

    \+ member(ProximaSala, RotaAtual),

    write('Sala ainda nao visitada'), nl,

    sobrevive(ProximaSala, Inventario),

    write('Sobreviveu na sala: '),
    write(ProximaSala), nl,

    write('Continuando exploracao...'), nl, nl,

    escapar(
        ProximaSala,
        Destino,
        Inventario,
        [Atual|RotaAtual],
        RotaFinal
    ).

% Facilidade para testar rapidamente
% Para na primeira rota válida encontrada
jogar(Inventario, RotaQueFuncionou) :-

    nl,
    write('===================================='), nl,
    write('INICIANDO EXPLORACAO DA MASMORRA...'), nl,
    write('===================================='), nl,

    write('Inventario inicial: '),
    write(Inventario), nl, nl,

    once(
        escapar(
            entrada,
            saida,
            Inventario,
            [],
            RotaQueFuncionou
        )
    ).