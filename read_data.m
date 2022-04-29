% A MATLAB script to read data from a ball and pipe system 
function [distance,pwm,target,deadpan] = read_data(device)
%% Reads data sent back from Ball and Pipe system
% Inputs:
%  ~ device: serialport object controlling the real world system
% Outputs:
%  ~ distance: the IR reading from the time of flight sensor
%  ~ pwm: the PWM from the manual knob of the system (NOT THE SAME AS THE
%  PWM YOU MAY SET THROUGH SERIAL COMMUNICATION)
%  ~ target: the desired height of the ball set by the manual knob of the
%  system
%  ~ deadpan: the time delay after an action set by the manual knob of the
%  system
%
% Created by:  Kyle Naddeo 1/3/2022
% Modified by: Jacob King 2/2/2022
% Modified by: Zachary Heras 2/9/2022

%% Ask nicely for data
% use the serialport() command options to write the correct letter to the
% system (Hint: the letters are in the spec sheet)
    device.writeline('h')
    device.writeline('s');

%% Read data
% use the serialport() command options to read the response
%     if device.NumBytesAvailable >= 20
            response = read(device, 20, 'string');
%            device.flush();
%     end

%% Translate
% translate the response to 4 doubles using str2double() and
% extractBetween() (Hint: the response is in the spec sheet)
    distance   = str2double(extractBetween(response, 2, 5));
    pwm        = str2double(extractBetween(response, 7, 10));
    target     = str2double(extractBetween(response, 12, 15));
    deadpan    = str2double(extractBetween(response, 17, 20));

end