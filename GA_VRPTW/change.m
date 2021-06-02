function chrom = change(VC,N,cusnum)
%% *���ͷ��������֮�����ת��
    NV = size(VC,1); % ����ʹ����Ŀ
    chrom = [];
    for i = 1 : NV
        if (cusnum + i) <= N
            chrom = [chrom,VC{i},cusnum + i];
        else
            chrom = [chrom,VC{i}];
        end
    end
    % ���Ⱦɫ�峤��С��N������Ҫ��Ⱦɫ������������ı��
    if length(chrom) < N
        supply = (cusnum+NV+1):N;
        chrom = [chrom,supply];
    end
end