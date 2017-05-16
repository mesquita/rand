% /* Copyright (C) Vinicius M. de Pinho - All Rights Reserved
% * Unauthorized copying of this file, via any medium is strictly prohibited
% * Proprietary and confidential
% * Written by: Vinicius M. de Pinho <viniciusmesquita@poli.ufrj.br>
% *  
% * May 2017
% *
% * Electronic and Computing Engineering Department (DEL)
% * Polytechnic School (Poli)
% * Federal University of Rio de Janeiro (UFRJ)
% */
clear;
close all;

% text to binary
initial_text= 'ok';
it_binary_char_type = dec2bin(initial_text)';
it_binary_vector = it_binary_char_type(:)'-'0';

%alphabet size
M = 4; 

%binary to 4-pam
pam_message = pammod(it_binary_vector,M);


%4-pam to binary
rt_binary_vector = pamdemod(pam_message,M);

%binary to text
rt_binary_string = num2str(rt_binary_vector,'%d');
rt_binary_char = reshape(rt_binary_string,7,[]);
rt_ascii_vector = bin2dec(rt_binary_char');
received_text = char(rt_ascii_vector)'


