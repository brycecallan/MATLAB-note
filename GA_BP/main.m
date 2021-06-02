tic
% ��ձ���
    clc;close all;clear all;warning('off');
    nntwarn off;% ��ʱ�ر������繤����ľ��湦��
% ���ݵ���
    load data
%% �Ŵ��㷨�Ż�����
   % BP��������
    BP.inputnum = 3;% ����ѵ�����ݵ�index
    BP.hiddenmun = 5;% ������ڵ���
    BP.outputnum = 6;% �����ڵ���
    BP.output_name = {'Gel','Q','H','L','M','S'};
    BP.data_num = 9; % ����+�������
    BP.testnum = 72;% ����������ݵ�����
    BP.num = size(data,1);
    lenchrom = BP.inputnum * BP.hiddenmun + BP.hiddenmun + BP.hiddenmun * BP.outputnum + BP.outputnum;% �Ŵ��㷨���볤��
    global data;
    global BP;
    global lenchrom;
   % ��ʼ��BP����
    [input_train,ps,output_train,ts] = getBPinfo;
   % GA����
    bound = ones(lenchrom,1)*[-2,2]; % ������
    popNum = 50; % ��Ⱥ��Ŀ
    genNum = 100; % ��������
    initPop = initializega(popNum,bound,'gabpEval');% ���ù�����initializega������Ⱥ��ʼ��
   % �Ŵ����㣬��goat������������gabpEval��������Ϊmax��
    [x,~,~,trace] = ga(bound,'gabpEval',[],initPop,[1e-6 1 0],'maxGenTerm',genNum,'normGeomSelect',[0.09],['arithXover'],[2],'nonUnifMutation',[2 genNum 3]);
    %                  ���½� ��Ӧ�Ⱥ���    ��ʼ��Ⱥ                  ��ֹѭ������  
    % xΪ��õ����Ž⡢traceΪÿһ����õ���Ӧ�Ⱥ�ƽ����Ӧ��   
% �Ŵ��Ż�����Ա�
    figure('name','ÿһ����ƽ�����ƽ���ͱȽ�')
    plot(trace(:,1),1./trace(:,2)/popNum,'-','lineWidth',2,'Color',[1 0 0]);hold on;
    plot(trace(:,1),1./trace(:,3)/popNum,'-.','lineWidth',2,'Color',[0 0.447058826684952 0.74117648601532]);
    xlabel ('��������');ylabel ('���ƽ����');
    title('ÿһ����ƽ�����ƽ���ͱȽ�');
    legend('Best Sum-Squared Error' , 'Avg Sum-Squared Error');
    grid on;
% BP��ʼԤ��
   % ����BP����
    net = newff(minmax(input_train),[BP.hiddenmun,BP.outputnum],{'tansig' 'logsig'},'trainlm');
    %{
    % TODO:newff��ѵ������
        (1) traingd�������ݶ��½����������ٶȱȽ�����
        (2) traingda������Ӧѧϰ�ʵ��ݶ��½���
        (3) traingdm�����ж�������ݶ��½���, ͨ��Ҫ��traingd �ٶȿ졣
        (4) traingdx: ���ж����������Ӧѧϰ�㷨, �ٶ�Ҫ��traingdm �졣
        (5) trainrp: ����BP �㷨, ���������ٶȿ��ռ���ڴ�С���ŵ㡣
        (6) traincgf: Fletcher-Reeves �����ݶȷ�,Ϊ�����ݶȷ��д洢��Ҫ����С���㷨��
        (7) traincgp: Polak-Ribiers�����ݶ��㷨, �洢����traincgf�Դ�,����ĳЩ�����������졣
        (8) traincgb: Powell-Beale�����ݶ��㷨,�洢����traincgp�Դ�,��һ���������죬�������ֹ����ݶȷ�,����Ҫ��������������
        (9) trainscg: ��һ�������ݶȷ�,��Ψһһ�ֲ���Ҫ���������Ĺ����ݶȷ���
        (10) trainbfg: BFGS- ��ţ�ٷ�, ����Ҫ�Ĵ洢�ռ�ȹ����ݶȷ�Ҫ��,ÿ�ε�����ʱ��ҲҪ��,��ͨ����������ʱ����ĵ�������Ҫ�ȹ����ݶȷ���,�Ƚ��ʺ�С�����硣
        (11) traino ss: һ���ָ,Ϊ�����ݶȷ�����ţ�ٷ���һ�����Է�����
        (12) trainlm: Levenberg-Marquardt�㷨,���еȹ�ģ��������˵, ���ٶ�����һ��ѵ���㷨, ��ȱ����ռ���ڴ�ϴ󡣶��ڴ�������, ����ͨ���ò���mem-reduc Ϊ1, 2, 3,?,��Jacobian �����Ϊ�����Ӿ��󡣵�����Ҳ�б׶�, ϵͳ�����������Jacobian�ĸ��Ӿ����кܴ��ϵ��
        (13) trainbr: ��Ҷ˹����,��Levenberg-Marquardt�㷨�����޸�, ��ʹ����ķ����������á�ͬʱ������ȷ����������ṹ���Ѷȡ�
    %}
   % ��ȡ�Ŵ��㷨�Ľ��ΪBP��������Ӧ��Ȩֵ����ֵ
    [W1,B1,W2,B2,input_train,output_train,~,~,~,~] = gadecod(x);
    net.iw {1,1} = W1;
    net.lw {2,1} = W2;
    net.b{1} = B1;
    net.b{2} = B2;
    % �����������
    net.trainParam.epochs = 5000; % ѵ������
    net.trainParam.lr = 0.01; % ѧϰ����
    net.trainParam.goal = 0.00001; % ѵ��Ŀ����С���
    % net.trainParam.min_grad = 1e-6; % ��С�����ݶ�
    % net.trainParam.min_fail = 5; % ���ȷ��ʧ�ܴ���
    % net.trainParam.show = 20; % ��ʾƵ�ʣ���������Ϊûѵ��20����ʾһ��
    % net.trainParam.mc = 0.95;% ���Ӷ�������
    % ��ʼѵ��������
    net = train(net,input_train,output_train);

