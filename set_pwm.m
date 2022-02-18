function action = set_pwm(device, pwm_value)
%% Sets the PWM of the fan
% Inputs:
%  ~ device: serialport object controlling the real world system
%  ~ pwm_value: A value from 0 to 4095 to set the pulse width modulation of
%  the actuator
% Outputs:
%  ~ action: the control action to change the PWM
%
% Created by:  Kyle Naddeo 2/4/2022
% Modified by: Whitten Oswald on 2/18/2022

%% Force PWM value to be valid
% Bound value to limits 0 to 4095

UpperBound=4095;
LowerBound=0;

if (pwm_value > UpperBound)
    pwm_value = UpperBound;
elseif (pwm_value < LowerBound)
    pwm_value = LowerBound;
else
    pwm_value = pwm_value;
end


%% Send Command
action = sprintf('P%04.f', pwm_value);
% string value of pwm_value
% use the serialport() command options to change the PWM value to action

end
