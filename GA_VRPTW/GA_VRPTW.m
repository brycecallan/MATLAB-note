tic
   %% ��ձ���
    clc;clear all;close all;
   %% data
    load data
    %{
    data_1 = xlsread('2.xlsx',1,'B3:G28');
    Iij =  xlsread('2.xlsx',3,'B2:AA27');          % �����ɹ˿�iʻ��˿�jʱ��λ���������ѵķ���
    %}
    % column_1 ���;column_2/3 ����;column_4 ������;column_5/6 �ͻ�Ҫ���ʱ�䴰;column_7 ����ʱ��
    data_1 = data_revise(data_1,1);                % ���ݴ���
    cap = 60000;                                   % �������װ����
   %% ��ȡ������Ϣ
    E = data_1(1,4);                               % ��������ʱ�䴰��ʼʱ��
    L = data_1(1,5);                               % ��������ʱ�䴰����ʱ��
    vertexs = data_1(:,1:2);                       % ���е������x��y
    customer = vertexs(2:end,:);                   % �˿�����
    cusnum = size(customer,1);                     % �˿���
    v_num = 6;                                     % �������ʹ����Ŀ
    demands = data_1(2:end,3);                     % ����������λkg��
    ET = data_1(2:end,4);                          % �˿�Ҫ���ʱ�䴰��ʼʱ��
    LT = data_1(2:end,5);                          % �˿�Ҫ���ʱ�䴰����ʱ��
    service_t = data_1(2:end,6);                   % �ͻ���ķ���ʱ��
    h = pdist(vertexs);
    dist = squareform(h);                          % ��������������ǹ�ϵ�����þ����ʾ����c[i][j] = dist[i][j]
   %% �Ŵ��㷨��������
    NIND = 200;                                    % ��Ⱥ��С
    MAXGEN = 100;                                  % ��������
    Pc = 0.85;                                     % �������
    Pm = 0.15;                                     % �������
    N = cusnum + v_num - 1;                        % Ⱦɫ�峤�� = �˿���Ŀ+�������ʹ����Ŀ-1
   %% ��ʼ����Ⱥ
    Chrom = init(cusnum,ET,demands,cap,NIND,N);    % �����ʼ��
    % Chrom = chrom_revise_1(Chrom,ET,cusnum,cap,demands,N,LT,L,service_t,dist);
    fitness = obj_fun(Chrom,cusnum,cap,demands,ET,LT,L,service_t,dist,Iij); % ������ȺĿ�꺯��ֵ
    best_chrom = Chrom(1,:);  % ��ʼȫ�����Ÿ���
    best_fit = fitness(1); % ��ʼȫ��������Ӧ�Ⱥ���
   %% ѭ������
    for iter = 1 : MAXGEN
        %% ������Ӧ��
        SelCh = tourment_Select(Chrom,fitness); % ��Ԫ������ѡ��
        SelCh = Recombin(SelCh,Pc);             % OX�������
        SelCh = Mutate(SelCh,Pm);               % ����

        SelCh = LocalSearch(SelCh,cusnum,cap,demands,ET,LT,L,service_t,dist,Iij); % �ֲ���������
        Chrom = Reins(Chrom,SelCh,fitness);    % �ز����Ӵ�������Ⱥ
        Chrom = deal_Repeat(Chrom);            % ɾ����Ⱥ���ظ����壬������ɾ���ĸ���
        Chrom = chrom_revise_1(Chrom,ET,cusnum,cap,demands,N,LT,L,service_t,dist);

        fitness =  obj_fun(Chrom,cusnum,cap,demands,ET,LT,L,service_t,dist,Iij); % ������ȺĿ�꺯��ֵ
        % *����ͼ����
        [min_fit,min_index] = min(fitness); % �ҳ���ǰ�������Ÿ���
        % ����ǰ�������Ÿ�����ȫ�����Ÿ�����бȽϣ������ǰ�����Ÿ�����ã���ȫ�����Ÿ�������滻
        if min_fit < best_fit
            bestChrom = Chrom(min_index,:);
            best_fit = min_fit;
        end
        % ��¼ÿһ��ȫ�����Ÿ��壬�����ܾ���
        trace(iter,1:2) = [best_fit,mean(fitness)];

        if ~mod(iter,1)
            clc;
            fprintf('%d generations completed\n',iter);
         end
    end
   %% �������Ž��·��ͼ
    % ������Ž��·�ߺ��ܾ���
    format short g
    [bestVC,bestNV,bestTD,best_vionum,best_viocus,route_V] = decode(bestChrom,cusnum,cap,demands,ET,LT,L,service_t,dist);
    fprintf(['���Ž�:','����ʹ����Ŀ��',num2str(bestNV),'����С�ɱ���',num2str(best_fit),'\n'])
    % fprintf(['Υ��Լ��·����Ŀ��',num2str(best_vionum),'��Υ��Լ���˿���Ŀ��',num2str(best_viocus),'\n']);
    % fprintf(['Υ��Լ����·����\n']);
    % for i = 1 : length(route_V)
    %     fprintf([num2str(route_V{i}),'\n']);
    % end
    % fprintf(['\n']);
    flag = Judge(bestVC,cap,demands,ET,LT,L,service_t,dist); % �ж����Ž��Ƿ�����ʱ�䴰Լ����������Լ����0��ʾΥ��Լ����1��ʾ����ȫ��Լ��
    [cost_all,cost_each] = compute1(bestChrom,cusnum,cap,demands,ET,LT,L,service_t,dist,Iij);
    format short g
    fprintf(['����ɱ�Ϊ\n']);
    disp(cost_each);
    
   %% ���Ƶ���ͼ����·ͼ
    figure('name','����ͼ')
    plot(trace(:,1),'-','lineWidth',1.5,'Color',[1,0,0]);
    % hold on;
    % plot(trace(:,2),'-','lineWidth',1.5,'Color',[0,0.45,0.74]);
    % legend('����','��ֵ');
    xlabel('��������');ylabel('ÿ�ε����е����Ÿ���');
    grid on;
    draw_Best(bestVC,vertexs);
    % clear i SelCh cusnum best_viocus best_vionum cap demands dist E L et ET lt lt iter v_num vertexs N NIND
toc