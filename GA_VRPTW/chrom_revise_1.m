function Chrom = chrom_revise_1(Chrom,ET,cusnum,cap,demands,N,LT,L,service_t,dist)
% *修正染色体函数，按照时间窗顺序排序
% Chrom    input   修正前的染色体
% ET       input   时间窗
% Chrom = [5	7	9	8	6	12	13	4	10	11	21	15	14	16	17	18	19	1	20	22	3	2	23	24	25	26	27	28	29];
for i = 1 :size(Chrom,1)
    [VC,NV,~,~,~,~] = decode(Chrom(i,:),cusnum,cap,demands,ET,LT,L,service_t,dist);
    % 时间窗的修正
    for j = 1 : NV
        [~,b] = sort(ET(VC{j}));
        VC{j} = VC{j}(b);
    end
    Chrom(i,:) = change(VC,N,cusnum);
end
end