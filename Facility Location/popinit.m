function pop = popinit(n,length)
% *��Ⱥ��ʼ������
% n       input    ��Ⱥ����
% length  input    ��Ⱥ����
% pop     output   ��ʼ��Ⱥ
    for i = 1 : n
        [~,b] = sort(rand(1,25));
        pop(i,:) = b(1:length);
    end
end