# Team Parzeval: Ball and Pipe Control System


Antonio DeAngelis, Parker Hopkins, Shahadat Talukder, Vincent Del Tufo, Whitten Oswald, Tyler Ziesse


## Project Overview:
The basic materials/setup for the project include:

- A ping pong ball 
- A cylindrical pipe standing vertically. The pipe should have a narrow enough diameter such that the ball can spin, but is otherwise restricted in the horizontal direction and can only move up and down within the pipe. It should be approximately 1 meter long with a cap on top so the ball cannot fly out the top. 
- A fan attached at the bottom of the pipe, pointing directly upwards
- A sensor attached at the top looking directly down into the pipe. This sensor should measure the distance between itself and the ping pong ball and send this data through a USB port to be displayed on a computer terminal. At a distance of 0, the ball is the furthest up it can be. Alternatively, at a distance of 100 (cm), the ball is the farthest away it can be.

---
The goals/objectives for this project are:
- Create a model of the ball and pipe system and determine the various forces acting on the ball.
- Derive and linearize a transfer function that relates the ball's position within the pipe (read from the distance sensor on top) to the the speed of the fan (controlled by Pulse Width Modulation (PWM)).
- Create a control system using this transfer function that takes a target height of the ping pong ball as input, and adjusts the fan speed to get the ball to hover at the specified height (achieve steady-state).
-  The control system should do this as quickly as possible (minimize settling time) and with as little vertical movement as possible (minimize steady-state error).
-  The control system should be able to be trained via Q-Learning to accomplish this task at any of the heights within the ball and pipe system.

Any type of control system can be chosen to achieve this. Our group has elected to use a controller method involving machine learning called Q-learning.

 

## Theory of Control Method: Q-Learning
Q-Learning is a branch of machine learning that emphasizes an unsupervised approach to the problem in the form of reinforcement learning. 


It is a model-free, off-policy, algorithm that utilizes a Q-table in tandem with the Q-function to obtain optimal Q-values for optimization of the goal (or system). 


Works with the idea of maximizing the reward obtained from the agent (system) interacting with the environment when trying to achieve the goal. The maximized value is stored as a Q-value in the Q-table.


This Q-table is then used as a reference for where the maximum expected future rewards are stored. These values are used to find the next action for the agent and, in this case, the subsequent system response feedback. 


The Q-table as well as the rest of the controller components for this project are implemented in MATLAB. 


## Guide to Use Code:
The first step to use this code is to ensure the USB port your computer uses is properly referenced in real_world.m.

### Connect to device
Once the USB from the ball-and-pipe system is hooked up to your computer, go to 'Device Manager' and under 'Ports', check the name of the port the computer uses to identify the USB. The default value is "COM3", but your computer might use a different name. You will have to change this if that is the case in line 12 of real_world.m where it calls the MATLAB serialport() function.

### Parameters
The system contains adjustable hyperparameters or variables that target and sample_rate allow the user to adjust the desired height of the ball. Since our pipe is 1m, but the height is represented in centimeters, the maximum value for target is 100 and the minimum is 0.

### Give an initial burst to lift ball and keep in air
What is done originally at the onset of starting the control system is to allow the user to check that their code is working before they enter their control loop. The set_pwm.m function adjusts the fan speed in the range 0-4095, with 0 being OFF and 4095 being the maximum speed of the fan. For more information on the specs of the PWM, reference the SCFBA Specification Sheet pdf file.

### Feedback Loop
The feedback occurs in a permanent loop once the system is running. The first step is to read the data from the distance sensor using the custom function read_data.m. The function ir2y.m then converts this value a distance (in m.) from the bottom of the pipe that can be easily compared to our target value. Our control system then determines the best course of action from the Q-table and set_pwm.m is called at the end to change the fan speed accordingly.

A brief pause occurs before the next iteration occurs and the process repeats.

---

To begin the process, real_world.m should be called in Command Window.
