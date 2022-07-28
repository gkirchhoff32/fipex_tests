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

% Convert from voltage to flux (assuming calibration curve extends to flux
% regime we operated in).
% Constants
gain = 8e3;  % [Ohm] Amplifier gain
M = 15.9994/1000;  % [g/mol] Molar mass
m = M / 6.022e23;  % convert to kg
T = 293.15;  % [K]
v = 6272e2;  % [cm/s]

vPeak = peaks;
iPeak = vPeak / gain * 1e9;  % [nA]
% numDensity = 0.00072685 * iPeak.^3.5259;  % [1/cm^3] From Stuttgart cal curve
% u = sqrt(8*kB*T/pi/m);
% flux = numDensity * (u/4 + v);
flux = currenttoflux(iPeak, m, T, v);
meanFlux = currenttoflux(mean(iPeak), m, T, v);

%%
figure(1)
plot(iPeak, '.', color='blue')
title('Peak Current')
xlabel('Shot')
ylabel('Peak Current [nA]')
yline(mean(iPeak), '-.r', sprintf('mean = %0.0f nA', mean(iPeak)))
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
histogram(iPeak, 45)
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
    % current [vector]: Current [nA]
    % M: Molar mass [g/mol]
    % T: Temperature [K]
    % v: Beam velocity [cm/s]
    % Returns:
    % flux: Estimated flux from cal curve [1/s/cm^2]

    kB = 1.38e-23;  % [m^2*kg/s^2/K]
    
    numDensity = 0.00072685 * current.^3.5259;  % [1/cm^3] From Stuttgart cal curve
    u = sqrt(8*kB*T/pi/m);
    flux = numDensity * (u/4 + v);
end


