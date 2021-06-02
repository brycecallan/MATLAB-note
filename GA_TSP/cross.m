function child = cross(pop,prob_cross)
% *交叉操作
% pop         input   父代种群
% prob_cross  input   交叉概率
% child       output  交叉后的子代
    child = [];
    N = size(pop,1);
    for i = 1:2:N
        parent_1_index = i; % 父代1
        parent_2_index = i + 1; % 父代2
        child_1 = pop(parent_1_index,1:size(pop,2));
        parent_1 = child_1;
        child_2 = pop(parent_2_index,1:size(pop,2));
        parent_2 = child_2;
        if rand < prob_cross
            % 交叉位置设置为2-7 随机生成
            index = sort(ceil((size(pop,2)-3)*rand(1,2))+2);
            for j = index(1):index(2)
                if parent_1(j) ~= parent_2(j)
                    child_1(child_1 == parent_2(j)) =  child_1(j); % 提前将child_1上parent_2(j)的值替换成child_1(j)
                    child_1(j) = parent_2(j); % 将parent_2(j)的值赋值到child_1(j)上
                    
                    child_2(child_2 == parent_1(j)) = child_2(j);
                    child_2(j) = parent_1(j);
                end
            end
        end
        child = [child;child_1;child_2];
    end
end