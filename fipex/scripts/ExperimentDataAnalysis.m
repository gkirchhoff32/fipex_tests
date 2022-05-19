close all; clear all; clearvar; clc;

% load('ExperimentData.mat')
load('ExperimentData20220503.mat')

ComputeFFT = 1;

TimeLabView=(TimeLabView-TimeLabView(1))/1000/60; % Converting time to minutes
time=TimeLabView; 

if ComputeFFT
    %%%%% fft of the 2 Hz & 1 Hz segments
    start_2Hz = 82500;
    end_2Hz = 167000;
    start_1Hz = 197000;
    end_1Hz = 230000;
    IS_2Hz = IS(start_2Hz:end_2Hz);
    IS_1Hz = IS(start_1Hz:end_1Hz);  
    Fs=length(time)/(time(end)*60);     % Sampling frequency 

    [f_2Hz, P1_2Hz] = computespectrum(IS_2Hz, Fs);
    [f_1Hz, P1_1Hz] = computespectrum(IS_1Hz, Fs);

    figure()
    plot(f_2Hz,P1_2Hz) 
    title('Single-Sided Amplitude Spectrum of Sensor Current (2Hz Pulse)')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    grid on
                
    figure()
    plot(f_1Hz,P1_1Hz) 
    title('Single-Sided Amplitude Spectrum of Sensor Current (1Hz Pulse)')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    grid on
        
end

%%%% Filtering out the huge signals
for i=1:length(IS)          
    if 50500 <= IS(i) && IS(i) <= 51500 
        IS(i)=NaN;
    end
end


%%%% Displaying the full data
figure()
for i=1
subplot(4,2,1)
plot(time,US)
hold on
plot(time,ones(length(RH),1).*100,'r')
hold on
plot(time,ones(length(RH),1).*1500,'r')
ylabel('Voltage [mV]')
xlabel('Time [s]')
title('Sensor Voltage, Us')
legend('Data','Limits')
grid on

subplot(4,2,3)
plot(time,Uref)
hold on
plot(time,ones(length(RH),1).*100,'r')
hold on
plot(time,ones(length(RH),1).*585,'r')
xlabel('Time [s]')
ylabel('Voltage [mV]')
title('Reference Voltage, Uref')
legend('Data','Limits')
grid on

subplot(4,2,5)
plot(time,IS)
xlabel('Time [s]')
ylabel('Current [nA]')
title('Sensor Current, Is')
grid on

subplot(4,2,7)
plot(time,range_is_change)
title('Sensor Current Change')
xlabel('Time [s]')
grid on

subplot(4,2,2)
plot(time,UH)
xlabel('Time [s]')
ylabel('Voltage [mV]')
title('Heater Voltage, UH')
grid on


subplot(4,2,4)
plot(time,IH)
xlabel('Time [s]')
ylabel('Current [mA]')
title('Heater Current, IH')
grid on

subplot(4,2,6)
plot(time,RH)
hold on
plot(time,ones(length(RH),1).*27,'r')
hold on
plot(time,ones(length(RH),1).*32,'r')
xlabel('Time [s]')
ylabel('Resistance [Ohm]')
title('Heater Resistance, RH')
grid on
legend('Data','Limits')

subplot(4,2,8)
plot(time,heatup)
title('Heatup')
xlabel('Time [s]')
grid on

end


%%%%% Just looking at the current
figure()
plot(time,IS, 'b')
xlabel('Time [min]')
ylabel('Current [nA]')
title('Sensor Current, Is')
grid on


% Save start and end indices for 1Hz and 2Hz for "EpochAnalysis.m" script
save('startendindices.mat', 'start_2Hz', 'end_2Hz', 'start_1Hz', 'end_1Hz')














