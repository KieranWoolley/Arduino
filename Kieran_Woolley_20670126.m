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
% d)
disp('CABIN TEMPERATURE LOG');

fprintf('Location: %s\n', 'Nottingham'); 
fprintf('Date: %s\n\n', datestr(now, '06/05/2025')); % Shows the date
fprintf('Minute\tTemperature (°C)\n');
fprintf('------\t---------------\n');

% Display data every minute (60 seconds)
for minute = 0:9 % For 10 minutes (600 seconds)
    time_index = minute * 60 + 1; % Convert minutes to 1-second index
    if time_index <= duration % ends the for loop when time limit exceeds 600 seconds
        fprintf('%d\t\t%.2f\n', minute, temperature(time_index));
    end
end

fprintf('\nStatistics:\n');
fprintf('Maximum temperature: %.2f °C\n', highest_temp);
fprintf('Minimum temperature: %.2f °C\n', lowest_temp);
fprintf('Average temperature: %.2f °C\n\n', average_temp);

%%
% e)
clc
fileID = fopen('cabin_temperature.txt', 'w');
% This creates a new file with the same formatting as part d)
fprintf(fileID, 'CABIN TEMPERATURE LOG\n');
fprintf(fileID, 'Location: %s\n', 'Nottingham'); 
fprintf(fileID, 'Date: %s\n\n', datestr(now, '06/05/2025')); 
fprintf(fileID, 'Minute\tTemperature (°C)\n');
fprintf(fileID, '------\t---------------\n');

% Write data every minute (60 seconds)
for minute = 0:9 % For 10 minutes (600 seconds)
    time_index = minute * 60 + 1; % Convert minutes to 1-second index
    if time_index <= duration
        fprintf(fileID, '%d\t\t%.2f\n', minute, temperature(time_index));
    end
end

fprintf(fileID, '\nStatistics:\n');
fprintf(fileID, 'Maximum temperature: %.2f °C\n', highest_temp);
fprintf(fileID, 'Minimum temperature: %.2f °C\n', lowest_temp);
fprintf(fileID, 'Average temperature: %.2f °C\n', average_temp);

fclose(fileID);

%% TASK - 2 LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]
clear
% a) assemble the arduino and breadboard

% b) create a flow chart for the task
a = arduino('COM5', 'Uno');

temp_monitor(a);

doc temp_monitor

%%


    
