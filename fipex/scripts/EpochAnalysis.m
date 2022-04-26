close all; clear all; clearvar; clc;

load('ExperimentData.mat')

time=(TimeLabView-TimeLabView(1))/1000/60; %Converting time to minutes
% time=TimeLabView;

% %%%%% Just looking at the current
% figure()
% plot(TimeLabView,IS)
% xlabel('Time [min]')
% ylabel('Current [nA]')
% title('Sensor Current, Is')
% grid on

t0 = 44.9992;
t1 = 45.0074;
tstart = t0;
tend = 88.1402;

% idx_start = find(time<(tstart+0.0001) & time>(tstart-0.0001));
% idx_end = find(time<(tend+0.0001) & time>(t1-0.0001));

idx_start = 88448;
idx_end = 175400;

t_2Hz = time(idx_start:idx_end);
IS_2Hz = IS(idx_start:idx_end);

findpeaks(IS_2Hz);




