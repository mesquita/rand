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
% This script takes the results from the preProcessingData.m
% and uses it for identifying clusters presented on the
% channel realizations.
% It does that by putting together delays from a realization that
% are less separeted from each other than a constant T. We call
% it a cluster.


load('./results/preProcessingResults.mat');

dim = size(gain);
%%
% Initialization

all_clusters_cell = cell(dim);

T = 15e-5;                            % T is an arbitrary value that we chose from observation
%%
%%
for hydro = 1:dim(2)
    
    for chann = 1:dim(1)
        
        tap_gain = gain{chann,hydro};
        tau      = delay{chann,hydro};
        
        dTau = tau - [0 tau(1:end-1)]; % deltaTau is a vector with the time between two rays
        
        % dTauDash is a vector that contains 0s and 1s. A 0 show us when a value is greater
        % then T, so we have the end of one cluster and the beginning of another one
        
        dTauDash = (dTau < T);
        
        zeros_positions = find(dTauDash == 0);
        L_zp = length(zeros_positions);
        
        cluster = cell(L_zp,1);
        
        
        if (zeros_positions(1) == 1)
            for counter = 1:L_zp
                
                if (counter == length(zeros_positions))
                    cluster{counter,1} = tap_gain(zeros_positions(counter):end);
                    cluster{counter,2} = tau(zeros_positions(counter):end);
                else
                    cluster{counter,1} = tap_gain(zeros_positions(counter):zeros_positions(counter + 1) - 1);
                    cluster{counter,2} = tau(zeros_positions(counter):zeros_positions(counter + 1) - 1);
                end %it ends the if
                
            end %it ends the counter
            
        else
            for counter = 1:L_zp
                
                if (counter == 1)
                    cluster{counter,1} = tap_gain(1:zeros_positions(counter) - 1);
                    cluster{counter,2} = tau(1:zeros_positions(counter) - 1);
                elseif (counter == length(zeros_positions))
                    cluster{counter,1} = tap_gain(zeros_positions(counter):end);
                    cluster{counter,2} = tau(zeros_positions(counter):end);
                else
                    cluster{counter,1} = tap_gain(zeros_positions(counter - 1):zeros_positions(counter) - 1);
                    cluster{counter,2} = tau(zeros_positions(counter - 1):zeros_positions(counter) - 1);
                end %it ends the if
                
            end %it ends the counter
        end
        
        
        all_clusters_cell{chann,hydro} = cluster;
        
        cluster = [];                              % Reseting the variable cluster
        
    end %it ends the chann
    
end %it ends the hydro
%%
%%
% Saving data
save('./results/clustersIdentified.mat','all_clusters_cell');