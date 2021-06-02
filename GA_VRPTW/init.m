function Chrom = init(cusnum,a,demands,cap,NIND,N)
%% *初始化路径
% 输入cusnum   顾客数量
% 输入a        左时间窗 [a,b]，最早允许开始服务时间
% 输入demands  每个顾客的需求量
% 输入cap      车辆最大载货量
    Chrom = zeros(NIND,N); % 用于存储种群
    for ii = 1:NIND
        j = ceil(rand*cusnum);                    % 从所有顾客中随机选择一个顾客
        k = 1;                                    % 使用车辆数目，初始设置为1
        init_vc = cell(k,1);
        % 按照如下序列，遍历每个顾客，并执行以下步骤
        if j == 1
            seq = 1:cusnum;
        elseif j == cusnum
            seq = [cusnum,1:j-1];
        else
            seq1 = 1:j-1;
            seq2 = j:cusnum;
            seq = [seq2,seq1];
        end
        % 开始遍历
        route = [];       % 存储每条路径上的顾客
        load_num = 0;     % 初始路径上在仓库的装载量为0
        i = 1;
        while i <= cusnum
            % 如果没有超过容量约束，则按照左时间窗大小，将顾客添加到当前路径
            if load_num + demands(seq(i)) <= cap         
                load_num = load_num + demands(seq(i));          % 初始在仓库的装载量增加
                % 如果当前路径为空，直接将顾客添加到路径中
                if isempty(route)
                    route = [seq(i)];
                % 如果当前路径只有一个顾客，再添加新顾客时，需要根据左时间窗大小进行添加
                elseif length(route) == 1
                    if a(seq(i)) <= a(route(1))
                        route = [seq(i),route];   
                    else
                        route = [route,seq(i)];
                    end
                else
                    lr = length(route);       % 当前路径长度,则有lr-1对连续的顾客
                    flag = 0;                 % 标记是否存在这样1对顾客，能让seq(i)插入两者之间
                    % 遍历这lr-1对连续的顾客的中间插入位置
                    for m = 1 : lr-1
                        if (a(seq(i)) >= a(route(m))) && (a(seq(i)) <= a(route(m + 1)))
                            route = [route(1:m),seq(i),route(m + 1:end)];
                            flag = 1;
                            break
                        end
                    end
                    % 如果不存在这样1对顾客，能让seq(i)插入两者之间，也就是flag = 0，则需要将seq(i)插到route末尾
                    if flag == 0
                        route = [route,seq(i)];
                    end
                end
                % 如果遍历到最后一个顾客，则更新init_vc，并跳出程序
                if i == cusnum
                    init_vc{k,1} = route;
                    break;
                end
                i = i + 1;
            else   % 一旦超过车辆载货量约束，则需要增加一辆车
                % 先储存上一辆车所经过的顾客
                init_vc{k,1} = route;
                % 然后将route清空，load_num清零,k加1
                route = [];
                load_num = 0;
                k = k + 1;
            end
        end 
        chrom = change(init_vc,N,cusnum);
        Chrom(ii,:) = chrom;
    end
end

