% Kieran Woolley
% egykw7@nottingham.ac.uk

%% PRELIMINARY TASK - ARDUINO AND GIT INSTILLATION [10 MARKS]
clc
clear % arduino was already setup with variable a
a = arduino('COM5', 'Uno');
for i = 1:10
writeDigitalPin(a,'D5',1)
pause(0.5) % light stays on for 0.5 seconds
writeDigitalPin(a,'D5',0)
pause(0.5) % light stays off for 0.5 seconds
end

%% Task 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]
clear
clc
% b)
a = arduino('COM5', 'Uno');
duration = 600; % Duration of data collection
analoge_A1 = 'A1';
voltage_A1 = zeros(1,duration); % 1 second intervals to collect data
temperature = zeros(1, duration);

Tc = 0.01; % Tc = temperature coefficient
V0 = 0.5; % V0 = zero-degree voltage

for time = 1:duration
    volts = readVoltage(a, analoge_A1);
    tempD_C = (volts - V0)/ Tc;
    % Equation to calculate temperature in degrees celcius

    voltage_A1(time) = volts;
    temperature(time) = tempD_C;
pause(1)
end
% Data statistics
highest_temp = max(temperature);
lowest_temp = min(temperature);
average_temp = mean(temperature);

fprintf('Max Temp: %.2f °C\n', highest_temp);
fprintf('Min Temp: %.2f °C\n', lowest_temp);
fprintf('Average Temp: %.2f °C\n', average_temp);

% c) - temperature/ time plot
Time = 0:duration-1;
plot(Time, temperature);
xlabel('Time (S)');
ylabel('Temperature (Degrees Celcius)');
title('Temperature over time');

%%


    
