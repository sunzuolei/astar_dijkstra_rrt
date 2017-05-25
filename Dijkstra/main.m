%% Define a small map
map = false(20);%0值矩阵

% Add an obstacle
map (11:20, 5) = true;
map (11,5:14) = true;
map ( 1:7,10) = true;

start_coords = [16,2];
dest_coords  = [16,10];

%%
close all;
% [route, numExpanded] = DijkstraGrid (map, start_coords, dest_coords);
 % Uncomment following line to run Astar
[route, numExpanded] = DijkstraGrid (map, start_coords, dest_coords);

%HINT: With default start and destination coordinates defined above, numExpanded for Dijkstras should be 76, numExpanded for Astar should be 23.
