function dChrom=deal_Repeat(Chrom)
%% *ɾ����Ⱥ���ظ����壬������ɾ���ĸ���
% ����Chrom����Ⱥ
% ���dChrom��������ظ��������Ⱥ
    N=size(Chrom,1);                                    %��Ⱥ��Ŀ
    len=size(Chrom,2);                                  %Ⱦɫ�峤��
    dChrom=unique(Chrom,'rows');                        %ɾ���ظ������
    Nd=size(dChrom,1);                                  %ʣ�������Ŀ
    newChrom=zeros(N-Nd,len);
    for i=1:N-Nd
        newChrom(i,:)=randperm(len);
    end
    dChrom=[dChrom;newChrom];
end

