tic
clc;clear all;close all;warning('off');
%% ¼������
load net; 
global net;
global outputps;

%% ������ʼ��
dim = 3; % ����ά��
maxgen = 100; % ��������  
sizepop = 200; %��Ⱥ��ģ
P_percent = 0.2; % The population size of producers accounts for "P_percent" percent of the total population size       
    % �����߱���0.2
    % ��ʶ��Σ�յ���ȸ����SDռ0.1
ST = 0.8;% ��ȫ��ֵ
p_num = round(sizepop * P_percent); % ����������

%% ��ʼ����Ⱥ
pop = pop_init(sizepop);
fitness = obj(pop);
pFit = fitness;                  
[fMin, bestI] = max(fitness);
bestX = pop(bestI, :); % �����Ӵ�

%% ��ȸ�����㷨��ʼ
for t = 1 : maxgen 
    [~,sortIndex] = sort(pFit);
    [fmax,B] = max(pFit);
    worse =  pop(B,:); % ����Ӵ�
    % �����ߵ�λ�ø��� Equation (3-4)
    if rand < ST
        % ��ʳ������Χû�в�ʳ��
        for i = 1 : p_num 
            % �����ߵ�λ�ø���
            a = rand;
            pop(sortIndex(i),:) = pop(sortIndex(i),:) * exp(-i/(a * maxgen));
        end
    else
        % ��Ⱥ�е���ȸ���ֲ�ʳ��
        for i = 1 : p_num
            % randn(1)�Ƿ�����̫�ֲ����������ones(1,dim)��1*d�ľ���
            Q = randn(1);
            pop(sortIndex(i), :) = pop(sortIndex(i), :) + Q * ones(1,dim);
        end
    end
    pop = revise(pop);
    fitness = obj(pop);
    [fMMin,bestII] = max(fitness);
    bestXX = pop(bestII,:); % �����Ӵ�

    % �����ߵ�λ�ø��� Equation (3-5)
    for i = (p_num + 1) : sizepop 
        A = floor(rand(1,dim)*2)*2 - 1; % A:1*d�ľ���ÿ��Ԫ�������ֵ1��-1
        if i > sizepop/2
            % ��Ӧ��ֵ�ϵ͵ĵ�i��������û�л��ʳ�����������ط���ʳ���Ի�ø�������
            Q = randn(1);
            pop(sortIndex(i),:) = Q * exp((worse - pop(sortIndex(i),:))/(i^2));
        else
            A_plus = A'*(A*A')^(-1); % A+
            pop(sortIndex(i),:) = bestXX + (abs((pop(sortIndex(i),:) - bestXX))) * A_plus * ones(1,dim);  
        end
    end
    pop = revise(pop);
    fitness = obj(pop);

    % ��ʶ��Σ�յ���ȸ��λ�� Equation (3-6)
    c = randperm(numel(sortIndex));
    b = sortIndex(c(1:3));
    for j = 1 : length(b)
        if pFit(sortIndex(b(j))) > fMin
            % f_i < f_gʱ����ȸ������Ⱥ��Ե
            b_1 = randn(1,dim);
            pop(sortIndex(b(j)),:) = bestX + b_1 .* (abs((pop(sortIndex(b(j)),:) - bestX)));
        else
            % f_i = f_gʱ����ȸ��ʶ����Σ�գ���Ҫ����ͨ��
            k = 2*rand(1) - 1; % kΪ[-1,1]����������������Ʋ���
            e = 1e-50; % ��,��С�ĳ����������ĸΪ0
            pop(sortIndex(b(j)),:) = pop(sortIndex(b(j)),:) + k*(abs(pop(sortIndex(b(j)),:)-worse)) / (pFit(sortIndex(b(j))) - fmax + e);
        end
    end
    pop = revise(pop);
    fitness = obj(pop);
    
    % ��������
    for i = 1 : sizepop
        if fitness(i) > pFit(i)
            pFit(i) = fitness(i);
            pop(i,:) = pop(i,:);
        end
        if pFit(i) > fMin
            fMin = pFit(i);
            bestX = pop(i,:);
        end
    end
    trace(t) = fMin; % �洢ÿһ��������
    % ������
    if ~mod(t,1)
        clc;
        fprintf('%d generations completed\n',t);
    end
end
clear a and Q and A_plus and b_1 and k and k and e

% �������Ȩֵ
fprintf(['���Ų���',num2str(bestX),'\n']);
fprintf(['�������',num2str(fMin),'\n']);

%% �������
    figure('name','��Ӧ������')
    plot(trace,'lineWidth',1.5,'Color',[1 0 0]);
    title(['��Ӧ������  ' '��ֹ������' num2str(maxgen)]);
    xlabel('��������');
    ylabel('��Ӧ��');
    grid on;
toc