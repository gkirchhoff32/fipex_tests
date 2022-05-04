% Function to stack periods for superposed epoch analysis in FIPEX
% experiments.

function [t_plot, IS_plot] = stack_cycles(t, IS, pulse_rate, spike_thresh, samp_lim)
    figure()
    hold ON
    pulse_period = 1/pulse_rate;  % [s]

    % Use discrete time derivative to find indices of spikes
    dIS = diff(IS);
    idx_pos = find(dIS > spike_thresh);
    idx_pos = idx_pos(diff(idx_pos)~=1);

    % Stack cycles
    long = (diff(idx_pos)>=samp_lim);  % Identify where pulse lengths are too long
    for i = 1:length(idx_pos)-1
        % If pulse length too long, just take next data up to limit minus 6
        if long(i) == 1
            IS_plot = IS(idx_pos(i):idx_pos(i)+(samp_lim-6));
            t_plot = t(idx_pos(i):idx_pos(i)+(samp_lim-6)) - t(idx_pos(i));
        % Otherwise include data up to next spike element
        else
            IS_plot = IS(idx_pos(i):idx_pos(i+1));
            t_plot = t(idx_pos(i):idx_pos(i+1)) - t(idx_pos(i));
        end
        % Throw away elements that occur after length of pulse cycle
        valid = t_plot<=pulse_period;
        t_plot = t_plot(valid);
        IS_plot = IS_plot(valid);

        plot(t_plot, IS_plot, '.')
    end
end