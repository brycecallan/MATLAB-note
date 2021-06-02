function [cost_all,cost_each] = compute1(Chrom,cusnum,cap,demands,ET,LT,L,service_t,dist,Iij)
%  
c_k = 500;                  % 每辆车的固定费用
C0 = 0.125;                 % 配送车辆单位距离燃油消耗量
eta = 2.32;                 % 单位燃油产生的碳排放量 η
c_p = 2.1;                  % 碳税价格 元/kg
alpha = 50;                 % 超出重量的单位惩罚成本 α
w_1 = 100;                  % 提早到达的单位惩罚成本 w_1
w_2 = 200;                  % 延迟到达的单位惩罚成本 w_2
v = 60/60;                  % 行驶速度

[VC,NV,TD,violate_num,violate_cus,route_V] = decode(Chrom,cusnum,cap,demands,ET,LT,L,service_t,dist);
car_num = length(VC);   % 使用小车数量
c_1 = c_k * car_num;    % 固定成本
c_2 = 0;                % 行驶成本
c_31 = 0;               % 碳排放量成本-MEET模型
c_32 = 0;               % 碳排放量成本-传统
c_4 = 0;                % 超出重量的惩罚成本
c_5 = 0;                % 软时间窗成本
for i = 1 : car_num
    route = cell2mat(VC(i)); % 配送路线
    dis_all = 0;             % 此条路径总距离
    goods_a = sum(demands(route));

    % c_2-车辆的行驶成本计算
    for j = 1 : length(route) + 1
        if j == 1 | j == length(route) + 1
            if j == length(route) + 1
                c_2 = c_2 + dist(1,route(j-1)+1) * Iij(route(j-1)+1,1); %  最后一个客户->配送中心
                dis_all = dis_all + dist(1,route(j-1)+1);
            else
                c_2 = c_2 + dist(1,route(j)+1) * Iij(route(j)+1,1); % 配送中心->第一个客户
                dis_all = dis_all + dist(1,route(j)+1);
            end
        else
            c_2 = c_2 + dist(route(j-1)+1,route(j)+1) * Iij(route(j-1)+1,route(j)+1);
            dis_all = dis_all + dist(route(j-1)+1,route(j)+1);
        end
    end

    % c_31-碳排放量成本-MEET模型与到达时间
    time = zeros(length(route),3); % 1 到达时间，2 离开时间，3 路程时间
    e = 0.000375*60*v^3 + 8750/(60*v) + 110;
    G = exp(0.3153*(0.0059*(60*v)^2 - 0.0775*60*v + 11.936)); % 平原地区坡度0-0.5° 
    for j = 1 : length(route)
        r = (goods_a - sum(demands(route(1:j))))/cap;
        lambda = 0.27*r + 0.0614*r - 0.0011*r - 0.00235*r*v-1.33*r/v + 1;
        co_2 = G * e * lambda/1000; % 碳排放率
        if j == 1
            c_31 = c_31 + c_p * co_2 * dist(1,route(j)+1);
        else
            c_31 = c_31 + c_p * co_2 * dist(route(j-1)+1,route(j)+1);
        end

        % 计算到达时间
        if j == 1
            time(j,1) = ET(route(j)); % 配送中心至配送点的时间
        elseif j == length(route)
            time(j,1) = time(j-1,2) + round(dist(route(j)+1 ,1)/v); % 返回配送中心时间
        else
            time(j,1) = time(j-1,2) + round(dist(route(j)+1 ,route(j+1)+1)/v);
        end
        time(j,2) = time(j,1) + service_t(route(j));
    end
    time(:,3) = [time(1,1);time(2:end,1)-time(1:end-1,2)];

    % c_32-碳排放量成本-传统
    c_32  = c_32 + c_p * C0 * dis_all * eta;

    % c_4-超出重量的惩罚成本
    if goods_a > cap
        c_4 = c_4 + alpha * (goods_a-cap);
    end

    % c_5-软时间窗成本计算
    for j = 1 : length(route)
        price_h = [w_1,0,w_2];
        temp_t = zeros(3,1); % 各个时间段内的时间
        if time(j,1) < ET(route(j))
            temp_t(1) = ET(route(j)) - time(j,1); % [0,ETi]
        elseif time(j,1) > LT(route(j))
            temp_t(3) = time(j,1) - LT(route(j)); % [0,ETi]
        end
        c_5 = c_5 + price_h * temp_t;
    end
end

cost_all = c_1 + c_2 + c_31 + c_4 + c_5;
cost_each = [c_1,c_2,c_31,c_4,c_5;0,0,c_32,0,0];