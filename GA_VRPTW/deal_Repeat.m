function dChrom=deal_Repeat(Chrom)
%% *删除种群中重复个体，并补齐删除的个体
% 输入Chrom：种群
% 输出dChrom：处理掉重复个体的种群
    N=size(Chrom,1);                                    %种群数目
    len=size(Chrom,2);                                  %染色体长度
    dChrom=unique(Chrom,'rows');                        %删除重复数组对
    Nd=size(dChrom,1);                                  %剩余个体数目
    newChrom=zeros(N-Nd,len);
    for i=1:N-Nd
        newChrom(i,:)=randperm(len);
    end
    dChrom=[dChrom;newChrom];
end

