    
close all;
clear;
clc;

%%
% CHIRP
%%%% SETUP INICIAL
fs = 48e3;
Ts = 1/fs;

tempo_inicial = 0;
tempo_final = 2.08332; %tempo pra dar mil amostras a 48kHz

fc = 7.5e3;
meia_banda = 2.5e3;

freq_inicial = fc - meia_banda;
freq_final = fc + meia_banda;


tempo = tempo_inicial:Ts:tempo_final;

%%%%
x_chirp = chirp(tempo,freq_inicial, tempo_final, freq_final);

L = nextpow2(length(x_chirp));
N_FFT = 2^L;

X_chirp = fftshift(fft(x_chirp,N_FFT));

f = fs/2*linspace(-1,1,N_FFT);


%% Plot do chirp
fontname = 'Times New Roman';
fontsize = 20;
linewidth = 3;

plot(f*1e-3,abs(X_chirp),'linewidth',linewidth);
xlabel('f (kHz)','fontname',fontname,'fontsize',fontsize,'interpreter','latex');
ylabel('|X(f)|','fontname',fontname,'fontsize',fontsize);

set(gca,'fontname',fontname,'fontsize',fontsize-3);

%%
% parameters explanation 
%
%function [h,delay,powerTaps,varargout] = acousticChannel(type,T,'N_paths','delayMean','powerDifference','Tg')

%type: variante ou invariante
%T: periodo de amostragem
%'N_paths': número de paths
%'delayMean': média do histograma dos atrasos
%'powerDifference': quanto em db que cai em tg de tempo
%'Tg': Tempo de guarda

T = Ts;
number_paths = 30; 
distance = 3e3;
c = 1500;
delay_mean = (distance/(c*number_paths)); 
guard_time = 2;
power_difference = 20; 

[h,~,~] = acousticChannel('invariant',T,'N_paths',number_paths,'delayMean',delay_mean,'powerDifference',power_difference,'Tg',guard_time);

%% PLOTTING
figure; 
stem((h))

y = conv(x_chirp,h);

%% PLOTTING
figure; 
plot((y))

%% SAVING

filename_original = 'chirp.wav';
audiowrite(filename_original,x_chirp,fs);

filename_saida = 'saida.wav';
audiowrite(filename_saida,y,fs);

save('./sinais.mat','x_chirp','y','h');


