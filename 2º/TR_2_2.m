% Inteligencia Computacional 2023.1
% Prof. Jarbas Joaci
% Nome: Nicolas Douglas de Araujo Carneiro

clc
clear
close all

% Carregar os dados
dados = load('iris_log.dat');

% Obter o número de amostras e atributos dos dados
[nAmostras, nAtributos] = size(dados);

% Definição dos parametros da rede
nCentros = 7;  % Número de centros/neuronios
tAprendizado = 0.01;  % Taxa de aprendizado
nEpocas = 500;  % Número de épocas de treinamento
k = 5; % Numero de "folds"

% Embaralhamento dos indices e separação em 5 partes diferentes
kfold = reshape(randperm(length(dados))',[],k);

% Dividir os dados em atributos e classes
X = dados(:, 1:4);  % Atributos
Y = dados(:, 5:7);  % Classes

% Normalização dos Atributos
X = normalize(X);

% Seleciona os centros aleatoriamente entre os atributos
centros = X(randperm(nAmostras, nCentros), :);
% Definir um sigma, utilizando o desvio padrão das distancias entre os
% centros pode produzir uma acuracia melhor porem um 1 tambem faz o serviço
% sigma = std(pdist(centros));
sigma = 1;

% Inicializar a matriz de pesos dos neurônios de saída de forma aleatória
W = randn(nCentros, size(Y, 2));

% Inicializar a matriz de acuracias
acuracias = zeros(1,k);

% Loop para cada "fold"
for fold = 1:k
    disp(['Rodada ', num2str(fold)]);
    
    % Obter os conjuntos de treinamento/teste para esta rodada
    foldX = X(kfold(:,fold), :);
    foldY = Y(kfold(:,fold), :);
    
    % Treinamento da rede RBF
    for epoca = 1:nEpocas

        % Cálculo da gaussiana
        G = exp(-(pdist2(foldX, centros).^2 / (2*sigma.^2)));
        Prev = G * W;
        
        % Cálculo do erro
        erro = foldY - Prev;
        
        % Atualização dos pesos
        dW = tAprendizado * G' * erro;
        W = W + dW;
        
    end
    
    % Teste da rede
    Gteste = exp(-(pdist2(foldX, centros).^2 / (2*sigma.^2)));
    Prevteste = Gteste * W;
    
    % Cálculo da acurácia
    [~, classesPrevistas] = max(Prevteste, [], 2);
    [~, classesReais] = max(foldY, [], 2);
    acuracias(fold) = sum(classesPrevistas == classesReais) / numel(classesReais);
    
    disp(['Acurácia: ', num2str(acuracias(fold) * 100), '%']);
end

% Calculo da acurácia média
disp(['Acurácia Média: ', num2str(mean(acuracias) * 100), '%']);

