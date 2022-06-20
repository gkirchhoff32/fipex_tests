close all; clear all; clearvar; clc;

baseDir = pwd;  % Current working directory

addpath('../data/2022_06_14_TIA_Tests')
T=readtable('20220620_TIA_Test.dat');
US = T{:,2};
URef = T{:,3};
IS = T{:,4};
UH = T{:,5};
IH = T{:,6};
RH = T{:,7};
TimeLabView = T{:,8};

save('ExperimentData/AD2TestTIAData.mat','US','URef','IS','UH','IH','RH','TimeLabView');

% addpath('../data/2022_06_14_TIA_Tests')
% T=readtable('20220620_AD2_Data.csv');
% AD2Time = T{:,1};
% AD2Voltage = T{:,2};
% 
% save('ExperimentData/AD2ScopeTIAData.mat','AD2Time','AD2Voltage');






