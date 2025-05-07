% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]

% g) 


% c)
function temp_monitor(a)

% Data carried over
duration = 600;
t = zeros(1, duration)
V0 = 0.5;
Tc = 0.01
Temperature = zeros(1, duration)
% TERM_MONITOR_M - Real-time temperature monitoring with LED indicators
%   Controls 3 LEDs based on temperature ranges and displays live plot
% Inputs:
%   a - Connected Arduino object
% LED Behavior:
%   18-24°C: Green LED steady on
%   <18°C:   Yellow LED blinks (0.5s interval)
%   >24°C:   Red LED blinks (0.25s interval)

% Pin configuration
greenLED = 'D4';
yellowLED = 'D5';
redLED = 'D6';
thermistor = 'A1';

% Initialize LEDs
writeDigitalPin(a, greenLED, 0);
wrtieDigitalPin(a, yellowLED, 0);
writeDigitalPin(a, redLED, 0);

% Plotting the live graph
while true
    Tgraph = plot(t, Temperature, '-0');
    xlabel('Time (S)');
    ylabel('Temperature (C)');
    xlim([1, duration])
    ylim([1, 30])
    title('Live temperature graph');
    grid on;
    drawnow;
end
for n = 1:duration
    t(n) = n;
    voltage = readVoltage(a, 'A1');
    Temperature(n) = (voltage - V0) / Tc;
    set(Tgraph, 'YData', Temperature, 'XData', t)
    drawnow;
end

for n = 1:duration
    t(n) = n;
    voltage = readVoltage(a 'A1');
    Temperature(n) = (voltage - V0) / Tc;
    set(Tgraph, 'YData', Temperature, 'XData', t)
    drawnow;
    % Yellow
    if Temperature < 18 % lower than 18 degrees Celsius
        writeDigitalPin(a, greenLED, 0)
        writeDigitalPin(a, redLED, 0)
        writeDigitalPin(a, yellowLED, 1)
        pause(0.5) % light flashes at 0.5 second intervals
        writeDigitalPin(a, yellowLED, 0)
        pause(0.5)
    % Red
    elseif Temperature > 24 % above 24 degrees Celsius
        writeDigitalPin(a, greenLED, 0)
        writeDigitalPin(a, redLED, 1)
        writeDigitalPin(a, yellowLED, 0)
        pause(0.25) % light flashes at 0.25 second intervals
        writeDigitalPin(a, redLED, 0)
        pause(0.25)
    % Green
    else % else the green light will turn on for 1 second
        writeDigitalPin(a, greenLED, 1)
        writeDigitalPin(a, redLED, 0)
        writeDigitalPin(a, yellowLED, 0)
        pause(1) 
    end
    pause(1)


