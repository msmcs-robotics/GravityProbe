clc;
clear all;
close all;

% Specify the COM port assigned to the ESP32
comPort = 'COM36'; % Replace with your COM port
baudRate = 115200; % Match the ESP32 baud rate

% Initialize serial port connection
try
    esp32 = serialport(comPort, baudRate); % Create serial port object
    configureTerminator(esp32, "LF"); % Match ESP32's line ending
    disp('Connected to ESP32!');
catch ME
    error('Failed to open COM port. Ensure the ESP32 is paired and the port is correct.');
end

% Prepare real-time plot
figure;
t = tiledlayout(4, 1);

% Acceleration plot
ax1 = nexttile;
hAcc = plot(ax1, nan, nan, 'r', nan, nan, 'g', nan, nan, 'b');
title(ax1, 'Acceleration (m/s^2)');
xlabel(ax1, 'Time (s)');
ylabel(ax1, 'Acceleration');
legend(ax1, {'aX', 'aY', 'aZ'});

% Angular velocity plot
ax2 = nexttile;
hGyro = plot(ax2, nan, nan, 'r', nan, nan, 'g', nan, nan, 'b');
title(ax2, 'Angular Velocity (rad/s)');
xlabel(ax2, 'Time (s)');
ylabel(ax2, 'Angular Velocity');
legend(ax2, {'wX', 'wY', 'wZ'});

% Magnetic field plot
ax3 = nexttile;
hMag = plot(ax3, nan, nan, 'r', nan, nan, 'g', nan, nan, 'b');
title(ax3, 'Magnetic Field (uT)');
xlabel(ax3, 'Time (s)');
ylabel(ax3, 'Magnetic Field');
legend(ax3, {'mX', 'mY', 'mZ'});

% Earth-frame acceleration plot
ax4 = nexttile;
hEarth = plot(ax4, nan, nan, 'r', nan, nan, 'g', nan, nan, 'b');
title(ax4, 'Earth-Frame Acceleration (m/s^2)');
xlabel(ax4, 'Time (s)');
ylabel(ax4, 'Acceleration');
legend(ax4, {'EarthX', 'EarthY', 'EarthZ'});

% Initialize data buffers
dataWindow = 100; % Number of data points to display
timeData = zeros(dataWindow, 1);
accelData = zeros(dataWindow, 3); % aX, aY, aZ
gyroData = zeros(dataWindow, 3); % wX, wY, wZ
magData = zeros(dataWindow, 3); % mX, mY, mZ
earthAccelData = zeros(dataWindow, 3); % EarthX, EarthY, EarthZ

startTime = tic;
timeOffset = -1; % Initialize the time offset with an invalid value

