function [route,numExpanded] = DijkstraGrid (input_map, start_coords, dest_coords)

cmap = [1 1 1; ...% 1 - white - clear cell
        0 0 0; ...% 2 - black - obstacle
        0 0 1; ...% 3 - red = visited
        1 1 0; ...% 4 - blue  - on list
        0 1 0; ...% 5 - green - start
        1 0 0; ...% 6 - yellow - destination
	    1 0 1];

colormap(cmap);

% variable to control if the map is being visualized on every
% iteration
drawMapEveryTime = true;

[nrows, ncols] = size(input_map);

% map - a table that keeps track of the state of each grid
% cell（一个表,跟踪每个网格单元的状态）
%nrows=10;ncols=10;
map = zeros(nrows,ncols);

map(~input_map) = 1;   % Mark free cells
map(input_map)  = 2;   % Mark obstacle cells

% Generate linear indices of start and dest nodes
start_node = sub2ind(size(map), start_coords(1), start_coords(2));%输出起点在map中某行某列的索引值
dest_node  = sub2ind(size(map), dest_coords(1),  dest_coords(2));%输出终点在map中某行某列的索引值

map(start_node) = 5;%5-green
map(dest_node)  = 6;%6-yellow

% Initialize distance array
distanceFromStart = Inf(nrows,ncols);%定义一个变量来保存蓝色邻居以及它们到起始格的路程.定义了 distanceFromStart  来保存这些信息，初始化为 Inf，表示从没有访问过。
%一旦有值，就说明是蓝色邻居，赋值的大小就表示该点跟起始点的路程。一旦变成红色，就把它的值再改回 Inf。


% For each grid cell this array holds the index of its parent(根源）
parent = zeros(nrows,ncols);%定义一个变量来保存路径

distanceFromStart(start_node) = 0;%起始点到起始点的距离为0

% keep track of number of nodes expanded 
numExpanded = 0;

% Main Loop
%变量定义完了，那么开始循环搜索路径
while true
    
    % Draw current map
    map(start_node) = 5;
    map(dest_node) = 6;
    
    % make drawMapEveryTime = true if you want to see how the 
    % nodes are expanded on the grid. 
    if (drawMapEveryTime)
        image(1.5, 1.5, map);%image命令画图时，对于超出上下限的值，依旧按照上下限对应的颜色来画
        grid on;%打开网格
        axis image;%图像坐标轴
        drawnow;
    end
    
    % Find the node with the minimum distance
    [min_dist, current] = min(distanceFromStart(:));%搜索中心的索引坐标:current,搜索中心与起始点的路程:min_dist
    
    if ((current == dest_node) || isinf(min_dist))%这里做一些简单判断，如果已经扩张到终点了，或者没有路径，则退出循环。
        break;
    end;
    
    % Update map
    map(current) = 3;         % mark current node as visited 把 map 的前点坐标赋值为 3(红色) ，表示本次循环已经以此为中心搜索一次了。
    distanceFromStart(current) = Inf; % remove this node from further consideration
    
    % Compute row, column coordinates of current node
    [i, j] = ind2sub(size(distanceFromStart), current);% 把索引坐标变成行列坐标，方便计算邻居的坐标。
   
   % ********************************************************************* 
    % YOUR CODE BETWEEN THESE LINES OF STARS
    neighbor = [i-1, j ;... 
                i+1, j ;... 
                i, j+1 ;... 
                i, j-1];
                 
    outRangetest = (neighbor(:,1)<1) + (neighbor(:,1)>nrows) +...
   (neighbor(:,2)<1) + (neighbor(:,2)>ncols );
    locate = find(outRangetest>0);  %搜索到的节点的索引坐标不是 outRangetest 中的 
    neighbor(locate,:)=[];% =[]就是删除的意思。
    
    neighborIndex = sub2ind(size(map),neighbor(:,1),neighbor(:,2));%为了方便，现在把这种行列形式变为索引形式
    for i=1:length(neighborIndex)
        if ((map(neighborIndex(i))~=2) && (map(neighborIndex(i))~=3 && map(neighborIndex(i))~= 5))
        map(neighborIndex(i)) = 4; % 在地图上把邻居变成蓝色。这里纯为了显示用。
       
    % Visit each neighbor of the current node and update the map, distances
    % and parent tables appropriately.
    
         if (distanceFromStart(neighborIndex(i))> min_dist + 1)
            distanceFromStart(neighborIndex(i)) = min_dist+1;  %更新邻居的路程信息
             parent(neighborIndex(i)) = current; % 更新邻居的路径信息
    
    
    
    %*********************************************************************
         end
        end
    end
     
     
end

%% Construct route from start to dest by following the parent links
if (isinf(distanceFromStart(dest_node)))
    route = [];%提取路线坐标
else
    route = [dest_node];
    
    while (parent(route(1)) ~= 0)
        route = [parent(route(1)), route];% 动态显示出路线
    end
    
        % Snippet of code used to visualize the map and the path（代码片段用于可视化地图和路径）
    for k = 2:length(route) - 1        
        map(route(k)) = 7;%粉红色
        pause(0.1);
        image(1.5, 1.5, map);
        grid on;
        axis image;
    end
end

end
