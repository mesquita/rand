clear;
close all;
addpath ('.\functions\');


linewidth = 2;
fontname = 'Times New Roman';
fontsize = 25;
code = '';

for jj = 1:3
    
    %generating the signal
    x = randn(1,200);
    
    figure;
    plot(x,'linewidth', linewidth);
    %xlim([0 600]);
    ylabel('Amplitude','fontname',fontname,'fontsize',fontsize,'interpreter','latex');
    xlabel('Samples','fontname',fontname,'fontsize',fontsize,'interpreter','latex');
    set(gca,'fontsize',fontsize,'fontname',fontname);
    figProp = struct('size',fontsize,'font',fontname,'lineWidth',linewidth,'figDim',[0 0 800 600]);
    figureName = ['x_' num2str(jj)];
    formatFig(gcf,['./figs/' figureName],'en',figProp);
    
    titulo = ['This is ' num2str(jj) 'th x'];
    latex_code = beamerGenerator(code , titulo , figureName);
    code = [latex_code];
    
    
    close(gcf); %closes the window 
end

save('./code/code.mat','code');



