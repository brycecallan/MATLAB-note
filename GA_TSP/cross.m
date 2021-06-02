function child = cross(pop,prob_cross)
% *�������
% pop         input   ������Ⱥ
% prob_cross  input   �������
% child       output  �������Ӵ�
    child = [];
    N = size(pop,1);
    for i = 1:2:N
        parent_1_index = i; % ����1
        parent_2_index = i + 1; % ����2
        child_1 = pop(parent_1_index,1:size(pop,2));
        parent_1 = child_1;
        child_2 = pop(parent_2_index,1:size(pop,2));
        parent_2 = child_2;
        if rand < prob_cross
            % ����λ������Ϊ2-7 �������
            index = sort(ceil((size(pop,2)-3)*rand(1,2))+2);
            for j = index(1):index(2)
                if parent_1(j) ~= parent_2(j)
                    child_1(child_1 == parent_2(j)) =  child_1(j); % ��ǰ��child_1��parent_2(j)��ֵ�滻��child_1(j)
                    child_1(j) = parent_2(j); % ��parent_2(j)��ֵ��ֵ��child_1(j)��
                    
                    child_2(child_2 == parent_1(j)) = child_2(j);
                    child_2(j) = parent_1(j);
                end
            end
        end
        child = [child;child_1;child_2];
    end
end