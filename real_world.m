% A MATLAB script to control Rowans Systems & Control Floating Ball 
% Apparatus designed by Mario Leone, Karl Dyer and Michelle Frolio. 
% The current control system is a PID controller.
%
% Created by Kyle Naddeo, Mon Jan 3 11:19:49 EST 
% Modified by Whitten Oswald on February 11, 2022
% Modified by Parker Hopkins on April 29, 2022

%% Start fresh
close all; clc; clear device;

%% Connect to device
device = serialport("COM5",19200);

%% Load variables and Q table
%load variables
load("variables.mat");

% load q table for desired height
load('simulated_q_tables\q_table_50cm.mat', 'q_table');

% max pwm of ball and pipe system
%max_pwm = 4095;

% min pwm of ball and pipe system
%min_pwm = 0;

% time that simulation will run for in seconds
%episode_length = 72;

%% Bring ball to bottom for start
% set fan speed to 0 for 2 seconds
action = 0;
set_pwm(device,action+2727.0477);
pause(2);

%% Initialize variables
% set y_goal
y_goal = 0.5;

% initialize reward to 0;
reward = 0;

% initialize total reward values for plotting
episode_reward_values = [];

% intialize reward_values
reward_values = [];

%initialize q_table
lowest_starting_q_value = -10;
 
% q_table = lowest_starting_q_value * zeros(length(height_space), ...
%         length(velocity_space), length(pwm_space));

%% Q learning / control
for episode = 1:1:episodes

    % initialize first discrete state as 0 height and 0 velocity
    discrete_state = get_discrete_state([0, 0], observation_low, observation_window_size);

    % initilize y_previous to 0
    y_previous = 0;

    % initialize y_current to 0
    y_current = 0;
    
    % initialize vel_previous to 0
    velocity_previous = 0;
    
    % initialize vel_current to 0
    velocity_current = 0;

    % initiazile episode's total reward
    episode_reward = 0;
    
    % initialze y difference previous to 0
    y_difference_current_previous = 0;
    
    % loop through each time step
    for step = 1:1:steps
        
        % set exploration value for chance to explore
        explore = rand;
    
        % determine if agent will explore
        if explore < 0.0000000011
            % explore
            action = randi([3,length(pwm_space)]);
            q_current = q_table(discrete_state(1),discrete_state(2),action);
        else
            % choose action with highest reward
            [q_current, action] = max(q_table(discrete_state(1), discrete_state(2), :));
        end

        % take action
        set_pwm(device,pwm_space(action)+2727.0477);
        
        % wait for fan to react to action
        pause(action_time);
        
        % wait for sample
        pause(sampling_rate);
        
        % get new simulation step
        y_current = read_data(device);
        y_current = ir2y(y_current);
        
        % calculate velocity
        velocity_current = calculate_velocity(y_previous,y_current,sampling_rate);

        % calculate new discrete step
        discrete_state_new = get_discrete_state([y_current,velocity_current],observation_low,observation_window_size);

        % update previous y value
        y_previous = y_current;

        % update previous velocity value
        velocity_previous = velocity_current;
        
        % calculate difference
        y_difference_current = y_current - y_goal;

        % simulation reward function
        reward = -y_difference_current^2;

        % update previous y difference
        y_difference_current_previous = y_current;
        
        % add single step reward to total reward 
        episode_reward = episode_reward + reward;

        % calculate max future q value
        [q_max_future, ~] = max(q_table(discrete_state_new(1),discrete_state_new(2),:));

        % update q value using the bellman equation
        q_new = (1-learning_rate)*q_current+learning_rate*(reward+discount_factor*q_max_future);

        q_table(discrete_state(1),discrete_state(2),action) = q_new;

        % update discrete_state
        discrete_state = discrete_state_new;

        % update epsilon
        if epsilon_decay_end >= episode && episode >= epsilon_decay_start
            epsilon =  epsilon-epsilon_decay_value;
        end
        
    end
    
    % bring ball back to bottom
    set_pwm(device, epsilon_decay_start);
    
    % update y_values and reward_values for plotting
    episode_reward_values(end + 1) = episode_reward;
    
    % plot total episode rewards
    figure(2)
    plot(1:1:length(episode_reward_values), episode_reward_values);
    xlabel('episodes');
    ylabel('reward');
    title('Reward vs. Episodes')
    
    % save total episode rewards over time
    save('episode_reward_values', 'episode_reward_values')
    
    % logging
    disp(['episode: ', num2str(episode)])
    disp(['episode_episode_reward: ', num2str(episode_reward)]);
    fprintf(1, '\n');
    
    % save updated q table
    y_goal_cm = y_goal * 100;
    save(['real_q_tables\real_q_table_' num2str(y_goal_cm) 'cm.mat'], 'q_table');
    
    pause(2);
 end