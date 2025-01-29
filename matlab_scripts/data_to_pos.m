% Read data from CSV
data = readtable('data.csv');
time = data.time;
accelData = [data.ax, data.ay, data.az];
gyroData = [data.gx, data.gy, data.gz];
magData = [data.mx, data.my, data.mz];

% Create the sensor fusion filter (complementary filter in this case)
fusionFilter = complementaryFilter('SampleRate', 1 / mean(diff(time)));

% Preallocate quaternion array
quaternions = quaternion.zeros(size(time));

% Process the data
for i = 1:length(time)
    % Call the filter as a function to update with sensor readings
    quaternions(i) = fusionFilter(accelData(i, :), gyroData(i, :), magData(i, :));
end

% Save the quaternion components to a CSV file
quaternionTable = table(time, parts(quaternions));
writetable(quaternionTable, 'quaternions.csv');

disp('Quaternion data saved to quaternions.csv');

% Convert quaternions to Euler angles for visualization (yaw, pitch, roll)
eulerAngles = eulerd(quaternions, 'ZYX', 'frame');

% 3D trajectory visualization
% Define a fixed vector to visualize orientation in 3D space
vector = [1, 0, 0]; % Define as a row vector

% 3D trajectory visualization
trajectory = zeros(length(time), 3);

for i = 1:length(quaternions)
    % Rotate the vector using the quaternion
    trajectory(i, :) = rotatepoint(quaternions(i), vector);
end

% Store the trajectory data in a new CSV file
trajectoryTable = table(time, trajectory(:, 1), trajectory(:, 2), trajectory(:, 3), ...
    'VariableNames', {'Time', 'X_Position', 'Y_Position', 'Z_Position'});

writetable(trajectoryTable, 'rocket_position.csv');

disp('Trajectory data saved to rocket_position.csv');