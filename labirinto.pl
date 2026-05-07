% Mapa do Labirinto com conexões entre as salas
porta(entrada, sala_armas).
porta(sala_armas, caverna_escura).
porta(caverna_escura, ponte_troll).
porta(ponte_troll, saida).

porta(entrada, corredor_fogo). % Na entrada são duas opções de sala
porta(corredor_fogo, saida).

% ==========================================================
% INTERFACE VISUAL DO LABIRINTO (Seus desenhos originais)
% ==========================================================

mostrarMapa(entrada) :-
    nl, write('================ LABIRINTO ================'), nl,
    write('               [CAVERNA] -- [TROLL] -- [SAIDA]'), nl,
    write('                    |                        '), nl,
    write('                 [ARMAS]                    '), nl,
    write('                    |                        '), nl,
    write(' @ -> [ENTRADA] -- [FOGO] -----> [SAIDA]   '), nl,
    write('============================================'), nl, nl.

mostrarMapa(sala_armas) :-
    nl, write('================ LABIRINTO ================'), nl,
    write('               [CAVERNA] -- [TROLL] -- [SAIDA]'), nl,
    write('                    |                        '), nl,
    write('               @ -> [ARMAS]                '), nl,
    write('                    |                        '), nl,
    write('            [ENTRADA] -- [FOGO] -----> [SAIDA]'), nl,
    write('============================================'), nl, nl.

mostrarMapa(caverna_escura) :-
    nl, write('================ LABIRINTO ================'), nl,
    write('          @ -> [CAVERNA] -- [TROLL] -- [SAIDA]'), nl,
    write('                    |                        '), nl,
    write('                 [ARMAS]                    '), nl,
    write('                    |                        '), nl,
    write('            [ENTRADA] -- [FOGO] -----> [SAIDA]'), nl,
    write('============================================'), nl, nl.

mostrarMapa(ponte_troll) :-
    nl, write('================ LABIRINTO ================'), nl,
    write('         [CAVERNA] -- @ [TROLL] -- [SAIDA]'), nl,
    write('                    |                        '), nl,
    write('                 [ARMAS]                    '), nl,
    write('                    |                        '), nl,
    write('            [ENTRADA] -- [FOGO] -----> [SAIDA]'), nl,
    write('============================================'), nl, nl.

mostrarMapa(corredor_fogo) :-
    nl, write('================ LABIRINTO ================'), nl,
    write('         [CAVERNA] -- [TROLL] -- [SAIDA]   '), nl,
    write('                    |                        '), nl,
    write('                 [ARMAS]                    '), nl,
    write('                    |                        '), nl,
    write('         [ENTRADA] -- @ [FOGO] -----> [SAIDA]'), nl,
    write('============================================'), nl, nl.

mostrarMapa(saida) :-
    nl, write('================ LABIRINTO ================'), nl,
    write('         [CAVERNA] -- [TROLL] -- [SAIDA]   '), nl,
    write('                    |                        '), nl,
    write('                 [ARMAS]                    '), nl,
    write('                    |                        '), nl,
    write('         [ENTRADA] -- [FOGO] -----> @ SAIDA'), nl,
    write('============================================'), nl, nl.

% O mapa é bidirecional
conectado(X, Y) :- porta(X, Y).
conectado(X, Y) :- porta(Y, X).

% Monstros e fraquezas
obstaculo(caverna_escura, morcegos).
obstaculo(ponte_troll, troll).
obstaculo(corredor_fogo, dragao).

derrota(tocha, morcegos).
derrota(espada, troll).
derrota(pocao_agua, dragao).
derrota(escudo, nada). % Sua arma inútil (estilo "magikarp")

% Regras de sobrevivência
sobrevive(Sala, _) :- \+ obstaculo(Sala, _).
sobrevive(Sala, Inventario) :-
    obstaculo(Sala, Monstro),
    derrota(Item, Monstro),
    member(Item, Inventario),
    format('Monstro encontrado: ~w! Usando ~w para derrota-lo!~n', [Monstro, Item]).

% Caso base: Fim da jornada
escapar(Destino, Destino, _, RotaAtual, RotaFinal) :-
    nl, write('===================================='), nl,
    write('VOCE ENCONTROU A SAIDA DA MASMORRA!'), nl,
    write('===================================='), nl,
    mostrarMapa(Destino),
    reverse([Destino|RotaAtual], RotaFinal),
    format('Rota final: ~w~n', [RotaFinal]).

% Regra recursiva corrigida com LOG DE DECISAO
escapar(Atual, Destino, Inventario, RotaAtual, RotaFinal) :-
    Atual \== Destino,
    mostrarMapa(Atual),
    format('Estou em: ~w | Inventario: ~w~n', [Atual, Inventario]),
    
    conectado(Atual, ProximaSala),
    \+ member(ProximaSala, RotaAtual),
    
    write('Tentando caminho por: '), write(ProximaSala), write('... '), 

    (sobrevive(ProximaSala, Inventario) -> 
        (
            write('Sucesso! Entrando em '), write(ProximaSala), nl,
            escapar(ProximaSala, Destino, Inventario, [Atual|RotaAtual], RotaFinal)
        )
        ;
        (
            write('PERIGO! Nao tenho o item para '), write(ProximaSala), nl,
            write('>> Backtracking: Voltando para '), write(Atual), write(' para buscar outra rota...'), nl,
            fail 
        )
    ).

% Predicado principal
jogar(Inventario) :-
    nl, write('--- INICIANDO EXPLORACAO ---'), nl,
    (once(escapar(entrada, saida, Inventario, [], _)) -> 
        true ; 
        (nl, write('GAME OVER: Voce ficou preso no labirinto!'), nl)
    ).