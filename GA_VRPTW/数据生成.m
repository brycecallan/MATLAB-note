tic
   %% 清空变量
    clc;clear all;close all;
    % 顾客坐标
    coord = round(1+49*rand(25,2)); % 客户的坐标，均为整数，作为均位于[0.50]
    center = [25,25];
    figure('name','坐标')
    plot(coord(:,1),coord(:,2),'bo');hold on;
    plot(center(:,1),center(:,2),'ro');
    xlabel('X');ylabel('Y');
    grid on;

    % 顾客需求
    demands = round(200+799*rand(25,1))*10; % 客户的需求量，位于[0.2,1]吨
    disp(demands);
    disp(sum(demands)/25);

    % 顾客的服务时间
    service_t = round(20+19*rand(25,1)); % 每个客户的服务时间，[20,40]min
    disp(service_t);                     % 每个客户的服务时间
    disp(sum(service_t)/25);             % 每个顾客的平均服务时间

    % time Windows
    ET = 730 + 15*round((16*rand(25,1)+1));  % 左时间窗
    for i = 1 : size(ET,1)
        num_low1 = mod(ET(i),100);
        num_high1 = floor(ET(i)/100);
        if num_low1 >= 60
            num_high1 = num_high1 + 1;
            num_low1 = mod(num_low1,60);
        end
        ET(i) = num_high1*100 + num_low1;

        temp = 30 + 15*round(3*rand+1);
        LT(i) = ET(i) + temp;                 % 右时间窗
        num_low2 = mod(LT(i),100);
        num_high2 = floor(LT(i)/100);
        if num_low2 >= 60
            num_high2 = num_high2 + 1;
            num_low2 = mod(num_low2,60);
        end
        LT(i) = num_high2*100 + num_low2;
        if LT(i) - ET(i) < 30

        end
    end
toc