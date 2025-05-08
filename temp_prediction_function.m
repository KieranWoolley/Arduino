% TASK 3 – ALGORITHMS – TEMPERATURE PREDICTION [25 MARKS]

% The function temp_prediction measures the values of real time temperature
% values using methods used in the temp_monitor function. Temperature
% values are read from the thermistor that is connected to the analogue pin
% A1. The implements a 5 value buffer to smooth out the readings and reduce
% noise for accurate values of change in temperature. If the change in
% temperature is above 4 degrees per second the red LED will turn on. If
% the the change in temperature is below -4 degrees per second the yellow
% LED will turn on otherwise the green LED will turn on. The function also
% uses the change in temperature rate to calculate what the temperatre will
% be in 5 minutes.

function temp_prediction(a, duration)
% TEMP_PREDICTION - Monitors temperature with per-second rate and 5-min prediction

a = arduino('COM5', 'Uno'); % Configures the arduino

% Constants
duration = 600;
Range = [18 24]; % °C
rapidThreshold = 4; % 4 degrees per second
predictions = 300; % 5 minutes in seconds
sampleInterval = 1; % seconds

% Pin Configuration
% This sets up the pins to the correct digital outputs
greenLED = 'D4'; % Digital pins for LED's
yellowLED = 'D5';
redLED = 'D6';
thermistor = 'A1'; % This is the analogue pin for the thermistor

% Initialize LEDs
configurePin(a, greenLED, 'DigitalOutput'); 
configurePin(a, yellowLED, 'DigitalOutput');
configurePin(a, redLED, 'DigitalOutput');
% Configure pin to DigitalOutput tells the pin that it will read on and 
% off signals.
writeDigitalPin(a, greenLED, 0); % All the LED's are initally turned off
writeDigitalPin(a, yellowLED, 0);
writeDigitalPin(a, redLED, 0);

% Data Buffer
% This makes the readings smoother as it can reduce the effects of noise/
% spikes. This will improve the quality of data collected and create a more
% accurate prediction of temperature.
% Reads recent measurments
% The NaN values mark out empty slots
bufferSize = 5;
tempBuffer = NaN(1, bufferSize);
timeBuffer = NaN(1, bufferSize);

% Main loop
startTime = tic;  % tic and toc function improves accuracy of timing
while toc(startTime) < duration
    % Read temperature
    voltage = readVoltage(a, thermistor);
    currentTemp = (voltage - 0.5)/0.01; % Temperature conversion using 
    % coefficients
    
    % Update buffers
    tempBuffer = [tempBuffer(2:end), currentTemp];
    timeBuffer = [timeBuffer(2:end), now*86400]; % Converts to seconds
    
    % Calculate rate of change PER SECOND
    if sum(~isnan(tempBuffer)) > 1
        validIdx = ~isnan(tempBuffer);
        ratePerSecond = (tempBuffer(end) - tempBuffer(find(validIdx,1))) / ...
                       (timeBuffer(end) - timeBuffer(find(validIdx,1)));
    else
        ratePerSecond = 0;
    end
    
    % Calculate predicted temperature in 5 minutes (300 seconds)
    predictedTemp = currentTemp + ratePerSecond * predictions;
    
    % Control LEDs (using per-second rate)
    if ratePerSecond > rapidThreshold
        writeDigitalPin(a, greenLED, 0);
        writeDigitalPin(a, yellowLED, 0);
        writeDigitalPin(a, redLED, 1);
    elseif ratePerSecond < -rapidThreshold
        writeDigitalPin(a, greenLED, 0);
        writeDigitalPin(a, yellowLED, 1);
        writeDigitalPin(a, redLED, 0);
    else
        writeDigitalPin(a, greenLED, 1);
        writeDigitalPin(a, yellowLED, 0);
        writeDigitalPin(a, redLED, 0);
    end
    
    % Display status with per-second rate
    fprintf('Current: %.2f°C | ', currentTemp);
    fprintf('Rate: %.4f°C/s | ', ratePerSecond);
    fprintf('Predicted in 5min: %.2f°C | ', predictedTemp);
    
    if abs(ratePerSecond) > rapidThreshold
        fprintf('Warning: Rapid %s!\n', ternary(ratePerSecond>0,'heating','cooling'));
    else
        fprintf('Status: Stable\n');
    end
    
    pause(sampleInterval);
end

% This turns all the LED's off after function has ran
writeDigitalPin(a, greenLED, 0);
writeDigitalPin(a, yellowLED, 0);
writeDigitalPin(a, redLED, 0);
end

function out = ternary(test, yes, no) 
if test
    out = yes;
else
    out = no;
end
end
 % The ternary function is used to make yes or no decisions.
 % This helps the function to decide whether to print heating or cooling.