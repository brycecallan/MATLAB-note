function [fv,fviv,fvip,fvC]=farthestINS(removed,rfvc,L,a,b,s,dist,demands,cap)
%% *最远插入启发式：将最小插入目标距离增量最大的元素找出来
%输入removed                          被移出的顾客集合
%输入rfvc                             移出removed中的顾客后的final_vehicles_customer
%输入L                                集配中心时间窗
%输入a                                顾客时间窗
%输入b                                顾客时间窗
%输入s                                服务每个顾客的时间
%输入dist                             距离矩阵
%输入demands                          需求量
%输入cap                              最大载重量
%输出fv                               将removed中所有元素 最佳插入后距离增量最大的元素
%输出fviv                             该元素所插入的车辆
%输出fvip                             该元素所插入的车辆的坐标
%输出fvC                              该元素插入最佳位置后的距离增量
    nr=length(removed);                   %被移出的顾客的数量
    outcome=zeros(nr,3);
    for i=1:nr
        %[车辆序号 插入点序号 距离增量]
        [civ,cip,C]= cheapestIP( removed(i),rfvc,L,a,b,s,dist,demands,cap);
        outcome(i,1)=civ;
        outcome(i,2)=cip;
        outcome(i,3)=C;
    end
    [mc,mc_index]=max(outcome(:,3));
    temp=outcome(mc_index,:);
    fviv=temp(1,1);
    fvip=temp(1,2);
    fvC=temp(1,3);
    fv=removed(mc_index);
end