disp('Reading data...');
while true
    try
        % Read a line of data
        line = readline(esp32);
        values = sscanf(line, '%lu,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
try
    % Read a line of data
    line = readline(esp32);
    %disp(['Raw data: ', line]); % Debug print
    
    values = sscanf(line, '%lu,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f');
    
    % Check if the correct number of values is parsed
    if numel(values) == 17
        % Process data as usual
        ...
    else
        warning('lUnexpected data format. Skipping this line: %s', line);
    end
catch ME
    warning('Error reading data: %s', ME.message);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        
        % Check if the correct number of values is parsed
        if numel(values) == 17
            % Extract and process the data
            timestamp = values(1) / 1000; % Convert milliseconds to seconds
            
            % Set time offset on first valid timestamp
            if timeOffset == -1 && timestamp > 0
                timeOffset = timestamp;
                disp(['Time offset set to: ', num2str(timeOffset)]);
            end
            
            % Adjust timestamp
            adjustedTime = timestamp - timeOffset;
            
            % Extract sensor data
            ax = values(2); ay = values(3); az = values(4); 
            wx = values(5); wy = values(6); wz = values(7); 
            mx = values(8); my = values(9); mz = values(10);
            qx = values(11); qy = values(12); qz = values(13); qw = values(14);
            earthX = values(15); earthY = values(16); earthZ = values(17);
            
            % Update data buffers
            timeData = [timeData(2:end); adjustedTime];
            accelData = [accelData(2:end, :); [ax, ay, az]];
            gyroData = [gyroData(2:end, :); [wx, wy, wz]];
            magData = [magData(2:end, :); [mx, my, mz]];
            earthAccelData = [earthAccelData(2:end, :); [earthX, earthY, earthZ]];
            
            % Display the data in the command window
            fprintf('Timestamp: %.2f\n', adjustedTime);
            fprintf('Acceleration: aX=%.2f, aY=%.2f, aZ=%.2f\n', ax, ay, az);
            fprintf('Angular Velocity: wX=%.2f, wY=%.2f, wZ=%.2f\n', wx, wy, wz);
            fprintf('Magnetic Field: mX=%.2f, mY=%.2f, mZ=%.2f\n', mx, my, mz);
            fprintf('Earth Acceleration: EarthX=%.2f, EarthY=%.2f, EarthZ=%.2f\n\n', earthX, earthY, earthZ);
            
            % Update plots
            % Acceleration
            set(hAcc(1), 'XData', timeData, 'YData', accelData(:, 1)); % aX
            set(hAcc(2), 'XData', timeData, 'YData', accelData(:, 2)); % aY
            set(hAcc(3), 'XData', timeData, 'YData', accelData(:, 3)); % aZ
            
            % Angular velocity
            set(hGyro(1), 'XData', timeData, 'YData', gyroData(:, 1)); % wX
            set(hGyro(2), 'XData', timeData, 'YData', gyroData(:, 2)); % wY
            set(hGyro(3), 'XData', timeData, 'YData', gyroData(:, 3)); % wZ
            
            % Magnetic field
            set(hMag(1), 'XData', timeData, 'YData', magData(:, 1)); % mX
            set(hMag(2), 'XData', timeData, 'YData', magData(:, 2)); % mY
            set(hMag(3), 'XData', timeData, 'YData', magData(:, 3)); % mZ
            
            % Earth-frame acceleration
            set(hEarth(1), 'XData', timeData, 'YData', earthAccelData(:, 1)); % EarthX
            set(hEarth(2), 'XData', timeData, 'YData', earthAccelData(:, 2)); % EarthY
            set(hEarth(3), 'XData', timeData, 'YData', earthAccelData(:, 3)); % EarthZ
            
            drawnow; % Update the plots
        else
            warning('Unexpected data format. Skipping this line: %s', line);
        end
    catch ME
        warning('Error reading data: %s', ME.message);
        break;
    end
end

% Cleanup
clear esp32; % Release the COM port when done
disp('Disconnected from ESP32.');

%% % Assuming the following data are available as column vectors:
% ax, ay, az: Acceleration in the sensor frame (m/s^2)
% wx, wy, wz: Angular velocity (rad/s)
% mx, my, mz: Magnetic field (uT)

% Sample rate (Hz)
sampleRate = 50; % Adjust based on your data rate

% Create an AHRS filter object
ahrs = ahrsfilter('SampleRate', sampleRate);

% Initialize matrices for quaternions and Earth-frame acceleration
numSamples = length(ax); % Total number of samples
quaternions = zeros(numSamples, 4); % q0, q1, q2, q3
earthAccel = zeros(numSamples, 3); % Earth-frame acceleration: X, Y, Z

% Process the data
for i = 1:numSamples
    % Update the AHRS filter with the current sensor data
    [orientation, ~] = ahrs(wx(i), wy(i), wz(i), ax(i), ay(i), az(i), mx(i), my(i), mz(i));
    
    % Store the orientation quaternion
    quaternions(i, :) = orientation; % [q0, q1, q2, q3]
    
    % Rotate the acceleration vector into the Earth frame
    earthAccel(i, :) = rotatepoint(quaternion(orientation), [ax(i), ay(i), az(i)]);
end

% Plot the results
figure;

% Plot quaternions
subplot(2, 1, 1);
plot(1:numSamples, quaternions);
title('Quaternions');
xlabel('Sample Index');
ylabel('Quaternion Value');
legend({'q0', 'q1', 'q2', 'q3'});

% Plot Earth-frame acceleration
subplot(2, 1, 2);
plot(1:numSamples, earthAccel);
title('Earth-Frame Acceleration');
xlabel('Sample Index');
ylabel('Acceleration (m/s^2)');
legend({'EarthX', 'EarthY', 'EarthZ'});

disp('Analysis complete.');

%%
% Assuming the following data are available as column vectors:
% ax, ay, az: Acceleration in the sensor frame (m/s^2)
% wx, wy, wz: Angular velocity (rad/s)
% mx, my, mz: Magnetic field (uT)

% Sample rate (Hz)
sampleRate = 50; % Adjust based on your data rate

% Create an AHRS filter object
ahrs = ahrsfilter('SampleRate', sampleRate);

% Initialize matrices for quaternions and Earth-frame acceleration
numSamples = length(ax); % Total number of samples
quaternions = zeros(numSamples, 4); % q0, q1, q2, q3
earthAccel = zeros(numSamples, 3); % Earth-frame acceleration: X, Y, Z

% Process the data
for i = 1:numSamples
    % Update the AHRS filter with the current sensor data
    orientation = update(ahrs, [wx(i), wy(i), wz(i)], [ax(i), ay(i), az(i)], [mx(i), my(i), mz(i)]);
    
    % Store the orientation quaternion
    quaternions(i, :) = orientation; % [q0, q1, q2, q3]
    
    % Rotate the acceleration vector into the Earth frame
    earthAccel(i, :) = rotatepoint(quaternion(orientation), [ax(i), ay(i), az(i)]);
end

% Plot the results
figure;

% Plot quaternions
subplot(2, 1, 1);
plot(1:numSamples, quaternions);
title('Quaternions');
xlabel('Sample Index');
ylabel('Quaternion Value');
legend({'q0', 'q1', 'q2', 'q3'});

% Plot Earth-frame acceleration
subplot(2, 1, 2);
plot(1:numSamples, earthAccel);
title('Earth-Frame Acceleration');
xlabel('Sample Index');
ylabel('Acceleration (m/s^2)');
legend({'EarthX', 'EarthY', 'EarthZ'});

disp('Analysis complete.');