function pop = popinit(popSize,num_chrom)
% *初始化种群操作 
% popSize      input    种群大小
% num_chrom    input    染色体长度
% pop          output   种群
for i = 1 : popSize
    temp = randperm(num_chrom);
    index1 = find(temp == 1); % temp中1的值的位置
    temp(index1) = temp(1); % 换位置
    temp(1) = 1; % 把初始位置换成 1
    index2 = find(temp == num_chrom); % temp中8的值的位置
    temp(index2) = temp(num_chrom);
    temp(num_chrom) = num_chrom; % 把初始位置换成 8
    pop(i,1:num_chrom) = temp;
end
end