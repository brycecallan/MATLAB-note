tic
    clc;clear all;close all;warning('off');
   %% ��������
    load data; % Ԥ����룬dic��ʾ���ڵ��ľ���
    global dic;
   %% ��������
    popSize = 100;        % ��Ⱥ����-����Ϊż��
    num_chrom = 8;        % Ⱦɫ��ĳ���-�����и���
    max_iter = 200;       % ��������
    prob_cross = 0.9;     % �������
    prob_mutate = 0.1;
   %% ��ʼ������
    pop = popinit(popSize,num_chrom); 
    fitness = obj(pop); % ����Ŀ�꺯��ֵ
   %% ��ʼ������
    best_chrom = pop(1,:);                          % ��ʼȫ�����Ÿ���
    best_fit = fitness(1);                          % ��ʼȫ��������Ӧ�Ⱥ���
    iterate_best_chrom = zeros(max_iter,num_chrom); % ��¼ÿ�ε�����ȫ�����Ÿ���
    trace = zeros(max_iter,2);                      % ��¼ÿ�ε�����ƽ��ȫ��������Ӧ��
   %% ѭ����ʼ
    for iter = 1:max_iter
        pop_select = tourment_Select(pop,fitness);  % ��Ԫ������ѡ��
        pop_select = cross(pop_select,prob_cross);  % ����
        pop = mutate(pop_select,prob_mutate);       % ����
        fitness = obj(pop);
        [min_fit,index] = min(fitness);             % �ҳ���ǰ�������Ÿ���
        trace(iter,2) = mean(fitness);              % ��ֵ
        % ����ǰ�������Ÿ�����ȫ�����Ÿ�����бȽϣ������ǰ�����Ÿ�����ã���ȫ�����Ÿ�������滻
        if min_fit < best_fit
            best_chrom = pop(index,:);
            best_fit = min_fit;
        end
        % ��¼ÿһ��ȫ�����Ÿ��壬�����ܾ���
        iterate_best_chrom(iter,:) = best_chrom;
        trace(iter,1) = best_fit;
        % ��ʾ������
        if ~mod(iter,20)
            clc;
            fprintf('%d generations completed\n',iter);
        end
    end
   %% ����ͼ
    figure('name','����ͼ')
    plot(trace(:,1),'-','lineWidth',1.5,'Color',[1 0 0]);hold on;
    plot(trace(:,2),'-','lineWidth',1.5,'Color',[0 0.45 0.74]);
    legend('����','��ֵ');
    xlabel ('��������');ylabel ('ÿ�ε����е����Ÿ���');
    grid on;

   %% ���Ž�����-fprintf
    fprintf(['����·��Ϊ��',num2str(best_chrom),'\n']);
    fprintf(['����Ŀ�꺯��ֵΪ��',num2str(best_fit),'\n']);
toc