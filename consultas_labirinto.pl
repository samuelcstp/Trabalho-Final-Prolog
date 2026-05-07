:- [labirinto].

% ==========================================================
% CONSULTAS PARA APRESENTAÇÃO - A Masmorra
% ==========================================================

% 1. O aventureiro entra SEM NADA no inventário. O que acontece?
% ?- jogar([], Rota).
% (Retorna: false - Ele morre nos dois caminhos possíveis!)

% 2. O aventureiro entra apenas com uma poção de água. 
% O Prolog percebe que a caverna escura tem morcegos (falha), 
% faz BACKTRACKING e tenta o corredor de fogo. Como a água derrota o dragão, ele passa!
% ?- jogar([pocao_agua], Rota).
% (Retorna: Rota = [entrada, corredor_fogo, saida])

% 3. E se ele entrar com a Tocha e a Espada?
% O Prolog tenta o caminho da caverna, mata os morcegos com a tocha e o troll com a espada!
% ?- jogar([tocha, espada], Rota).
% (Retorna: Rota = [entrada, sala_armas, caverna_escura, ponte_troll, saida])

% 4. Consulta clássica de inferência: "O que eu preciso levar para sobreviver ao dragão?"
% ?- derrota(Arma, dragao).
% (Retorna: Arma = pocao_agua)

% 5. Consulta sobre conexões: "Posso chegar da entrada direto no dragão?"
% ?- conectado(entrada, corredor_fogo).
% (Retorna: true)
