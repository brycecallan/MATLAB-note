function child = mutate(pop,prob_mutate)
% *变异操作 
% pop         input   父代种群
% prob_mutate input   变异概率
% child       output  变异后的子代
child = [];
N = size(pop,1);
for i = 1:N
    if rand < prob_mutate
        % 单点变异
        parent_3_index = i;
        mutate_loacte = randperm(size(pop,2)-2); % 变异位置
        index_1 = mutate_loacte(1); % 变异位置1
        index_2 = mutate_loacte(1); % 变异位置2
        child_3 = pop(parent_3_index,:);
        % 交换位置
        temp = child_3(index_1);
        child_3(index_1) = child_3(index_2);
        child_3(index_2) = temp;
        child = [child;child_3];
    else
        child = [child;pop(i,:)];
    end
end
end