function [q] = violateLoad(curr_vc,demands,cap)
%% *计算当前解违反的容量约束
% 输入curr_vc                  当前解
% 输入demands                  各个顾客需求量
% 输入cap                      车辆最大载货量
% 输出q                        各个路径违反载货量之和
    NV = size(curr_vc,1);                     %所用车辆数目
    q = 0;
    for i = 1 : NV
        route = curr_vc{i};
        Ld = leave_load(route,demands);
        if Ld > cap
            q = q + Ld - cap;
        end
    end
end

