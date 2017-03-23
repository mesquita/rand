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
% Date: 01/28/2016
% 

%function processingClusters()

run('preProcesssingData.m')
run('identifyingClusters.m')
load('./results/clustersIdentified.mat');

dim = size(all_clusters_cell);

%%
% Initialization

tap_gain_chann = cell(dim);
tau_chann      = cell(dim);


for hydro = 1:dim(2)
    
    for chann = 1:dim(1)
        
        dimInner = (size(all_clusters_cell{chann,hydro}));
        
        tap_gain = zeros(dimInner(1),1);
        tau      = zeros(dimInner(1),1);
        
        for rowInner = 1:dimInner(1)
            
            [tap_gain(rowInner),indexMax] = max((all_clusters_cell{chann,hydro}{rowInner,1}));
            tau(rowInner)                 = all_clusters_cell{chann,hydro}{rowInner,2}(indexMax);
            
        end       
        
        tap_gain = tap_gain/norm(tap_gain);    % Normalizing the gains
        
        tap_gain_chann{chann,hydro} = tap_gain;
        tau_chann{chann,hydro}      = tau;
        
    end
end


%%
%%interpolar 

dim = size(tau_chann);
Ts = 10^-5;

max_position_matrix = zeros(dim(1),dim(2));
for hydro = 1:dim(2)
    for perfil = 1:dim(1)
        
        channel_delay = tau_chann{perfil,hydro};
        
        position_vector = ceil(channel_delay/Ts) + 1;
        
        max_position_matrix(perfil,hydro) = max(position_vector);
    end
end
max_position_vector = max(max_position_matrix,[],1);
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
H_aux = zeros(8,dim(1));

for i = 1:dim(2)
    channel_gain = tap_gain_chann{1,i};
    channel_delay = tau_chann{1,i};
    
    position_vector = ceil(channel_delay/Ts) + 1;
    H_aux((position_vector.'),i) = channel_gain.';
    
end

%%
%resample
p = 12;
q = 25;
y = resample(H_aux(:,5),p,q);
figure;
stem(tau_chann{1,2},abs(tap_gain_chann{1,2}/norm(tap_gain_chann{1,1})))
figure;
stem(abs(y)/norm(y));

h_3km = H_aux;
save('h_3km.mat','h_3km');

