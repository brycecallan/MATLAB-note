function Selch = tourment_Select(pop,fitness)
%% 二元锦标赛选择
% 输入pop：           种群
% 输入fitness：       种群对应的适应度函数值
% 输出Selch：          二元锦标赛选择出的个体
[pop_num,N] = size(pop);                    % pop-种群个数、N-种群长度
Selch = zeros(pop_num,N);                     % 初始化二元锦标赛选择出的个体
for i = 1 : pop_num
    R = randperm(pop_num);                    % 生成一个1~pop的随机排列
    index1 = R(1);                        % 第一个比较的个体序号
    index2 = R(2);                        % 第二个比较的个体序号
    fit1 = fitness(index1);               % 第一个比较的个体的适应度值（适应度值越大，说明个体质量越高）
    fit2 = fitness(index2);               % 第二个比较的个体的适应度值
    % 如果个体1的适应度值 大于等于 个体2的适应度值，则将个体1作为第i选择出的个体
    % TODO:fitness低的保留
    if fit1 <= fit2
        Selch(i,:) = pop(index1,:);
    else
        % 如果个体1的适应度值 小于 个体2的适应度值，则将个体2作为第i选择出的个体
        Selch(i,:) = pop(index2,:);
    end
end
end