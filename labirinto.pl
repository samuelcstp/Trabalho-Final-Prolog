% Mapa do Labirinto com conexões entre as salas
porta(entrada, sala_armas).
porta(sala_armas, caverna_escura).
porta(caverna_escura, ponte_troll).
porta(ponte_troll, saida).

porta(entrada, corredor_fogo). % Na entrada são duas opções de sala
porta(corredor_fogo, saida).

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
    derrota(Item, Monstro),
    member(Item, Inventario).

% Caso base da recursão:
% Se a sala atual for igual ao destino,
% significa que o caminho foi encontrado.
% Nesse momento:
% - adiciona o destino na rota atual
% - inverte a lista (porque ela foi montada ao contrário)
% - gera a rota final correta
escapar(Destino, Destino, _, RotaAtual, RotaFinal) :- 
    reverse([Destino|RotaAtual], RotaFinal).

% Passo recursivo que tenta ir para uma próxima sala conectada
escapar(Atual, Destino, Inventario, RotaAtual, RotaFinal) :-
    conectado(Atual, ProximaSala),
    \+ member(ProximaSala, RotaAtual),    % Não volta por onde já passou
    sobrevive(ProximaSala, Inventario),   % Só avança se não morrer para o monstro
    escapar(ProximaSala, Destino, Inventario, [Atual|RotaAtual], RotaFinal).

% Facilidade para testar rapidamente (Sempre parte da entrada para a saida)
jogar(Inventario, RotaQueFuncionou) :-
    escapar(entrada, saida, Inventario, [], RotaQueFuncionou).
