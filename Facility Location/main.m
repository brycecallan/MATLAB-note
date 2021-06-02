tic
clc;
clear all;
% clear global data;
close all;
warning('off');
% ���ݵ���
    % load data
    % dataΪ�ṹ�����ʽ
    data.cost_trans = xlsread('data.xlsx',1,'O4:AM28'); % ��λ�������
    data.cost_manage = xlsread('data.xlsx',1,'D4:D28'); % ��λ�������
    data.cost_construct = 5e4; % ���ַ���
    data.city_coordinate = xlsread('data.xlsx',1,'F4:G28'); % ���е�λ��
    data.demand = xlsread('data.xlsx',1,'B4:B28'); % ������
    global data;
% �㷨����
    M = 500; % ����������
    N = 25;  % ���Ӹ���
    w = 0.63; % ��������
    c1 = 1.45449; % �ֲ��ٶ�����
    c2 = 1.45449; % ȫ���ٶ�����
    num = 3; % ѡȡ�������ĵĸ���
    pbest = zeros(N,num); % ��������
    pbest_fit = zeros(1,N);
    trace = []; % ��������
% ��ʼ����Ⱥ
    pop = popinit(N,num);
    [fitness,~] = obj_fun(pop); % ����Ŀ�꺯��ֵ
    % ��ʼ���������ź�ȫ������
    pbest = pop;
    pbest_fit = fitness;
    [gbest_fit,index] = min(fitness);
    gbest(1,1:num) = pop(index,1:num);
    clear index;
    v =  rand(N,num) + 4; % ��ʼ�ٶ�v 
% �㷨ѭ����ʼ
for iter = 1 : M
    for i = 1 : N
        % �����ٶȺ�λ�õĸ���
        v(i,:) = w * v(i,:) + c1 * rand * (pbest(i,:) - pop(i,:)) + c2 * rand * (gbest - pop(i,:));
        % TODO:��ֹ���
        pop(i,:) = pop(i,:) + v(i,:);
        pop(i,find(pop(i,:) > 25)) = unidrnd(25); % ��������������ɣ���ͬ
        pop(i,find(pop(i,:) < 1)) = unidrnd(25);
        pop(i,:) = round(pop(i,:));
        for j = 1 : num
            temp_1(j) = length(find(pop(i,:) == pop(i,j)));
        end
        % ��һ�����������һ������������ʱ����������
        if sum(temp_1) > 3
            pop(i,:) = popinit(1,num);
        end
        clear temp_1
    end
    [fitness,~] = obj_fun(pop); % ����Ŀ�꺯��ֵ 
    % �����ȫ�����Ÿ���
    for i = 1 : N
        % �������Ÿ���
        if fitness(i) < pbest_fit(i)
            pbest(i,:) = pop(i,:);
            pbest_fit(i) = fitness(i);
        end
        % ȫ�����Ÿ���
        if fitness(i) < gbest_fit
            gbest(1,1:num) = pop(i,:);
            gbest_fit = fitness(i);
        end 
    end
    % ��¼������Ѹ������Ⱥƽ����Ӧ��
    trace = [trace;gbest_fit,mean(pbest_fit)];
    if ~mod(iter,5)
        clc;
        fprintf('%d generations completed\n',iter);
    end
end
[~,index] = obj_fun(gbest);
% ��ͼ1
figure('name','��������')
plot(trace(:,1),'lineWidth',1.5); % ����
hold on;
plot(trace(:,2),'lineWidth',1.5); % ƽ��
legend('������Ӧ��ֵ','ƽ����Ӧ��ֵ')
title('PSO�㷨��������');
xlabel('��������');ylabel('��Ӧ��ֵ');
grid on;

% ��ͼ2��������������λ�ã�
for i = 1 : 25
    distance(i,:) = dist(data.city_coordinate(i,:),data.city_coordinate(gbest,:)');
end
[~,b] = min(distance'); % �ҳ������������ľ����ĸ��������ĽϽ�

figure('name','���Ź滮����·��')
cargox = data.city_coordinate(gbest,1);
cargoy = data.city_coordinate(gbest,2);
plot(data.city_coordinate(:,1),data.city_coordinate(:,2),'o','LineWidth',2,'MarkerEdgeColor','b','MarkerSize',10);hold on;% �Ȼ���������������
plot(cargox,cargoy,'o','LineWidth',2,'MarkerEdgeColor','r','MarkerSize',10);% �ٻ������е��������ģ������ǵ���
for i = 1:25
    x = [data.city_coordinate(i,1),data.city_coordinate(gbest(b(i)),1)];
    y = [data.city_coordinate(i,2),data.city_coordinate(gbest(b(i)),2)];
    % ��󻭳��������Ķ�Ӧ���������ģ���ͼ���߶β���
    plot(x,y,'LineWidth',2,'Color',[0.729411780834198 0.831372559070587 0.95686274766922]);hold on;
end
title('���Ź滮����·��');
grid on;

% ���Ž�����-fprintf
fprintf(['�������Ľڵ�Ϊ��',num2str(gbest),' �ܷ���Ϊ��',num2str(gbest_fit),'\n']);
for i = 1 : num
    word_print = index{i};
    fprintf(['�������� ',num2str(i),' ���ǵ���������Ϊ��',num2str(word_print),'\n']);
end
% clear i and j and b and index and v and word_print
toc