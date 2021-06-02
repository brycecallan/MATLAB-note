tic
    clc;clear all;close all;warning('off');
   %% 导入数据
    load data; % 预设距离，dic表示各节点间的距离
    global dic;
   %% 导入数据
    popSize = 100;        % 种群数量-必须为偶数
    num_chrom = 8;        % 染色体的长度-即城市个数
    max_iter = 200;       % 迭代次数
    prob_cross = 0.9;     % 交叉概率
    prob_mutate = 0.1;
   %% 初始解生成
    pop = popinit(popSize,num_chrom); 
    fitness = obj(pop); % 计算目标函数值
   %% 初始化最优
    best_chrom = pop(1,:);                          % 初始全局最优个体
    best_fit = fitness(1);                          % 初始全局最优适应度函数
    iterate_best_chrom = zeros(max_iter,num_chrom); % 记录每次迭代中全局最优个体
    trace = zeros(max_iter,2);                      % 记录每次迭代中平均全局最优适应度
   %% 循环开始
    for iter = 1:max_iter
        pop_select = tourment_Select(pop,fitness);  % 二元锦标赛选择
        pop_select = cross(pop_select,prob_cross);  % 交叉
        pop = mutate(pop_select,prob_mutate);       % 变异
        fitness = obj(pop);
        [min_fit,index] = min(fitness);             % 找出当前代中最优个体
        trace(iter,2) = mean(fitness);              % 均值
        % 将当前代中最优个体与全局最优个体进行比较，如果当前代最优个体更好，则将全局最优个体进行替换
        if min_fit < best_fit
            best_chrom = pop(index,:);
            best_fit = min_fit;
        end
        % 记录每一代全局最优个体，及其总距离
        iterate_best_chrom(iter,:) = best_chrom;
        trace(iter,1) = best_fit;
        % 显示进度条
        if ~mod(iter,20)
            clc;
            fprintf('%d generations completed\n',iter);
        end
    end
   %% 迭代图
    figure('name','迭代图')
    plot(trace(:,1),'-','lineWidth',1.5,'Color',[1 0 0]);hold on;
    plot(trace(:,2),'-','lineWidth',1.5,'Color',[0 0.45 0.74]);
    legend('最优','均值');
    xlabel ('迭代次数');ylabel ('每次迭代中的最优个体');
    grid on;

   %% 最优结果输出-fprintf
    fprintf(['最优路线为：',num2str(best_chrom),'\n']);
    fprintf(['最优目标函数值为：',num2str(best_fit),'\n']);
toc