% A MATLAB script to calculate the discrete state for use by a q table
function [discrete_state] = get_discrete_state(state, os_low, os_win_size)
    % calculate discrete state
    discrete_state = cast((state - os_low) ./ os_win_size, 'int16');
    discrete_state = discrete_state + 1;
    
    % ensure discrete state does not become larger than max
    discrete_state(discrete_state > 7) = 7;
    discrete_state(discrete_state < 1) = 1;
end