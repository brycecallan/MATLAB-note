function pop = popinit(popSize,num_chrom)
% *��ʼ����Ⱥ���� 
% popSize      input    ��Ⱥ��С
% num_chrom    input    Ⱦɫ�峤��
% pop          output   ��Ⱥ
for i = 1 : popSize
    temp = randperm(num_chrom);
    index1 = find(temp == 1); % temp��1��ֵ��λ��
    temp(index1) = temp(1); % ��λ��
    temp(1) = 1; % �ѳ�ʼλ�û��� 1
    index2 = find(temp == num_chrom); % temp��8��ֵ��λ��
    temp(index2) = temp(num_chrom);
    temp(num_chrom) = num_chrom; % �ѳ�ʼλ�û��� 8
    pop(i,1:num_chrom) = temp;
end
end