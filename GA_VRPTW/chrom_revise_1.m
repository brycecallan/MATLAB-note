function Chrom = chrom_revise_1(Chrom,ET,cusnum,cap,demands,N,LT,L,service_t,dist)
% *����Ⱦɫ�庯��������ʱ�䴰˳������
% Chrom    input   ����ǰ��Ⱦɫ��
% ET       input   ʱ�䴰
% Chrom = [5	7	9	8	6	12	13	4	10	11	21	15	14	16	17	18	19	1	20	22	3	2	23	24	25	26	27	28	29];
for i = 1 :size(Chrom,1)
    [VC,NV,~,~,~,~] = decode(Chrom(i,:),cusnum,cap,demands,ET,LT,L,service_t,dist);
    % ʱ�䴰������
    for j = 1 : NV
        [~,b] = sort(ET(VC{j}));
        VC{j} = VC{j}(b);
    end
    Chrom(i,:) = change(VC,N,cusnum);
end
end