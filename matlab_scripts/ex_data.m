% Create example data and save to a CSV file
time = (0:0.01:10)'; % Time in seconds
ax = sin(0.1 * time); 
ay = cos(0.1 * time); 
az = 0.1 * ones(size(time));
gx = 0.01 * sin(0.1 * time); 
gy = 0.01 * cos(0.1 * time); 
gz = 0.01 * ones(size(time));
mx = cos(0.1 * time); 
my = sin(0.1 * time); 
mz = 0.5 * ones(size(time));

% Combine into a table and save as CSV
data = table(time, ax, ay, az, gx, gy, gz, mx, my, mz);
writetable(data, 'data.csv');
disp('Example data.csv file created.');
