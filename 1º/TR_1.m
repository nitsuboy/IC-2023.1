% Inteligencia Computacional 2023.1
% Prof. Jarbas Joaci
% Nome: Nicolas Douglas de Araujo Carneiro

clc
clear
close all

% Temperatura media do destino
T = input("Digite o valor da temperatura media do destino\n")
% Umidade media do destino
U = input("Digite o valor da umidade media do destino\n")
% Proximidade a grandes massas de agua
P = input("Digite o valor da proximidade a grandes massas de agua\n")
% Industrialização do destino
I = input("Digite o valor da industrialização do destino\n")

% x com passamento de 5 como no livro
x = 5:5:100;

% Vetor com todo o conjunto nebuloso
% trimf = max(min((x−a)/(b−a),(c−x)/(c−b)),0)
% trapmf = max(min((x−a)/(b−a),1,(d−x)/(d−c)),0) função para calcular o
% pertencimento dentro do sistema 
t = [% Temperatua alta
     trimf(T,[25 100 100]);
     % Temperatua baixa
     trimf(T,[0 0 75]);
     % Umidade alta
     trimf(U,[0 100 100]);
     % Umidade baixa
     trimf(U,[0 0 100]);
     % Corpos de agua perto
     trapmf(P,[0 0 10 40]);
     % Corpos de agua longe
     trapmf(P,[10 40 50 50]);
     % Industrialização alta
     trapmf(I,[10 20 100 100]);
     % Industrialização baixa
     trapmf(I,[0 0 10 20])];

% Regras
r = [funcaoE([t(1,1) t(3,1) t(5,1) t(8,1)]);
     t(7,1);
     funcaoOu([t(3,1) funcaoE([t(1,1) t(8,1) t(5,1)])]);
     funcaoE([t(2,1) t(4,1)])];

% Dose fuzificada
df = [r(4,1);
      r(2,1);
      max([r(1,1) r(3,1)])];

% Conjunto nebuloso da dose
% Dose muito baixa
pqm = trimf(x,[0 0 10]);
% Dose baixa
pqb = trimf(x,[0 0 50]);
% Dose alta
pqa = trimf(x,[40 100 100]);

% Junção de todas as funções para o calculo do centroide
jun = max( ...
      max(min(pqm,df(1,1)),min(pqb,df(2,1))), ...
      min(pqa,df(3,1)) ...
      );

% Calculo do centroide
dose = sum(jun.*x)/sum(jun)

% Não exite nenhum outro motivo dessas funções alem de identificação 
function ou = funcaoOu(A)
    ou = max(A);
end

function ee = funcaoE(A)
    ee = min(A);
end



