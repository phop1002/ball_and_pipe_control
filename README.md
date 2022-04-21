# Ball and Pipe Control System, Team Parzeval


Antonio DeAngelis, Parker Hopkins, Shahadat Talukder, Vincent Del Tufo, Whitten Oswald, Tyler Ziesse


## Project Overview:
The basic materials/setup for the project include:

- A ping pong ball 
- A cylindrical pipe standing vertically. The pipe shoudl have a narrow enough diameter such that the ball can spin, but is otherwise restricted in the horizontal direction and can only move up and down within the pipe. It should be approximately 1 meter long with a cap on top so the ball cannot fly out the top. 
- A fan attached at the bottom of the pipe, pointing directly upwards
- A sensor attached at the top looking directly down into the pipe. This sensor should measure the distance between itself and the ping pong ball and send this data through a USB port to be displayed on a computer terminal. 

---
The goals/objectives for this project are:
- Create a model of the ball and pipe system and determine the various forces acting on the ball.
- Derive and linearize a transfer function that relates the ball's position within the pipe (read from the distance sensor on top) to the the speed of the fan (controlled by Pulse Width Modulation (PWM)).
- Create a control system using this transfer function that takes a target height of the ping pong ball as input, and adjusts the fan speed to get the ball to hover at the specified height (achieve steady-state).
-  The control system should do this as quickly as possible (minimize settling time) and with as little vertical movement as possible (minimize steady-state error).

Any type of control system can be chosen to achieve this. Our group has elected to use a controller method called Q-learning.

 

## Theory of Control Method: Q-Learning
Q-Learning is a branch of machine learning that emphasizes an unsupervised approach to the problem in the form of reinforcement learning. 


It is a model-free, off-policy, algorithm that utilizes a Q-table in tandem with the Q-function to obtain optimal Q-values for optimization of the goal (or system). 


Works with the idea of maximizing the reward obtained from the agent (system) interacting with the environment when trying to achieve the goal. The maximized value is stored as a Q-value in the Q-table.


This Q-table is then used as a reference for where the maximum expected future rewards are stored. These values are used to find the next action for the agent and, in this case, the subsequent system response feedback. 



## Guide to Use Code:





