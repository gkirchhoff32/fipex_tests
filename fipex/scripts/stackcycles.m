% Function to stack periods for superposed epoch analysis in FIPEX
% experiments.

function [t_plot, IS_plot] = stackcycles(t, IS, pulse_rate, spike_thresh, samp_lim)
    figure()
    hold ON
    pulse_period = 1/pulse_rate;  % [s]

    % Use discrete time derivative to find indices of spikes
    dIS = diff(IS);
    idx_pos = find(dIS > spike_thresh);
    idx_pos = idx_pos(diff(idx_pos)~=1);

    % Stack cycles
    long = (diff(idx_pos)>=samp_lim);  % Identify where pulse lengths are too long
    
    % Instantiate t and IS matrices
    t_plot = NaN(length(idx_pos)-1, samp_lim);
    IS_plot = NaN(length(idx_pos)-1, samp_lim);
    for i = 1:length(idx_pos)-1
        IS_seg = IS(idx_pos(i):idx_pos(i+1));
        t_seg = t(idx_pos(i):idx_pos(i+1)) - t(idx_pos(i));
        
        % Throw away elements that occur after length of pulse cycle
        valid = t_seg<=pulse_period;
        t_seg = t_seg(valid);
        IS_seg = IS_seg(valid);
        
        t_plot(i, 1:length(t_seg)) = t_seg;
        IS_plot(i, 1:length(IS_seg)) = IS_seg;
    end
end