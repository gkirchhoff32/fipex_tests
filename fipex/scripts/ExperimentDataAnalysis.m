close all; clear all; clearvar; clc;

load('ExperimentData.mat')

TimeLabView=(TimeLabView-TimeLabView(1))/1000/60; %Converting time to minutes
time=TimeLabView;

%%%%% fft of the 2 Hz portion
start = 82500;
finish = 167000;
Fs=length(time)/(time(end)*60);     % Sampling frequency 
T = 1/Fs;             % Sampling period       
L = finish - start + 1;             % Length of signal
t = (0:L-1)*T;        % Time vector

Y = fft(detrend(IS(start:finish)));

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;
figure()
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of Sensor Current (2Hz Pulse)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
grid on


%%%%% fft of the 1 Hz portion
start = 197000;
finish = 230000;
Fs = 32.7751;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = finish - start + 1;             % Length of signal
t = (0:L-1)*T;        % Time vector

Y = fft(detrend(IS(start:finish)));

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;
figure()
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of Sensor Current (1Hz Pulse)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
grid on



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
plot(time,IS, 'g')
xlabel('Time [min]')
ylabel('Current [nA]')
title('Sensor Current, Is')
grid on


















