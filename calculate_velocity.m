% A MATLAB script used to caluclate velocity
function velocity = calculate_velocity(last_y,current_y,sampling_time)
%% Calculates the velocity of the ball
% Inputs:
%  ~ last_y: Previously read y value of the ball
%  ~ current_y: Currently read y value of the ball
% Outputs:
%  ~ velocity: Current velocity of the ball
%
% Created by Parker Hopkins on  April 28, 2022

%% Calculate and return velocity
velocity = (current_y - last_y) / sampling_time;

end