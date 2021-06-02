tic
clc;clear all;close all;warning('off');
%% 录入数据
load net; 
global net;
global outputps;

%% 参数初始化
dim = 3; % 参数维度
maxgen = 100; % 进化次数  
sizepop = 200; %种群规模
P_percent = 0.2; % The population size of producers accounts for "P_percent" percent of the total population size       
    % 发现者比例0.2
    % 意识到危险的麻雀数量SD占0.1
ST = 0.8;% 安全阈值
p_num = round(sizepop * P_percent); % 发现者数量

%% 初始化种群
pop = pop_init(sizepop);
fitness = obj(pop);
pFit = fitness;                  
[fMin, bestI] = max(fitness);
bestX = pop(bestI, :); % 最优子代

%% 麻雀搜索算法开始
for t = 1 : maxgen 
    [~,sortIndex] = sort(pFit);
    [fmax,B] = max(pFit);
    worse =  pop(B,:); % 最差子代
    % 发现者的位置更新 Equation (3-4)
    if rand < ST
        % 觅食环境周围没有捕食者
        for i = 1 : p_num 
            % 发现者的位置更新
            a = rand;
            pop(sortIndex(i),:) = pop(sortIndex(i),:) * exp(-i/(a * maxgen));
        end
    else
        % 种群中的麻雀发现捕食者
        for i = 1 : p_num
            % randn(1)是符合正太分布的随机数、ones(1,dim)是1*d的矩阵
            Q = randn(1);
            pop(sortIndex(i), :) = pop(sortIndex(i), :) + Q * ones(1,dim);
        end
    end
    pop = revise(pop);
    fitness = obj(pop);
    [fMMin,bestII] = max(fitness);
    bestXX = pop(bestII,:); % 最优子代

    % 加入者的位置更新 Equation (3-5)
    for i = (p_num + 1) : sizepop 
        A = floor(rand(1,dim)*2)*2 - 1; % A:1*d的矩阵，每个元素随机赋值1或-1
        if i > sizepop/2
            % 适应度值较低的第i个加入者没有获得食物，需飞往其他地方觅食，以获得更多能量
            Q = randn(1);
            pop(sortIndex(i),:) = Q * exp((worse - pop(sortIndex(i),:))/(i^2));
        else
            A_plus = A'*(A*A')^(-1); % A+
            pop(sortIndex(i),:) = bestXX + (abs((pop(sortIndex(i),:) - bestXX))) * A_plus * ones(1,dim);  
        end
    end
    pop = revise(pop);
    fitness = obj(pop);

    % 意识到危险的麻雀的位置 Equation (3-6)
    c = randperm(numel(sortIndex));
    b = sortIndex(c(1:3));
    for j = 1 : length(b)
        if pFit(sortIndex(b(j))) > fMin
            % f_i < f_g时，麻雀处于种群边缘
            b_1 = randn(1,dim);
            pop(sortIndex(b(j)),:) = bestX + b_1 .* (abs((pop(sortIndex(b(j)),:) - bestX)));
        else
            % f_i = f_g时，麻雀意识到了危险，需要靠近通货
            k = 2*rand(1) - 1; % k为[-1,1]的随机数，步长控制参数
            e = 1e-50; % ε,最小的常数，避免分母为0
            pop(sortIndex(b(j)),:) = pop(sortIndex(b(j)),:) + k*(abs(pop(sortIndex(b(j)),:)-worse)) / (pFit(sortIndex(b(j))) - fmax + e);
        end
    end
    pop = revise(pop);
    fitness = obj(pop);
    
    % 更新最优
    for i = 1 : sizepop
        if fitness(i) > pFit(i)
            pFit(i) = fitness(i);
            pop(i,:) = pop(i,:);
        end
        if pFit(i) > fMin
            fMin = pFit(i);
            bestX = pop(i,:);
        end
    end
    trace(t) = fMin; % 存储每一代的最优
    % 进度条
    if ~mod(t,1)
        clc;
        fprintf('%d generations completed\n',t);
    end
end
clear a and Q and A_plus and b_1 and k and k and e

% 输出最优权值
fprintf(['最优参数',num2str(bestX),'\n']);
fprintf(['最优输出',num2str(fMin),'\n']);

%% 结果分析
    figure('name','适应度曲线')
    plot(trace,'lineWidth',1.5,'Color',[1 0 0]);
    title(['适应度曲线  ' '终止代数＝' num2str(maxgen)]);
    xlabel('进化代数');
    ylabel('适应度');
    grid on;
toc