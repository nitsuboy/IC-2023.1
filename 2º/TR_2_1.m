% Inteligencia Computacional 2023.1
% Prof. Jarbas Joaci
% Nome: Nicolas Douglas de Araujo Carneiro

clc
clear
close all

dados = load('two_classes.dat');

% Separa a database entre as codernadas de cada ponto e o resultado da classificação
pontos = dados(:, 1:2);
classes = dados(:, 3);

% Cria uma rede neural com 3 camadas ocultas cada uma com 10 neuronios
net = feedforwardnet([10 10 10]);

% Propriedades de parada do treinamento pra tentar fazer que ele fique o
% menos estranho possivel porem ainda sai uma bizarrice de vez em quando
net.trainParam.epochs = 500;
net.trainParam.min_grad = 1e-10;
net.trainParam.max_fail = 10;
net = train(net, pontos', classes');

% Grid com todos os pontos possiveis dentro das codernadas fornecidas pela
% database
[X, Y] = meshgrid(min(pontos(:, 1)):0.01:max(pontos(:, 1)), min(pontos(:, 2)):0.01:max(pontos(:, 2)));
Grid = [X(:), Y(:)];

% Passa os pontos do grid pela rede MLP para obter os resultados de
% classificação entre 1 e -1
Z = net(Grid')';

% Rearranjando o resultados da rede devolta em um Grid
Z = reshape(Z, size(X));
% plot3(X, Y, reshape(Z, size(X)))

plot(pontos(classes==1, 1), pontos(classes==1, 2), 'ro');
hold on;
plot(pontos(classes==-1, 1), pontos(classes==-1, 2), 'bx');
% Faz um contorno no "nivel" 0 (superficie de decisão) do eixo Z 
contour(X, Y, Z, [0 ,0], 'k');
legend('Classe 1', 'Classe -1', 'superfície de decisão');
hold off;