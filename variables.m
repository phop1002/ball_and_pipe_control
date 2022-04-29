%% Clear workspace and command window
clear, clc;

%% Assign variables needed for training
mass = 2.7*10^-3;
volume = 3.35*10^-5;
density = 1.225;
g = 9.8;
velocity_eq = 2.4384;
sampling_rate = 0.25;
distance_max = 0.9144;
distance_min = 0;
velocity_max = 1;
velocity_min = -1;
pwm_max = 4095-2727.0477;
pwm_min = 0-2727.0477;
episode_length = 18;
steps = cast(cast(episode_length/sampling_rate,'int16'),'double');
distance_bucket_size = 18;
velocity_bucket_size = 10;
pwm_bucket_size = 5;
distance_space = distance_min:((distance_max-distance_min)/distance_bucket_size):distance_max;
velocity_space = velocity_min:((velocity_max-velocity_min)/velocity_bucket_size):velocity_max;
pwm_space = pwm_min:((pwm_max-pwm_min)/pwm_bucket_size):pwm_max;
observation_space = zeros(length(distance_space),length(velocity_space));
observation_high = horzcat(distance_max,velocity_max);
observation_low = horzcat(distance_min,velocity_min);
observation_window_size = (observation_high-observation_low)./horzcat(length(distance_space),length(velocity_space));
episodes = 8000;
learning_rate = 0.01;
discount_factor = 0.9;
epsilon = 0.5;
epsilon_decay_start = 1;
epsilon_decay_end = cast((episodes/2),'int16');
epsilon_decay_value = 0.04*epsilon/cast(epsilon_decay_end-epsilon_decay_start,'double');
action_time = 0.06;
observation_space_num_variables = length(size(observation_space));
observation_space_num_variables = observation_space_num_variables(1);

%% Store variables in a file
save("variables.mat");
