clear;
close all;
addpath ('.\functions\');


%% CREATING RANDOM VECTOR FOR EXAMPLE

x = randn(1,200);

%% PLOTTING & SAVING IMAGE

linewidth = 2;
fontname = 'Times New Roman';
fontsize = 25;

figure;
plot(x,'linewidth', linewidth);
%xlim([0 600]);
ylabel('Normalized Amplitude','fontname',fontname,'fontsize',fontsize,'interpreter','latex');
xlabel('Time~(ms)','fontname',fontname,'fontsize',fontsize,'interpreter','latex');
set(gca,'fontsize',fontsize,'fontname',fontname);
figProp = struct('size',fontsize,'font',fontname,'lineWidth',linewidth,'figDim',[0 0 800 600]);
figureName = ['name'];
formatFig(gcf,figureName,'en',figProp);