% Ԥ��
    predict_21 = sim(net,input_train);% predict_21ΪԤ��Ľ��-��һ����Ľ��
    output_predict = mapminmax('reverse',predict_21,ts);% �Ѿ�����һ����
    output_train = mapminmax('reverse',output_train,ts);
    % ��ͼ
    figure('name','ѵ������Ԥ����ʵ�ʵľ������')
    for i = 1 : BP.outputnum
        subplot(3,2,i);
        y = 1:BP.testnum;
        plot(y,output_predict(i,:),'rp','lineWidth',2);hold on;
        plot(y,output_train(i,:),'b*','lineWidth',2);
        xlabel('ʵ������');ylabel(['ָ��',num2str(i),' - ',BP.output_name{i}]);
        legend('Ԥ��','����');
        title(['ѵ������','ָ��',num2str(i),' - ',BP.output_name{i}]);
        % xlim([0,BP.testnum+1]);
        grid on;
        error(i) = sumsqr(output_train(i,:) - output_predict(i,:))/BP.data_num;
        fprintf(['ѵ������','ָ��',num2str(i),' - ',BP.output_name{i},':Ԥ����ʵ�ʵľ������',num2str(error(i)),'\n']);
    end

% ��ʣ�༸�����ݽ���Ԥ��Ա�
    fprintf(['\n']);% ����ָ���
    input_test = data(BP.testnum+1:size(data,1),1:BP.inputnum);
    output_test = data(BP.testnum+1:size(data,1),BP.inputnum+1:BP.data_num);
    input_test = input_test';
    output_test = output_test';
    %��һ������
    [input_test,tps] = mapminmax(input_test,0,1);
    [output_test,tts] = mapminmax(output_test,0,1);
    predict_21 = sim(net,input_test);
    output_predict = mapminmax('reverse',predict_21,tts);
    output_test = mapminmax('reverse',output_test,tts);
    % ��ͼ
    figure('name','����Ԥ����ʵ�ʵľ������')
    for i = 1 : BP.outputnum
        subplot(3,2,i);
        y = 1:size(data,1)-BP.testnum;
        plot(y,output_predict(i,:),'rp','lineWidth',2);hold on;
        plot(y,output_test(i,:),'b*','lineWidth',2);
        xlabel('ʵ������');ylabel(['ָ��',num2str(i),' - ',BP.output_name{i}]);
        title(['����Ԥ�⣺','ָ��',num2str(i),' - ',BP.output_name{i}]);
        legend('Ԥ��','����');
        grid on;
        error_real(i) = sumsqr(output_predict(i,:) - output_test(i,:))/BP.data_num;
        % error_real(i) = var(output_predict(i,:) - output_test(i,:));
        fprintf(['����Ԥ�⣺','ָ��',num2str(i),' - ',BP.output_name{i},':Ԥ����ʵ�ʵľ������',num2str(error_real(i)),'\n']);
    end
    clear i and genNum and popNum and x and y and tps and ps and bound;% ����޹ر���
    
    figure('name','ѵ���������Ԥ������ͼ');
    plot(error,'o-.','LineWidth',1.5,'Color',[0.3 0.75 0.93]);hold on;
    plot(error_real,'o-.','LineWidth',1.5,'Color',[1 0 0]);
    xlabel('ָ��');ylabel('���');
    set(gca,'XTickLabel',{'ָ��1','ָ��2','ָ��3','ָ��3','ָ��4','ָ��5'}); % ��x���趨Ϊ��ĸ��������
    legend('ѵ�����','Ԥ�����');grid on;
toc