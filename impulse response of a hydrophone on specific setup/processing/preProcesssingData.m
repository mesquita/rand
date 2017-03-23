% UFRJ - Federal University of Rio de Janeiro
% Poli - Polytechnic School
% DEL  - Department of Electronic Engineering and Computation
% SMT  - Signals, Multimedia & Telecommuncations
%
% Authors: João P. K. Marques
%          Marcello L. R. de Campos
%          Maria L. C. Vianna
%          Rafael S. Chaves
%          Rebeca A. F. Cunha
%          Vinicius M. de Pinho
%
% Date: 03/01/2016
%
% abstract here
%
% CONTENT:
% 1. initialing cells
% 2. removing NaN and sorting delays and gain
% 3. aglutinando os ganhos próximos
% 4. deleting smaller gains
% 5. normalizing
% 6. Shifiting all delays relative to the absolute minimum
% 7. plotting for tests

load('./results/Results_3km.mat');

dim = size(ganho);  


% = 's' for plotting
doYouWannaPlot = '~';
%%
%#######################
% 1. initializing cells
delay = cell(dim);
gain = cell(dim);
temNaN = zeros(1,1e4);
i = 1;
min_delay = zeros(dim);
max_delay = zeros(dim);
media_delay = zeros(dim);
%#######################

%%
% 2. removing NaN and sorting delays and gain
for hydro = 1:dim(2)
    
    for chann = 1:dim(1)
        delay_aux = atraso{chann,hydro};
        gain_aux  = ganho{chann,hydro};
        
        NaN_positions = find(isnan(gain_aux) == 0);                    % Find NaN positions
        
        delay{chann,hydro} = delay_aux(NaN_positions);                 % New delay cell without NaN entries
        gain{chann,hydro}  = gain_aux(NaN_positions);                  % New gain cell without NaN entries
        
        [delay{chann,hydro},index] = sort(delay{chann,hydro});         % Sorting delays
        min_delay(chann,hydro) = min(delay{chann,hydro});              % Minimum delay in each channel realization
        max_delay(chann,hydro) = max(delay{chann,hydro});
        media_delay(chann,hydro) = (max_delay(chann,hydro) + min_delay(chann,hydro))/2;
        
        
        gain{chann,hydro} = gain{chann,hydro}(index);                  % Sorting gains
        
        %vendo se tem nan
        if (find(isnan(gain_aux) == 1))
            temNaN(1,i) = length(find(isnan(gain_aux) == 1));
            i = i + 1;
        end
    end
end
% end of 'removing NaN and sorting delays and gain'
%%
media_total = mean(mean(media_delay),2);

quantida_de_nan = sum(temNaN)
%%
%saving after removing NaN
gainAfterRemovingNaN = gain;
delayAfterRemovingNaN = delay;
%%

%%
% 3. aglutinando os ganhos

%[gain, delay] = aglutinandoRaios( gain , delay , 1e-5);
%%

%%
% saving before part 4
gainAfterAddingUp = gain;
delayAfterAddingUp = delay;
%%

%%
%4. deleting gain that are smaller than
for hydro = 1:dim(2)
    for chann = 1:dim(1)
        %1e-5
        
        isMore= (abs(gain{chann,hydro}) >= max(abs(gain{chann,hydro}))/100000);
        
        gain{chann,hydro} = gain{chann,hydro}(logical(isMore));
        delay{chann,hydro}= delay{chann,hydro}(logical(isMore));
        isMore = [];
    end
end
% end of 4.
%%

%%
%saving after deleting small gains
gainAfterDeletingSmallGains = gain;
delayAfterDeletingSmallGains = delay;
%%

%%
% 5. normalizing gains
for hydro = 1:dim(2)
    for chann = 1:dim(1)
        gain{chann,hydro} = gain{chann,hydro}/norm(gain{chann,hydro});
    end
end
%%


%%
%saving after normalizing
gainAfterNormalizingGains = gain;
delayAfterNormalizingGains = delay;
%%

%%
% 6. Shifiting all delays relative to the absolute minimum
abs_min = min(min_delay,[],1);
for hydro = 1:dim(2)
    for chann = 1:dim(1)
        %delay{chann,hydro} = delay{chann,hydro} - abs_min(hydro);
        delay{chann,hydro} = delay{chann,hydro} - min(delay{chann,hydro});
    end
end
%%


%%
% 7. plotting for each step
if (doYouWannaPlot == 's')
    
    canal = 1;
    
    % step 1
    figure
    stem(delayAfterRemovingNaN{canal,1},abs(gainAfterRemovingNaN{canal,1}),'b')
    title('After Removing NaN');
    %step 2;
    figure
    stem(delayAfterAddingUp{canal,1},abs(gainAfterAddingUp{canal,1}),'b')
    title('After Adding Gains Up');
    
    
    %comparing before and after adding things up
    figure
    stem(delayAfterRemovingNaN{canal,1},abs(gainAfterRemovingNaN{canal,1}),'b')
    hold on
    stem(delayAfterAddingUp{canal,1},abs(gainAfterAddingUp{canal,1}),'r')
    title('Blue is before adding up. Red is after');
    
    
    %step 3;
    figure
    stem(delayAfterDeletingSmallGains{canal,1},abs(gainAfterDeletingSmallGains{canal,1}),'b')
    title('After Removing Small Gains');
    %step 4;
    figure
    stem(delayAfterNormalizingGains{canal,1},abs(gainAfterNormalizingGains{canal,1}),'b')
    title('After Normalizing Gains');
end;

%%

save('./results/preProcessingResults.mat','gain','delay');