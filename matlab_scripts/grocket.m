% Read data from the CSV file
data = readtable('gdata.csv');

% Create an orientation sensor object
orientSensor = orientationSensor('DataFormat', 'quaternion');

% Initialize arrays to store quaternions and rotated accelerations
numRows = height(data);
quaternions = zeros(numRows, 4); % 4 for [qx, qy, qz, qw]
rotatedAccelerations = zeros(numRows, 3); % for [ax, ay, az]

% Loop through each row of data
for i = 1:numRows
    % Extract the sensor data
    ax = data{i, 'ax'};   % ax in column 'ax'
    ay = data{i, 'ay'};   % ay in column 'ay'
    az = data{i, 'az'};   % az in column 'az'
    gx = data{i, 'gx'};   % gx in column 'gx'
    gy = data{i, 'gy'};   % gy in column 'gy'
    gz = data{i, 'gz'};   % gz in column 'gz'
    mx = data{i, 'mx'};   % mx in column 'mx'
    my = data{i, 'my'};   % my in column 'my'
    mz = data{i, 'mz'};   % mz in column 'mz'

    % Update the sensor with accelerometer, gyroscope, and magnetometer data
    update(orientSensor, [ax, ay, az], [gx, gy, gz], [mx, my, mz]);

    % Store the quaternion from the rocket frame
    quaternions(i, :) = orientSensor.Quaternion;

    % Create a rotation matrix from the quaternion
    R = quat2rotm(quaternions(i, :)); % Convert quaternion to rotation matrix

    % Rotate the acceleration vector
    acc = [ax; ay; az]; % Create a vector for acceleration
    rotatedAcc = R * acc; % Rotate to Earth frame

    % Store the rotated acceleration
    rotatedAccelerations(i, :) = rotatedAcc';
end

% Extract the gravity component
gravity = rotatedAccelerations(:, 3); % Assuming z-axis is up in the Earth frame

% Plotting
figure;

% 1. Rocket Frame Accelerations
subplot(2, 2, 1);
hold on;
plot(data.time, data.ax, 'r', 'DisplayName', 'ax');
plot(data.time, data.ay, 'g', 'DisplayName', 'ay');
plot(data.time, data.az, 'b', 'DisplayName', 'az');
title('Accelerations in Rocket Frame');
xlabel('Time (s)');
ylabel('Acceleration (m/s^2)');
legend;
grid on;
hold off;

% 2. Earth Frame Accelerations
subplot(2, 2, 2);
hold on;
plot(data.time, rotatedAccelerations(:, 1), 'r', 'DisplayName', 'rotated ax');
plot(data.time, rotatedAccelerations(:, 2), 'g', 'DisplayName', 'rotated ay');
plot(data.time, rotatedAccelerations(:, 3), 'b', 'DisplayName', 'rotated az');
title('Accelerations in Earth Frame');
xlabel('Time (s)');
ylabel('Acceleration (m/s^2)');
legend;
grid on;
hold off;

% 3. 3D Path of Travel of the Rocket
figure;
plot3(cumsum(rotatedAccelerations(:, 1)), ...
      cumsum(rotatedAccelerations(:, 2)), ...
      cumsum(rotatedAccelerations(:, 3)), 'LineWidth', 2);
title('3D Path of Travel of the Rocket');
xlabel('X (integrated ax)');
ylabel('Y (integrated ay)');
zlabel('Z (integrated az)');
grid on;

% 4. Gravity Component
figure;
plot(gravity, 'k', 'LineWidth', 2);
title('Gravity Component in Earth Frame');
xlabel('Time (samples)');
ylabel('Gravity (m/s^2)');
grid on;
