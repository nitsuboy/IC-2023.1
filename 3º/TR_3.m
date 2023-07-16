% Inteligencia Computacional 2023.1
% Prof. Jarbas Joaci
% Nome: Nicolas Douglas de Araujo Carneiro

clc
clear
close all

s = [1 1 1 1 1 1 1 1 1 1 1 1 1 ...
     2 2 2 2 2 2 2 2 2 2 2 2 ...
     3 3 3 3 3 3 3 3 3 3 3 ...
     4 4 4 4 4 4 4 4 4 4 ...
     5 5 5 5 5 5 5 5 5 ...
     6 6 6 6 6 6 6 6 ...
     7 7 7 7 7 7 7 ...
     8 8 8 8 8 8 ...
     9 9 9 9 9 ...
     10 10 10 10 ...
     11 11 11 ...
     12 12 ...
     13 ];

t = [2 3 4 5 6 7 8 9 10 11 12 13 14 ...
     3 4 5 6 7 8 9 10 11 12 13 14 ...
     4 5 6 7 8 9 10 11 12 13 14 ...
     5 6 7 8 9 10 11 12 13 14 ...
     6 7 8 9 10 11 12 13 14 ...
     7 8 9 10 11 12 13 14 ...
     8 9 10 11 12 13 14 ...
     9 10 11 12 13 14 ...
     10 11 12 13 14 ...
     11 12 13 14 ...
     12 13 14 ...
     13 14 ...
     14];
distancias = [1 2 4 6 2 2 3 3 5 6 1 4 5 ...
             3 2 1 3 6 3 4 4 2 4 4 4 ...
             1 3 3 2 3 4 1 3 5 5 6 ...
             5 1 4 2 3 4 4 8 2 2 ...
             2 1 6 5 2 3 4 2 2 ...
             3 1 2 3 5 7 3 4 ...
             2 1 2 5 2 4 3 ...
             5 5 1 5 3 6 ...
             1 4 4 5 3 ...
             5 4 4 2 ...
             4 2 1 ...
             1 3 ...
             1];

% Grafo dado nas instruções
G = graph(s,t,distancias);

tampopulacao = 200;
populacao = zeros(tampopulacao, 14);
geracoes = 100;
mutante = 0.1;

melhordistgeracao = zeros(geracoes, 1);
melhorpercursogeracao = zeros(geracoes, 14);
fitness = zeros(tampopulacao, 1);

for i = 1:tampopulacao
    populacao(i, :) = randperm(14);
end
melhordist = zeros(tampopulacao,1);

% Execução
for geracao = 1:geracoes

    for i = 1:tampopulacao
        individual = populacao(i, :);
        melhordist(i) = 0;
        for j = 1:13
            melhordist(i) = melhordist(i) + G.Edges.Weight(findedge(G,individual(j),individual(j+1)),1);
        end
        melhordist(i) = melhordist(i) + G.Edges.Weight(findedge(G,individual(14),individual(1)),1);
        fitness(i) = 1 / melhordist(i)^4;
    end

    % Seleção por roleta viciada
    prob = fitness / sum(fitness);
    pais = randsample(1:tampopulacao,tampopulacao,true,prob);
    
    % Reprodução
    filhos = zeros(tampopulacao, 14);
    for i = 1:2:tampopulacao
        parent1 = populacao(pais(i), :);
        parent2 = populacao(pais(i+1), :);

        binario = [0 0 0 0 0 0 0 1 1 1 1 1 1 1];
        binario = binario(randperm(14));
        
        % Realização do crossover
        filhos(i, :) = crossover(parent1, parent2, binario);
        filhos(i+1, :) = crossover(parent2, parent1, binario);
    end
    
    % Mutação
    for i = 1:tampopulacao
        if rand < mutante
            vi = sort(randperm(14, 2));
            v = filhos(i, vi);
            filhos(i,fliplr(vi)) = v;
        end
    end
    
    [melhordistgeracao(geracao),bestindex] = min(melhordist);
    melhorpercursogeracao(geracao,:) = populacao(bestindex, :);
    
    fprintf('Geração %d: %d\n', geracao, min(melhordist));

    populacao = filhos;
end


[melhordistancia, Index] = min(melhordistgeracao);
melhorpercurso = melhorpercursogeracao(Index, :);
fprintf('\nMenor distância achada: %d\n', melhordistancia);
fprintf('Percurso: ');

figure;
p = plot(G,"LineStyle","-",'Layout','force','WeightEffect','direct');
title('Percurso feito');
for i = 1:13
    fprintf('%d ', melhorpercurso(i));
    highlight(p,melhorpercurso(i),melhorpercurso(i+1),'NodeColor','red','EdgeColor','red','LineWidth',2)
end
fprintf('%d\n', melhorpercurso(14));

figure;
plot(1:geracoes, melhordistgeracao);
title('Distacia por geração');
xlabel('Geração');
ylabel('Distância');

% Função auxiliar para realizar o crossover sem repetição de cidades
function filho = crossover(pai1, pai2, binario)
    filho = zeros(1,14);
    for i = 1:14
        if binario(i) == 1
            filho(i) = pai1(i);
        end
    end
    for i = 1:14
        if ~ismember(pai2(i),filho)
            filho(find(filho == 0, 1)) = pai2(i);
        end
    end
end
