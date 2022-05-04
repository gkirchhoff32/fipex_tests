close all; clear all; clearvar; clc; format longEng;

% load('ExperimentData.mat')
load('ExperimentData20220503.mat')
load('startendindices.mat')

time_sec = (TimeLabView-TimeLabView(1))/1000; % Convert time to seconds

% Filtering out bad measurements (> 51000 nA and < 1000 nA)
for i=1:length(IS)          
    if 50500 <= IS(i) && IS(i) <= 51500 
        IS(i) = NaN;
    elseif IS(i) <= 1000
        IS(i) = NaN;
    end
end

% Choose segment of 2Hz pulses
t_2Hz = time_sec(start_2Hz:end_2Hz);  
IS_2Hz = IS(start_2Hz:end_2Hz);

% Choose segment of 1Hz pulses
t_1Hz = time_sec(start_1Hz:end_1Hz);  
IS_1Hz = IS(start_1Hz:end_1Hz);

pulserate_1Hz = 1;  % [Hz]
pulserate_2Hz = 2;  % [Hz]
spikethresh = 2e3;  % Magnitude that defines a spike [nA]
samplimit_1Hz = 40;  % Limit on length of cycle (to catch lengthy anomalies)
samplimit_2Hz = 20;

[tplot_2Hz, ISplot_2Hz] = stackcycles(t_2Hz, IS_2Hz, pulserate_2Hz, spikethresh, samplimit_2Hz);
xlabel('Time after epoch zero [s]')
ylabel('Current [nA]')
title('FIPEX SEA (stacked cycles) at 2Hz')

hold OFF

[tplot_1Hz, ISplot_1Hz] = stackcycles(t_1Hz, IS_1Hz, pulserate_1Hz, spikethresh, samplimit_1Hz);
xlabel('Time after epoch zero [s]')
ylabel('Current [nA]')
title('FIPEX SEA (stacked cycles) at 1Hz')


