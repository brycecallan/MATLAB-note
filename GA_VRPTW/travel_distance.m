function TD = travel_distance(VC,dist)
%%  *计算每辆车所行驶的距离，以及所有车行驶的总距离
% 输入VC   每辆车所经过的顾客
% 输入dist                距离矩阵
% 输出sumTD               所有车行驶的总距离
% 输出everyTD             每辆车所行驶的距离
TD = 0;
for i = 1 : length(VC)
    for j = 1 : length(VC{i})
        if j == 1 | j == length(VC{i})
            TD = TD + dist(1,VC{i}(j)+1);
        else
            TD = TD + dist(VC{i}(j)+1,VC{i}(j+1)+1);
        end
    end
end