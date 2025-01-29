trajDataFile = 'rocket_position.csv';
quatDataFile = 'quaternions.csv';

% Read the trajectory data from the CSV file
trajectoryData = readtable(trajDataFile);
disp('Trajectory data variables:');
disp(trajectoryData.Properties.VariableNames);

% Extract the position data (X, Y, Z) and time
time = trajectoryData.Time;
xPos = trajectoryData.X_Position;
yPos = trajectoryData.Y_Position;
zPos = trajectoryData.Z_Position;

% Plot 3D trajectory
figure;
plot3(xPos, yPos, zPos, 'LineWidth', 1.5);
grid on;
xlabel('X');
ylabel('Y');
zlabel('Z');
title('3D Orientation Trajectory');

% Read the quaternion data from the CSV file
quaternionData = readtable(quatDataFile);
disp('Quanternion data variables:');
disp(quaternionData.Properties.VariableNames);

% Extract the time and quaternion component (assuming Var2 is the quaternion value)
time = quaternionData.time;
q0 = quaternionData.Var2;  % Use Var2 for quaternion data

% 2D plot of the quaternion component (q0)
figure;
plot(time, q0, 'r', 'LineWidth', 1.5); 
xlabel('Time (s)');
ylabel('Quaternion Component q0');
grid on;
title('Quaternion q0 Over Time');