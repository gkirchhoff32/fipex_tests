close all; clear all; clearvar; clc; format longEng;

load('ExperimentData.mat')

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
idx_start_2Hz = 88448;
idx_end_2Hz = 175400;
t_2Hz = time_sec(idx_start_2Hz:idx_end_2Hz);  
IS_2Hz = IS(idx_start_2Hz:idx_end_2Hz);

% Choose segment of 1Hz pulses
idx_start_1Hz = 197000;
idx_end_1Hz = 230000;
t_1Hz = time_sec(idx_start_1Hz:idx_end_1Hz);  
IS_1Hz = IS(idx_start_1Hz:idx_end_1Hz);

% plot(t_1Hz, IS_1Hz)

pulse_rate_1Hz = 1;  % [Hz]
pulse_rate_2Hz = 2;  % [Hz]
spike_thresh = 2e3;  % Magnitude that defines a spike [nA]
samp_lim_1Hz = 40;  % Limit on length of cycle (to catch lengthy anomalies)
samp_lim_2Hz = 20;

[t_plot_2Hz, I_plot_2Hz] = stack_cycles(t_2Hz, IS_2Hz, pulse_rate_2Hz, spike_thresh, samp_lim_2Hz);
xlabel('Time after epoch zero [s]')
ylabel('Current [nA]')
title('FIPEX SEA (stacked cycles) at 2Hz')

hold OFF

[t_plot_1Hz, I_plot_1Hz] = stack_cycles(t_1Hz, IS_1Hz, pulse_rate_1Hz, spike_thresh, samp_lim_1Hz);
xlabel('Time after epoch zero [s]')
ylabel('Current [nA]')
title('FIPEX SEA (stacked cycles) at 1Hz')


