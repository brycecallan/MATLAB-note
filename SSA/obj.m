function obj_fun = obj(pop)
% *目标函数计算函数
% pop       input    种群
% obj_fun   output   目标函数值
    global net;
    global outputps;
    [pop_init,~] = mapminmax(pop',0,1); % 归一化
    obj_temp_1 = sim(net,pop_init);     % 开始拟合
    obj_fun = mapminmax('reverse',obj_temp_1,outputps)'; % 反归一化
end