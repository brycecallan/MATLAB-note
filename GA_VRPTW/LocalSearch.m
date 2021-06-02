function SelCh = LocalSearch(SelCh,cusnum,cap,demands,ET,LT,L,service_t,dist,Iij)
%%  *局部搜索函数
% 输入：SelCh               被选择的个体
% 输入：cusnum              顾客数目
% 输入：cap                 最大载重量
% 输入：demands             需求量
% 输入：a                   顾客时间窗开始时间[a[i],b[i]]
% 输入：b                   顾客时间窗结束时间[a[i],b[i]]
% 输入：L                   配送中心时间窗结束时间
% 输入：s                   客户点的服务时间
% 输入：dist                距离矩阵，满足三角关系，暂用距离表示花费c[i][j] = dist[i][j]
% 输出：SelCh               进化逆转后的个体
D = 15;                     % Remove过程中的随机元素
toRemove = 8;               % 将要移出顾客的数量
[row,N] = size(SelCh);
for i = 1 : row
    CF = obj_fun(SelCh(i,:),cusnum,cap,demands,ET,LT,L,service_t,dist,Iij);
    [VC,~,~,~,~] = decode(SelCh(i,:),cusnum,cap,demands,ET,LT,L,service_t,dist);
    [removed,rfvc] = Remove(cusnum,toRemove,D,dist,VC);                            % 删除
    [ReIfvc,~] = Re_inserting(removed,rfvc,L,ET,LT,service_t,dist,demands,cap);    % 重新插入
    chrom = change(ReIfvc,N,cusnum);
    % if length(chrom) ~= N
    %     record = ReIfvc;
    %     break;
    % end
    RCF = obj_fun(chrom,cusnum,cap,demands,ET,LT,L,service_t,dist,Iij);          % 计算目标函数
    if RCF < CF
        SelCh(i,:) = chrom;
    end
end
