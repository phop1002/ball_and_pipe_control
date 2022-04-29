% A MATLAB script to simulate Rowan's Systems & Control Floating Ball 
% Apparatus designed by Mario Leone, Karl Dyer and Michelle Frolio in
% order to train a Q-learning algorithm.
%
% Created by Parker Hopkins on April 28, 2022

%% Clear workspace and command window
clear, clc;

%% Load variables
load("variables.mat");

%% Transfer function
% G1: Wind speed to ball position
syms s;
c2 = ((2*g)/velocity_eq)*(mass-density*0.00026)/mass;
Ys = c2;
Vs = sym2poly(s*(s+c2));
G1 = tf(Ys,Vs);

% G2: PWM to wind speed
G2 = 6.3787 * 10^-4;

% G3: PWM to ball position
G3 = G2 * G1;

% State space representation
G = ss(G3);

%% Simulation with Q-learning
% plot each episode together
%hold on;

% initialize height goal
y_goal = 0.6;

% low reward value
reward_low = -1;

% initialize epsilon value
epsilon = 0.9;

% randomly initialize q table
q_table = reward_low * zeros(length(distance_space),length(velocity_space),length(pwm_space));

% array to store reward totals
reward_totals = zeros(1,episodes);

% loop through for each episode
for episode = 1:1:episodes 

    % initialize first discrete state as 0 distance and 0 velocity
    discrete_state = get_discrete_state([0,0],observation_low,observation_window_size);

    % initialize ss state
    previous_state = [0;0];

    % initialize y values to 0s
    y_values = zeros(steps,1);

    % initilize y_previous to 0
    y_previous = 0;

    % initialize y_current to 0
    y_current = [0;0];

    % randomly set chance to explore
    explore = rand;

    % episode's total reward
    reward_episode_total = 0;

    % loop through each time step in each episode
    for time = 1:1:length(y_values)

        % determine if agent will explore
        if explore < epsilon
            action = randi([1,length(pwm_space)]);
            q_current = q_table(discrete_state(1),discrete_state(2),action);
            color = '-r';
        else
            % choose action with highest reward
            [q_current,action] = max(q_table(discrete_state(1),discrete_state(2),:));
            color = '-g';
        end

        % get new simulation step
        [y_current,previous_time_samples,previous_states] = lsim(G,[pwm_space(action),pwm_space(action)],[0,sampling_rate],previous_state);

        % enforce max height
        if y_current(end-1) > distance_max
            y_current(end-1) = distance_max;
            y_values(time) = distance_max;
        end

        if y_current(end) > distance_max
            y_current(end) = distance_max;
            y_values(time+1) = distance_max;
        end

        % enforce min height
        if y_current(end-1) < distance_min
            y_current(end-1) = distance_min;
            y_values(time) = distance_min;
        end

        if y_current(end) < distance_min
            y_current(end) = distance_min;
            y_values(time+1) = distance_min;
        end

        % calculate velocity
        if y_current == 0 | y_current == distance_max %#ok<OR2>
            velocity_current = 0;
        else
            velocity_current = max(calculate_velocity(y_previous,y_current(end),sampling_rate));
        end

        % calculate new discrete step
        new_discrete_state = get_discrete_state([y_current(end),velocity_current],observation_low,observation_window_size);
            
        % update previous y value
        y_previous = y_current(end);
            
        % calculate difference
        y_difference = y_current(end)-y_goal;

        % calculate reward
        reward = -y_difference^2;

        % episode's total reward
        reward_episode_total = reward_episode_total+reward;

        % calculate max future q value
        [q_future_max, ~] = max(q_table(new_discrete_state(1),new_discrete_state(2),:));

        % update q value using the bellman equation
        q_new = (1-learning_rate)*q_current+learning_rate*(reward+discount_factor*q_future_max);

        q_table(discrete_state(1),discrete_state(2),action) = q_new;

        % update discrete_state
        discrete_state = new_discrete_state;

        % extract previous state from previous state vector
        previous_state = [previous_states(end - 2), previous_states(end)];

        % enforce max height on ss model
        % 12.6356 is max height on space state model

        if previous_state(end) > 12.6356
            previous_state(end) = 12.6356;
        end

        % enforce min height on ss model
        % 0 is min height on space state model
        if previous_state(end) < 0
            previous_state(end) = 0;
        end

        % add new simulation step to previous states
        y_values(time) = y_current(end - 1);
        y_values(time + 1) = y_current(end);

        if epsilon_decay_end >= episode && episode >= epsilon_decay_start
            epsilon =  epsilon-epsilon_decay_value;
        end
    end

    % visualize agent learning
    plot(0:sampling_rate:episode_length,y_values,color);
    ylim([0 1])
    xlabel('Time(s)')
    ylabel('Height(m)')
    title('Height vs. Time')
    drawnow
    
    % add single step reward to total reward 
    reward_totals(episode) = reward_episode_total;
        
end

figure(2)
% visualize agent learning
plot(1:episodes,reward_totals);
xlabel('Episode')
ylabel('Episode Reward Total')
title('Episode Reward Totals')
drawnow
    
y_goal_cm = y_goal*100;
y_goal_index = cast((y_goal_cm/10), 'int8');

% save q table
save(['simulated_q_tables\q_table_'  num2str(y_goal_cm)  'cm'], 'q_table');
