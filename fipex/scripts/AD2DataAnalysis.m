close all; clear all; clearvar; clc; format longEng;

P = append(pwd, '\..\data\2022_07_26_TIA_Repeat_Test\20220726_M0004_No_Cap_25ms_328kHz\');
S = dir(fullfile(P,'*.csv')); 
for j = 1:numel(S)
    S(j).data = readmatrix(append(P, S(j).name));
end

%%

