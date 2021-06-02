function [ReIfvc,RTD] = Re_inserting(removed,rfvc,L,a,b,s,dist,demands,cap)
%% *将被移出的顾客重新插回所得到的新的车辆顾客分配方案
%% 输入removed                         被移出的顾客集合
% 输入rfvc                             移出removed中的顾客后的final_vehicles_customer
% 输入L                                集配中心时间窗
% 输入a                                顾客时间窗
% 输入b                                顾客时间窗
% 输入s                                服务每个顾客的时间
% 输入dist                             距离矩阵
% 输入demands                          需求量
% 输入cap                              最大载重量
% 输出ReIfvc                           将被移出的顾客重新插回所得到的新的车辆顾客分配方案
% 输出RTD                              新分配方案的总距离
    while ~isempty(removed)
        [fv,fviv,fvip,fvC] = farthestINS(removed,rfvc,L,a,b,s,dist,demands,cap );% 最远插入启发式：将最小插入目标距离增量最大的元素找出来
        removed(removed == fv) = [];
        [rfvc,iTD] = insert(fv,fviv,fvip,fvC,rfvc,dist); % 根据插入点将元素插回到原始解中
    end
    [rfvc,~] = deal_vehicles_customer(rfvc);
    ReIfvc = rfvc;
    RTD = travel_distance(ReIfvc,dist);
end

