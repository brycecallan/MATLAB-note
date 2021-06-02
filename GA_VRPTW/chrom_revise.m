function Chrom = chrom_revise(Chrom,ET,cusnum,cap,demands,N,LT,L,service_t,dist)
% *修正染色体函数，按照时间窗顺序排序
% Chrom    input   修正前的染色体
% ET       input   时间窗
% Chrom = [5	7	9	8	6	12	13	4	10	11	21	15	14	16	17	18	19	1	20	22	3	2	23	24	25	26	27	28	29];
for i = 1 :size(Chrom,1)
    [VC,NV,~,~,~,~] = decode(Chrom(i,:),cusnum,cap,demands,ET,LT,L,service_t,dist);
    % 容量的修正
    load_act = [];
    for j = 1 : NV
        load_act(j) = sum(demands(VC{j})); 
    end
    index = find(load_act > cap);
    for j = 1 : length(index)
        while load_act(index(j)) > cap
            num_1 = round((length(VC{index(j)})-1)*rand) + 1;
            index_1 = find(cap - load_act > demands(VC{index(j)}(num_1)));
            if ~isempty(index_1)
                num_2 = round((length(index_1)-1)*rand) + 1;
                VC{index_1(num_2)}(end+1) = VC{index(j)}(num_1);
            else
                VC{length(VC)+1} = VC{index(j)}(num_1); % 再加一辆小车
                load_act(index(j)+1) = demands(VC{index(j)}(num_1));
            end
            load_act(index(j)) = load_act(index(j)) - demands(VC{index(j)}(num_1)); % 移除
            VC{index(j)}(num_1) = [];
        end
    end
    % 时间窗的修正
    for j = 1 : NV
        [~,b] = sort(ET(VC{j}));
        VC{j} = VC{j}(b);
    end
    Chrom(i,:) = change(VC,N,cusnum);
end
end