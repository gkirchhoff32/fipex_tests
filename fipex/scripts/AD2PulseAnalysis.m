close all; clear all; clearvar; clc; format longEng;
% 
%%
% P = append(pwd, '\..\data\2022_07_26_TIA_Repeat_Test\20220726_M0004_No_Cap_25ms_328kHz\');
P = 'C:\Users\Grant\OneDrive - UCB-O365\Grad Projects\FIPEX Tests\fipex\data\2022_08_24_60deg_Incident\dataset1\';
S = dir(fullfile(P,'*.txt')); 
for j = 1:numel(S)
    S(j).data = readmatrix(append(P, S(j).name));
end


%%
close all
exclude_bnd = 5000;  % This index corresponds w/ the time preceding the ringing.


gain = 8e3;  % [Ohms] 
bias = mean(S(1).data(1:100, 2));  % Initial non-zero voltage preceding pulse
t = S(1).data(1:exclude_bnd, 1);
difft = diff(t);
dt = difft(1);
vThresh = 0.17;  % [V] Threshold voltage where lower voltages are zeroed
tThresh = 0.4e-3;  % [s] Threshold time where subsequent lower voltages are zeroed

I_s = zeros(numel(S), length(S(1).data(1:exclude_bnd, 2)));
riemann_sum = zeros(1, numel(S));
figure()
hold on
for j = 1:numel(S)
    voltage = S(j).data(1:exclude_bnd,2);
    voltage = voltage - bias;  % Remove bias
    voltage(voltage<vThresh & t>tThresh) = 0;  % Zero any value below threshold to mitigate effect of ringing on integral
    current = voltage / gain;
    riemann_sum(1, j) = sum(current) * dt;
    plot(t*1e3, current*1e9, '.')
%     plot(current*1e9, '.')

end
ylabel('Current [nA]')
xlabel('Time [ms]')
title('Superposed Pulses')

peakCurrent = zeros(numel(S), 1);
for j = 1:numel(S)
    peakCurrent(j) = max(S(j).data(1:exclude_bnd,2)) / gain;
end

hold off
figure()
plot(peakCurrent*1e9, riemann_sum*1e9, 'bo')
xlabel('Maximum Current [nA]')
ylabel('Time-integrated Current [nA*s]')
title('Time-integrated Current vs. Max Current')


%%

[coeffs, gof] = fit(peakCurrent, riemann_sum', 'poly1');

peakFine = linspace(min(peakCurrent), max(peakCurrent), 1000);
A = coeffs.p1;
B = coeffs.p2;
forward = A*peakFine + B;


figure(3)
fitPlot = plot(peakFine*1e9, forward*1e9, 'r--'); fitLabel = sprintf('A=%0.2e s\nB=%0.2f nA*s', A, B*1e9);
hold on
plot(peakCurrent*1e9, riemann_sum*1e9, 'bo')
xlabel('Maximum Current [nA]')
ylabel('Time-integrated Current [nA*s]')
title('Time-integrated Current vs Max Current')
legend([fitPlot], [fitLabel])


%%

% Convert from voltage to flux (assuming calibration curve extends to flux
% regime we operated in).
% Constants
gain = 8e3;  % [Ohm] Amplifier gain
M = 15.9994/1000;  % [g/mol] Molar mass
m = M / 6.022e23;  % convert to kg
T = 293.15;  % [K]
v = 6272e2;  % [cm/s]

iPeak = peakCurrent;  % [nA]
flux = currenttoflux(iPeak, m, T, v);
meanFlux = currenttoflux(mean(iPeak), m, T, v);

%%
figure(1)
plot(iPeak, '.', color='blue')
title('Peak Current')
xlabel('Shot')
ylabel('Peak Current [nA]')
yline(mean(iPeak), '-.r', sprintf('mean = %0.2f nA', mean(iPeak)))
hold off

figure(2)
for j = 1:numel(S)
    iVals = S(j).data(1:exclude_bnd,2) / gain * 1e9;
    plot(S(j).data(1:exclude_bnd,1)*1e3, iVals);
    hold on
end
title('Stacked Signal Output')
xlabel('Time [ms]')
ylabel('Current [nA]')

figure(3)
histogram(iPeak, 20)
title('Peak Current')
xlabel('Peak Current [nA]')

figure(4)
loglog(iPeak, flux, 'or')
title('Estimated Flux vs Measured Peak Currents')
subtitle('(Assuming Calibration Curve Extends)')
xlabel('Current [nA]')
ylabel('Estimated Flux [1/s/cm^2]')




%%
function flux = currenttoflux(current, m, T, v)
    % Inputs:
    % current [vector]: Current [A]
    % M: Molar mass [g/mol]
    % T: Temperature [K]
    % v: Beam velocity [cm/s]
    % Returns:
    % flux: Estimated flux from cal curve [1/s/cm^2]

    kB = 1.38e-23;  % [m^2*kg/s^2/K]
    current = current * 1e9;  % Convert to nA
    
    numDensity = 0.00072685 * current.^3.5259;  % [1/cm^3] From Stuttgart cal curve
    u = sqrt(8*kB*T/pi/m);
    flux = numDensity * (u/4 + v);
end


