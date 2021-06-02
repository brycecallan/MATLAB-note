function child = mutate(pop,prob_mutate)
% *������� 
% pop         input   ������Ⱥ
% prob_mutate input   �������
% child       output  �������Ӵ�
child = [];
N = size(pop,1);
for i = 1:N
    if rand < prob_mutate
        % �������
        parent_3_index = i;
        mutate_loacte = randperm(size(pop,2)-2); % ����λ��
        index_1 = mutate_loacte(1); % ����λ��1
        index_2 = mutate_loacte(1); % ����λ��2
        child_3 = pop(parent_3_index,:);
        % ����λ��
        temp = child_3(index_1);
        child_3(index_1) = child_3(index_2);
        child_3(index_2) = temp;
        child = [child;child_3];
    else
        child = [child;pop(i,:)];
    end
end
end