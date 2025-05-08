% The temp_monitor function is used to create a live graph of temperature
% readings taken every second over a 10 minute time period. The function
% also uses green, red, and yellow to indicate temperature readings. If the
% temperature is between 18 and 24 degrees then the green LED will turn on.
% If the temperature is above 24 degrees than the red LED will flash at
% 0.25 second intervals. If the the temperature is below 18 degrees than
% the yellow LED will flash at 0.5 second intervals.


function temp_monitor(a)
    a = arduino("COM5", "Uno")
    duration = 600;
    tempReadings = [];  % Creates an array to store temperature values
    timeStamps = [];   % Creates an array to store time values
    % Create figure for plotting
    figure;
    hPlot = plot(NaN, NaN); % Create empty plot
    xlabel('Time (seconds)');
    ylabel('Temperature (°C)');
    title('Real-time Temperature Monitoring');
    grid on;
    hold on;
    for i = 1:duration
        Temperate = (readVoltage(a, "A0") - 0.5) / 0.01;
        disp(Temperate);
        % Store temperature and timestamp
        tempReadings(end+1) = Temperate;
        timeStamps(end+1) = i;  % 
        % Update plot
        set(hPlot, 'XData', timeStamps, 'YData', tempReadings);
        xlim([0 max(10, i)]);  % Adjust x-axis as time progresses
        ylim([min(tempReadings)-2 max(tempReadings)+2]);
        % Auto-scale y-axis using the highest temp reading as the max y
        % value
        drawnow; % This forces MATLAB to update the plot
        % Your existing control logic remains unchanged
        if Temperate > 24
            %red flash 0.25
            % all other LED's turned off and red flashes at 0.25 second
            % intervals
            writeDigitalPin(a ,"D5", 0)
            writeDigitalPin(a ,"D4", 0)
            writeDigitalPin(a ,"D6", 1)
            pause(0.25)
            writeDigitalPin(a ,"D6", 0)
            pause(0.25)
            disp("red")
        elseif Temperate >= 18 && Temperate <= 24
            %green solid
            % all other LED's turned offf and green LED is turned on
            writeDigitalPin(a ,"D4", 0)
            writeDigitalPin(a ,"D6", 0)
            writeDigitalPin(a, "D5", 1)
            disp("green")
        else
            %yellow flash 0.50
            % All other LED's turned of and yellow flashes at 0.5 second
            % intervals
            writeDigitalPin(a ,"D5", 0)
            writeDigitalPin(a ,"D6", 0)
            writeDigitalPin(a ,"D4", 1)
            pause(0.50)
            writeDigitalPin(a ,"D4", 0)
            pause(0.50)
            disp("yellow")
        end
    end
end