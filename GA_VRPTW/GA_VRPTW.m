tic
   %% 清空变量
    clc;clear all;close all;
   %% data
    load data
    %{
    data_1 = xlsread('2.xlsx',1,'B3:G28');
    Iij =  xlsread('2.xlsx',3,'B2:AA27');          % 车辆由顾客i驶向顾客j时单位距离所花费的费用
    %}
    % column_1 编号;column_2/3 坐标;column_4 需求量;column_5/6 客户要求的时间窗;column_7 服务时长
    data_1 = data_revise(data_1,1);                % 数据处理
    cap = 60000;                                   % 车辆最大装载量
   %% 提取数据信息
    E = data_1(1,4);                               % 配送中心时间窗开始时间
    L = data_1(1,5);                               % 配送中心时间窗结束时间
    vertexs = data_1(:,1:2);                       % 所有点的坐标x和y
    customer = vertexs(2:end,:);                   % 顾客坐标
    cusnum = size(customer,1);                     % 顾客数
    v_num = 6;                                     % 车辆最多使用数目
    demands = data_1(2:end,3);                     % 需求量（单位kg）
    ET = data_1(2:end,4);                          % 顾客要求的时间窗开始时间
    LT = data_1(2:end,5);                          % 顾客要求的时间窗结束时间
    service_t = data_1(2:end,6);                   % 客户点的服务时间
    h = pdist(vertexs);
    dist = squareform(h);                          % 距离矩阵，满足三角关系，暂用距离表示花费c[i][j] = dist[i][j]
   %% 遗传算法参数设置
    NIND = 200;                                    % 种群大小
    MAXGEN = 100;                                  % 迭代次数
    Pc = 0.85;                                     % 交叉概率
    Pm = 0.15;                                     % 变异概率
    N = cusnum + v_num - 1;                        % 染色体长度 = 顾客数目+车辆最多使用数目-1
   %% 初始化种群
    Chrom = init(cusnum,ET,demands,cap,NIND,N);    % 构造初始解
    % Chrom = chrom_revise_1(Chrom,ET,cusnum,cap,demands,N,LT,L,service_t,dist);
    fitness = obj_fun(Chrom,cusnum,cap,demands,ET,LT,L,service_t,dist,Iij); % 计算种群目标函数值
    best_chrom = Chrom(1,:);  % 初始全局最优个体
    best_fit = fitness(1); % 初始全局最优适应度函数
   %% 循环过程
    for iter = 1 : MAXGEN
        %% 计算适应度
        SelCh = tourment_Select(Chrom,fitness); % 二元锦标赛选择
        SelCh = Recombin(SelCh,Pc);             % OX交叉操作
        SelCh = Mutate(SelCh,Pm);               % 变异

        SelCh = LocalSearch(SelCh,cusnum,cap,demands,ET,LT,L,service_t,dist,Iij); % 局部搜索操作
        Chrom = Reins(Chrom,SelCh,fitness);    % 重插入子代的新种群
        Chrom = deal_Repeat(Chrom);            % 删除种群中重复个体，并补齐删除的个体
        Chrom = chrom_revise_1(Chrom,ET,cusnum,cap,demands,N,LT,L,service_t,dist);

        fitness =  obj_fun(Chrom,cusnum,cap,demands,ET,LT,L,service_t,dist,Iij); % 计算种群目标函数值
        % *迭代图数据
        [min_fit,min_index] = min(fitness); % 找出当前代中最优个体
        % 将当前代中最优个体与全局最优个体进行比较，如果当前代最优个体更好，则将全局最优个体进行替换
        if min_fit < best_fit
            bestChrom = Chrom(min_index,:);
            best_fit = min_fit;
        end
        % 记录每一代全局最优个体，及其总距离
        trace(iter,1:2) = [best_fit,mean(fitness)];

        if ~mod(iter,1)
            clc;
            fprintf('%d generations completed\n',iter);
         end
    end
   %% 画出最优解的路线图
    % 输出最优解的路线和总距离
    format short g
    [bestVC,bestNV,bestTD,best_vionum,best_viocus,route_V] = decode(bestChrom,cusnum,cap,demands,ET,LT,L,service_t,dist);
    fprintf(['最优解:','车辆使用数目：',num2str(bestNV),'，最小成本：',num2str(best_fit),'\n'])
    % fprintf(['违反约束路径数目：',num2str(best_vionum),'，违反约束顾客数目：',num2str(best_viocus),'\n']);
    % fprintf(['违反约束的路径：\n']);
    % for i = 1 : length(route_V)
    %     fprintf([num2str(route_V{i}),'\n']);
    % end
    % fprintf(['\n']);
    flag = Judge(bestVC,cap,demands,ET,LT,L,service_t,dist); % 判断最优解是否满足时间窗约束和载重量约束，0表示违反约束，1表示满足全部约束
    [cost_all,cost_each] = compute1(bestChrom,cusnum,cap,demands,ET,LT,L,service_t,dist,Iij);
    format short g
    fprintf(['各项成本为\n']);
    disp(cost_each);
    
   %% 绘制迭代图与线路图
    figure('name','迭代图')
    plot(trace(:,1),'-','lineWidth',1.5,'Color',[1,0,0]);
    % hold on;
    % plot(trace(:,2),'-','lineWidth',1.5,'Color',[0,0.45,0.74]);
    % legend('最优','均值');
    xlabel('迭代次数');ylabel('每次迭代中的最优个体');
    grid on;
    draw_Best(bestVC,vertexs);
    % clear i SelCh cusnum best_viocus best_vionum cap demands dist E L et ET lt lt iter v_num vertexs N NIND
toc