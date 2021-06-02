function [ifvc,iTD] = insert(fv,fviv,fvip,fvC,rfvc,dist)
%% *根据插入点将元素插回到原始解中
% 输入fv               插回元素
% 输入fviv             将插回元素插回的车辆序号
% 输入fvip             将插回元素插回车辆序号中插入点的位置
% rfvc                 移出removed中的顾客后的final_vehicles_customer
% 输入dist             距离矩阵
% 输出ifvc             插回元素后的rfvc
% iTD                  插回元素后的rfvc的总距离
    ifvc = rfvc;
    sumTD = travel_distance(rfvc,dist);     %插回前的总距离
    iTD = sumTD+fvC;                                  %插回后的总距离
    %% 如果插回车辆属于rfvc中的车辆
    if fviv <= size(rfvc,1)
        route = rfvc{fviv};                               %将元素插回的路径
        len = length(route);
        if fvip == 1
            temp = [fv route];
        elseif fvip == len+1
            temp = [route fv];
        else
            temp = [route(1:fvip-1) fv route(fvip:end)];
        end
        ifvc{fviv} = temp;
    %否则，新增加一辆车
    else 
        ifvc{fviv,1} = [fv];
    end
end

