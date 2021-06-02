function [VC,NV,TD,violate_num,violate_cus,route_V] = decode(chrom,cusnum,cap,demands,et,lt,L,service_t,dist)
    %%  *解码函数
    % 输入：chrom               个体
    % 输入：cusnum              顾客数目
    % 输入：cap                 最大载重量
    % 输入：demands             需求量
    % 输入：a                   顾客时间窗开始时间[a[i],b[i]]
    % 输入：b                   顾客时间窗结束时间[a[i],b[i]]
    % 输入：L                   配送中心时间窗结束时间
    % 输入：s                   客户点的服务时间
    % 输入：dist                距离矩阵，满足三角关系，暂用距离表示花费c[i][j] = dist[i][j]
    % 输出：VC                  每辆车所经过的顾客，是一个cell数组
    % 输出：NV                  车辆使用数目
    % 输出：TD                  车辆行驶总距离
    % 输出：violate_num         违反约束路径数目
    % 输出：violate_cus         违反约束顾客数目
    % 输出：route_V             违反约束的路径
    violate_num = 0;                                      % 违反约束路径数目
    violate_cus = 0;                                      % 违反约束顾客数目
    VC = cell(cusnum,1);                                  % 每辆车所经过的顾客
    count = 1;                                            % 车辆计数器，表示当前车辆使用数目
    location0 = find(chrom>cusnum);                       % 找出个体中配送中心的位置
    for i = 1:length(location0)
        if i == 1                                         % 第1个配送中心的位置
            route = chrom(1:location0(i));                % 提取两个配送中心之间的路径
            route(route == chrom(location0(i))) = [];       % 删除路径中配送中心序号
        else
            route = chrom(location0(i-1):location0(i));   % 提取两个配送中心之间的路径
            route(route == chrom(location0(i-1))) = [];     % 删除路径中配送中心序号
            route(route == chrom(location0(i))) = [];       % 删除路径中配送中心序号
        end
        VC{count} = route;                                % 更新配送方案
        count = count + 1;                                  % 车辆使用数目
    end
    route = chrom(location0(end):end);                    % 最后一条路径       
    route(route == chrom(location0(end))) = [];             % 删除路径中配送中心序号
    VC{count} = route;                                    % 更新配送方案
    [VC,NV] = deal_vehicles_customer(VC);                 % 将VC中空的数组移除
    route_V = {};
    for j = 1 : NV
        route = cell(1,1);                                % 开辟临时元胞数组变量route，存储preroute
        route{1} = VC{j};
        flag = Judge(route,cap,demands,et,lt,L,service_t,dist);     % 判断当前方案是否满足时间窗约束和载重量约束，0表示违反约束，1表示满足全部约束
        if flag == 0
            violate_num = violate_num + 1;                  % 如果这条路径不满足约束，则违反约束路径数目加1
            violate_cus = violate_cus + length(route{1});   % 如果这条路径不满足约束，则违反约束顾客数目加该条路径顾客数目
            route_V{length(route_V)+1} = VC{j};
        end
    end
    TD = travel_distance(VC,dist); % 该方案车辆行驶总距离
end