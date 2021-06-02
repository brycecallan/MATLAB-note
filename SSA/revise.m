function pop_revise = revise(pop)
% *��Ⱥ������ 
% pop          input    �޸�ǰ��pop
% pop_revise   output   �޸�ǰ��pop
for i = 1 : size(pop,1)
    for j  = 1 : size(pop,2)
        if j == 1
            if pop(i,1) < 4000 | pop(i,1) > 8000  
                pop(i,1) = 4000 + round(4000*rand); % 4k-8k�������
            end
        end
        if j == 2
            if pop(i,2) < 0.1 | pop(i,2) > 0.25
                pop(i,2) = (10 + 15 * rand)/100; % 0.1-0.25�������
            end
        end
        if j == 3
            if pop(i,3) < 0.02 | pop(i,3) > 0.04 
                pop(i,3) = (2 + round(2 * rand))/100; % 0.02-0.04�������
            end
        end
    end
end
pop_revise = pop;
end