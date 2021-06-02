function Selch = tourment_Select(pop,fitness)
%% ��Ԫ������ѡ��
% ����pop��           ��Ⱥ
% ����fitness��       ��Ⱥ��Ӧ����Ӧ�Ⱥ���ֵ
% ���Selch��          ��Ԫ������ѡ����ĸ���
[pop_num,N] = size(pop);                    % pop-��Ⱥ������N-��Ⱥ����
Selch = zeros(pop_num,N);                     % ��ʼ����Ԫ������ѡ����ĸ���
for i = 1 : pop_num
    R = randperm(pop_num);                    % ����һ��1~pop���������
    index1 = R(1);                        % ��һ���Ƚϵĸ������
    index2 = R(2);                        % �ڶ����Ƚϵĸ������
    fit1 = fitness(index1);               % ��һ���Ƚϵĸ������Ӧ��ֵ����Ӧ��ֵԽ��˵����������Խ�ߣ�
    fit2 = fitness(index2);               % �ڶ����Ƚϵĸ������Ӧ��ֵ
    % �������1����Ӧ��ֵ ���ڵ��� ����2����Ӧ��ֵ���򽫸���1��Ϊ��iѡ����ĸ���
    % TODO:fitness�͵ı���
    if fit1 <= fit2
        Selch(i,:) = pop(index1,:);
    else
        % �������1����Ӧ��ֵ С�� ����2����Ӧ��ֵ���򽫸���2��Ϊ��iѡ����ĸ���
        Selch(i,:) = pop(index2,:);
    end
end
end