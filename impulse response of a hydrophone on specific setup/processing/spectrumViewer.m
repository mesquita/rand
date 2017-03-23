function [varargout] = spectrumViewer(signalIn,fs)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

lineWidth = 2;
fontName = 'Times New Roman';
fontSize = 25;

N = length(signalIn);
L = nextpow2(N);
N_fft = 2^L;

f = fs/2*linspace(0,1,N_fft/2+1);
% f = fs/2*linspace(-1,1,N_fft);

SignalOut = fft(signalIn,N_fft);

if (nargout == 0);
    
    figure;
    plot(f*1e-3,(abs(SignalOut(1:N_fft/2+1))),'-b','lineWidth',lineWidth);
    ylabel('Magnitude response','FontSize',fontSize,'FontName',fontName);
    xlabel('Frequency (in KHz)','FontSize',fontSize,'FontName',fontName);
    set(gca,'FontSize',fontSize,'FontName',fontName);
    
    xlim([0 fs*1e-3/2]);
    
    % figure;
    % plot(f,(abs([SignalOut(N_fft/2+2:end); SignalOut(1:N_fft/2+1)])),'-b','lineWidth',lineWidth);
    % ylabel('Magnitude response','FontSize',fontSize,'FontName',fontName);
    % xlabel('Frequency (in Hz)','FontSize',fontSize,'FontName',fontName);
    % set(gca,'FontSize',fontSize,'FontName',fontName);
    
    % xlim([-fs/2 fs/2]);
    
else

varargout{1} = SignalOut;
varargout{2} = f;

end

