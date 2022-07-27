close all; clear all; clearvar; clc; format longEng;

P = append(pwd, '\..\data\2022_07_26_TIA_Repeat_Test\20220726_M0004_No_Cap_25ms_328kHz\');
S = dir(fullfile(P,'*.csv')); 
for j = 1:numel(S)
    S(j).data = readmatrix(append(P, S(j).name));
end

%%
exclude_bnd = 2276;  % This index corresponds w/ 5ms, which follows the peak but precedes the ringing peak.

peaks = zeros(numel(S), 1);
for j = 1:numel(S)
    peaks(j) = max(S(j).data(1:exclude_bnd,2));
end

%%
figure(1)
plot(peaks)
title('Peak value per shot')
xlabel('Shot')
ylabel('Voltage [V]')
yline(mean(peaks))
hold off

figure(2)
for j = 1:numel(S)
    plot(S(j).data(1:exclude_bnd,1)*1e3, S(j).data(1:exclude_bnd,2));
    hold on
end
title('Stacked Signal Outputs')
xlabel('Time [ms]')
ylabel('Voltage [V]')

figure(3)
histogram(peaks, 30)
title('Peak value per shot')
xlabel('Peak value [V]')

