# Ball and Pipe Control System, Team Parzeval


Antonio DeAngelis, Parker Hopkins, Shahadat Talukder, Vincent Del Tufo, Whitten Oswald, Tyler Ziesse


## Project Overview:
The basic materials/setup for the project include:

- A ping pong ball 
- A cylindrical pipe standing vertically. The pipe shoudl have a narrow enough diameter such that the ball can spin, but is otherwise restricted in the horizontal direction and can only move up and down within the pipe. It should be approximately 1 meter long with a cap on top so the ball cannot fly out the top. 
- A fan attached at the bottom of the pipe, pointing directly upwards. The fan at the bottom should be controlled by Pulse Width Modulation (PWM).
- A sensor attached at the top looking directly down into the pipe. This sensor should measure the distance between itself and the ping pong ball and send this data through a USB port to be displayed on a computer terminal. 

---


, which, in combination with the feedback from the distance sensor at the top, allows for a control system to be implemented. 
The goal of the control system is to get the ping pong ball to hover at a specified height within the tube (achieve a steady-state) as quickly as possible (minimize settling time) and with as little movement as possible (minimize steady state error).

Any type of control system can be used to achieve this, but our group has elected to use a method called Q-learning.

 


## Theory of Control Method: Q-Learning
Q-Learning is a type of unsupervised reinforcement learning that allows for the training of a system to better adapt to its environment to accomplish a certain goal, and to accomplish it with a higher degree of success. It takes the current state of a system (referred to as the agent) and attempts to maximize a reward value. This value is modified through positive reinforcement, with more reward points being given for better performance.


## Guide to Use Code:





MATLAB codes to open serial communication with a ball and pipe system. The system is made of a vertical cylinder with a ping pong ball controlled by a fan on the bottom and height measured by a time of flight sensor on top. The objective is to balance the ball at a target altitude. 
