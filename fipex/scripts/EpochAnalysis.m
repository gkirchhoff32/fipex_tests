close all; clear all; clearvar; clc; format longEng;

load('ExperimentData.mat')

% time=(TimeLabView-TimeLabView(1))/1000/60; %Converting time to minutes
time_sec = (TimeLabView-TimeLabView(1))/1000; % Convert time to seconds

%%%% Filtering out bad measurements (> 51000 nA and < 1000 nA)
for i=1:length(IS)          
    if 50500 <= IS(i) && IS(i) <= 51500 
        IS(i) = NaN;
    elseif IS(i) <= 1000
        IS(i) = NaN;
    end
end

% %%%%% Just looking at the current
% figure()
% plot(TimeLabView,IS)
% xlabel('Time [min]') 
% ylabel('Current [nA]')
% title('Sensor Current, Is')
% grid on

% t0 = 44.9992;
% t1 = 45.0074;
% tstart = t0;
% tend = 88.1402;

% idx_start = find(time<(tstart+0.0001) & time>(tstart-0.0001));
% idx_end = find(time<(tend+0.0001) & time>(t1-0.0001));

idx_start = 88448;
idx_end = 175400;

% t_2Hz = time(idx_start:idx_end) * 60;  % Choose segment of 2Hz pulses and convert to seconds
t_2Hz = time_sec(idx_start:idx_end);  % Choose segment of 2Hz pulses
IS_2Hz = IS(idx_start:idx_end);

pulse_rate = 2;  % [Hz}
pulse_period = 1/pulse_rate;  % [s]

% Use discrete time derivative to find indices of spikes
dIS = diff(IS_2Hz);
idx_pos = find(dIS > 2000);
% TODO: Problem is that if there are two 2000nA+ plus spikes, then this
% current method chooses the second data pt. I want to select the first.
idx_pos = idx_pos(diff(idx_pos)~=1);

% plot(t_2Hz, IS_2Hz)

long = (diff(idx_pos)>=20);  % Identify where pulse lengths are too long
hold on
for i = 1:length(idx_pos)-1
%     if idx_pos(i) ~= 1
%         if IS_2Hz(idx_pos(i)) > IS_2Hz(idx_pos(i)-1)
%             i = i-1;
%         end
%     end
    % If pulse length too long, just take next 14 data points
    if long(i) == 1
        IS_plot = IS_2Hz(idx_pos(i):idx_pos(i)+14);
        t_plot = t_2Hz(idx_pos(i):idx_pos(i)+14) - t_2Hz(idx_pos(i));
    % Otherwise include data up to next spike element
    else
        IS_plot = IS_2Hz(idx_pos(i):idx_pos(i+1));
        t_plot = t_2Hz(idx_pos(i):idx_pos(i+1)) - t_2Hz(idx_pos(i));
    end
    plot(t_plot, IS_plot, '-')
end
xlabel('Time after epoch zero [s]')
ylabel('Current [nA]')
title('FIPEX SEA (stacked cycles)')



% t_start = t_2Hz(1);
% t_end = t_start + 0.5;  % Find half a sec after

% temp = t_2Hz - t_end;
% t1 = t_2Hz(temp<=0);

% % Create bins
% nbins = 60;
% bin_edges = linspace(0,0.5,nbins+1) + t1(1);
% 
% % Return relevant indices for this 1/2 second interval
% idx1 = zeros(length(t1), 1);
% for i = 1:length(t1)
%     idx1(i) = find(t_2Hz==t1(i));
% end
% IS1 = IS_2Hz(idx1);
% 
% hist = zeros(1, nbins);
% Y = discretize(t1, bin_edges);
% for i = 1:length(t1)
%     hist(Y(i)) = hist(Y(i)) + IS1(i);
% end
% 
% edges = linspace(0,0.5,nbins+1);
% bin_centers = (edges(1:end-1)+edges(2:end))/2;
% plot(bin_centers, hist);
% xlabel('time bin');
% ylabel('sum of currents');
% title('first binned cycle');
% 
