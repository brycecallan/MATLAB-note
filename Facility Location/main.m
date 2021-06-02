tic
clc;
clear all;
% clear global data;
close all;
warning('off');
% 数据导入
    % load data
    % data为结构体的形式
    data.cost_trans = xlsread('data.xlsx',1,'O4:AM28'); % 单位运输费用
    data.cost_manage = xlsread('data.xlsx',1,'D4:D28'); % 单位管理费用
    data.cost_construct = 5e4; % 建仓费用
    data.city_coordinate = xlsread('data.xlsx',1,'F4:G28'); % 城市的位置
    data.demand = xlsread('data.xlsx',1,'B4:B28'); % 需求量
    global data;
% 算法参数
    M = 500; % 最大迭代次数
    N = 25;  % 粒子个数
    w = 0.63; % 惯性因子
    c1 = 1.45449; % 局部速度因子
    c2 = 1.45449; % 全局速度因子
    num = 3; % 选取配送中心的个数
    pbest = zeros(N,num); % 个体最优
    pbest_fit = zeros(1,N);
    trace = []; % 收敛曲线
% 初始化种群
    pop = popinit(N,num);
    [fitness,~] = obj_fun(pop); % 计算目标函数值
    % 初始化个体最优和全局最优
    pbest = pop;
    pbest_fit = fitness;
    [gbest_fit,index] = min(fitness);
    gbest(1,1:num) = pop(index,1:num);
    clear index;
    v =  rand(N,num) + 4; % 初始速度v 
% 算法循环开始
for iter = 1 : M
    for i = 1 : N
        % 粒子速度和位置的更新
        v(i,:) = w * v(i,:) + c1 * rand * (pbest(i,:) - pop(i,:)) + c2 * rand * (gbest - pop(i,:));
        % TODO:防止溢出
        pop(i,:) = pop(i,:) + v(i,:);
        pop(i,find(pop(i,:) > 25)) = unidrnd(25); % 超出部分随机生成，下同
        pop(i,find(pop(i,:) < 1)) = unidrnd(25);
        pop(i,:) = round(pop(i,:));
        for j = 1 : num
            temp_1(j) = length(find(pop(i,:) == pop(i,j)));
        end
        % 当一个解出现两个一样的配送中心时，重新生成
        if sum(temp_1) > 3
            pop(i,:) = popinit(1,num);
        end
        clear temp_1
    end
    [fitness,~] = obj_fun(pop); % 计算目标函数值 
    % 个体和全局最优更新
    for i = 1 : N
        % 个体最优更新
        if fitness(i) < pbest_fit(i)
            pbest(i,:) = pop(i,:);
            pbest_fit(i) = fitness(i);
        end
        % 全局最优更新
        if fitness(i) < gbest_fit
            gbest(1,1:num) = pop(i,:);
            gbest_fit = fitness(i);
        end 
    end
    % 记录当代最佳个体和种群平均适应度
    trace = [trace;gbest_fit,mean(pbest_fit)];
    if ~mod(iter,5)
        clc;
        fprintf('%d generations completed\n',iter);
    end
end
[~,index] = obj_fun(gbest);
% 绘图1
figure('name','收敛曲线')
plot(trace(:,1),'lineWidth',1.5); % 最优
hold on;
plot(trace(:,2),'lineWidth',1.5); % 平均
legend('最优适应度值','平均适应度值')
title('PSO算法收敛曲线');
xlabel('迭代次数');ylabel('适应度值');
grid on;

% 绘图2（最优配送中心位置）
for i = 1 : 25
    distance(i,:) = dist(data.city_coordinate(i,:),data.city_coordinate(gbest,:)');
end
[~,b] = min(distance'); % 找出各个需求中心距离哪个配送中心较近

figure('name','最优规划派送路线')
cargox = data.city_coordinate(gbest,1);
cargoy = data.city_coordinate(gbest,2);
plot(data.city_coordinate(:,1),data.city_coordinate(:,2),'o','LineWidth',2,'MarkerEdgeColor','b','MarkerSize',10);hold on;% 先画出所有需求中心
plot(cargox,cargoy,'o','LineWidth',2,'MarkerEdgeColor','r','MarkerSize',10);% 再画出所有的配送中心（即覆盖掉）
for i = 1:25
    x = [data.city_coordinate(i,1),data.city_coordinate(gbest(b(i)),1)];
    y = [data.city_coordinate(i,2),data.city_coordinate(gbest(b(i)),2)];
    % 最后画出需求中心对应的配送中心，即图中线段部分
    plot(x,y,'LineWidth',2,'Color',[0.729411780834198 0.831372559070587 0.95686274766922]);hold on;
end
title('最优规划派送路线');
grid on;

% 最优结果输出-fprintf
fprintf(['配送中心节点为：',num2str(gbest),' 总费用为：',num2str(gbest_fit),'\n']);
for i = 1 : num
    word_print = index{i};
    fprintf(['配送中心 ',num2str(i),' 覆盖的需求中心为：',num2str(word_print),'\n']);
end
% clear i and j and b and index and v and word_print
toc