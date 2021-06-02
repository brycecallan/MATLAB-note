tic
% *穷举验证操作
    clc;clear all
    % a = qiongju(6);
    % combntns(set,subset) %在集合set中取subset个元素的所有组合,相当于Cmn
    % perms(vector) 给出向量vector的所有排列,穷举
    a = perms(1:6);
    a = a + 1;
    num = size(a,1);
    pop = [ones(num,1),a,8*ones(num,1)];
    load data; % 预设距离，dic表示各节点间的距离
    global dic;
    fitness = obj(pop);
    [min_fit,index1] = min(fitness);
    fprintf(['穷举验证的结果为\n']);
    fprintf(['目标函数值： ',num2str(min_fit),'\n']);
    fprintf(['路线： ',num2str(pop(index1,:)),'\n']);
toc