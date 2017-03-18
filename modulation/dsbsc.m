% =================================== %
% PROGRAMMED BY SHEIKH MUKHTAR HUSSIN %
% =================================== %

%Edited by Vinicius M. de Pinho
%16-10-2016

%I edited the code to show a cos signal, instead of the previous
%triangular one. I modified all the comments.

%Also added the plot of a signal from a test for the analog communication
%course that I'm doing right now.


clear;

% ===============================
% DSBSC MODULATION SIGNAL (cos)
% ===============================

t1 = -0.1:1.e-4:0.1;
%baseband signal frequency
fo = 10;
%The baseband signal
m = ((3*cos((fo*2*pi*t1))) + 1);

% Frquency of carrier wave
fc = 500;                                            

%The carrier
c = cos(2*fc*pi*t1);

%Extra signal
x = (m + 4).*c;
figure;
plot (t1,x);
title('x(t) = [m(t) + 4].c');


% Modulation
dsb =  2*m.*c;

% ====================================
% De-Modulation By Synchoronous Method
% ====================================

dem = dsb.*c;

% ==============================
% Filtering out High Frequencies
% ==============================

a = fir1(25,1.e-3);
b = 1;
rec = filter(a,b,dem);

fl = length(t1);
fl = 2^ceil(log2(fl));
f = (-fl/2:fl/2-1)/(fl*1.e-4);
% Frequency Responce of Message Signal
mF = fftshift(fft(m,fl));       
 % Frequency Responce of Carrier Signal
cF =  fftshift(fft(c,fl));       
% Frequency Responce of DSBSC
dsbF = fftshift(fft(dsb,fl));  
% Frequency Responce of Recovered Message Signal
recF = fftshift(fft(rec,fl));                           

% =============================
% Ploting signal in time domain
% =============================

figure(1);
subplot(2,2,1);                                    
plot(t1,m);
title('Message Signal');
xlabel('{\it t} (sec)');
ylabel('m(t)');
grid;

subplot(2,2,2);
plot(t1,dsb);
title('DSBSC');
xlabel('{\it t} (sec)');
ylabel('DSBSC');
grid;

subplot(2,2,3);
plot(t1,dem);
title('De-Modulated');
xlabel('{\it t} (sec)');
ylabel('dem')
grid;

subplot(2,2,4);
plot(t1,rec);
title('Recovered Signal');
xlabel('{\it t} (sec)');
ylabel('m(t)');
grid;

% ================================
% Ploting Freq Responce of Signals
% ================================

figure(2);
subplot(2,2,1);                                         
plot(f,abs(mF));
title('Freq Responce of Message Signal');
xlabel('f(Hz)');
ylabel('M(f)');
grid;
axis([-600 600 0 500]);


subplot(2,2,2);
plot(f,abs(cF));
title('Freq Responce of Carrier');
grid;
xlabel('f(Hz)');
ylabel('C(f)');
axis([-600 600 0 500]);


subplot(2,2,3);
plot(f,abs(dsbF));
title('Freq Responce of DSBSC');
xlabel('f(Hz)');
ylabel('DSBSC(f)');
grid;
axis([-600 600 0 200]);

subplot(2,2,4);
plot(f,abs(recF));
title('Freq Responce of Recoverd Signal');
xlabel('f(Hz)');
ylabel('M(f)');
grid;
axis([-600 600 0 200]);