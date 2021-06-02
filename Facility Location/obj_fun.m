function [cost_all,index] = obj_fun(pop)
% *目标函数计算
% pop       input    初始种群
% cost_all  output   每个种群对应的总成本
% index     output   每个种群的各个配送中心辐射的需求点
    global data; % 全局化data数据，数据为结构体的形式
    cost_c = data.cost_construct * size(pop,2); % 建仓费用
    cost_c = ones(1,size(pop,1)) * cost_c;
    cost_m = zeros(1,size(pop,1)); % 管理费用
    cost_t = zeros(1,size(pop,1)); % 运输费用
    % 找出最近配送点
    index = cell(size(pop,1),size(pop,2)); % 存储各个配送中心辐射的需求点
    for i = 1 : size(pop,1)
        for j = 1 : 25
            distance(j,:) = dist(data.city_coordinate(j,:),data.city_coordinate(pop(i,:),:)'); % 计算需求中心与各个配送中心的距离
        end
        [~,b] = min(distance'); % 找出各个需求中心距离哪个配送中心较近
        for j = 1 : size(pop,2)
            %计算各个派送点的地址
            % pop(i,j)、index{i,j}(k)
            index{i,j} = find(b == j);
            for k = 1 : length(index{i,j})
                cost_m(i) = cost_m(i) + data.cost_manage(pop(i,j)) .* data.demand(index{i,j}(k)); % 管理费用 
                cost_t(i) = cost_t(i) + data.demand(index{i,j}(k)) .* dist(data.city_coordinate(index{i,j}(k),:),data.city_coordinate(pop(i,j),:)') .* data.cost_trans(pop(i,j),index{i,j}(k)); % 运输费用
            end
        end
    end
    cost_all = cost_c + cost_m + cost_t;
end