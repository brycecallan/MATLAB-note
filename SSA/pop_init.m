function pop = pop_init(sizepop)
% *��ʼ����Ⱥ
% sizepop   input   ��Ⱥ��ģ
% pop       output  ��Ⱥ
for j = 1 : sizepop
    pop(j,1) = 4000 + round(4000*rand);   % 4k-8k�������
    pop(j,2) = (10 + 15 * rand)/100;      % 0.1-0.25�������
    pop(j,3) = (2 + round(2 * rand))/100; % 0.02-0.04�������
end
end