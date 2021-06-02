tic
% 清空变量
    clc;close all;clear all;warning('off');
    nntwarn off;% 临时关闭神经网络工具箱的警告功能
% 数据导入
    load data
%% 遗传算法优化参数
   % BP参数设置
    BP.inputnum = 3;% 输入训练数据的index
    BP.hiddenmun = 5;% 隐含层节点数
    BP.outputnum = 6;% 输出层节点数
    BP.output_name = {'Gel','Q','H','L','M','S'};
    BP.data_num = 9; % 输入+输出个数
    BP.testnum = 72;% 输入测试数据的组数
    BP.num = size(data,1);
    lenchrom = BP.inputnum * BP.hiddenmun + BP.hiddenmun + BP.hiddenmun * BP.outputnum + BP.outputnum;% 遗传算法编码长度
    global data;
    global BP;
    global lenchrom;
   % 初始化BP网络
    [input_train,ps,output_train,ts] = getBPinfo;
   % GA参数
    bound = ones(lenchrom,1)*[-2,2]; % 上下限
    popNum = 50; % 种群数目
    genNum = 100; % 进化次数
    initPop = initializega(popNum,bound,'gabpEval');% 采用工具箱initializega进行种群初始化
   % 遗传计算，在goat工具箱中引用gabpEval函数（此为max）
    [x,~,~,trace] = ga(bound,'gabpEval',[],initPop,[1e-6 1 0],'maxGenTerm',genNum,'normGeomSelect',[0.09],['arithXover'],[2],'nonUnifMutation',[2 genNum 3]);
    %                  上下界 适应度函数    初始种群                  中止循环条件  
    % x为求得的最优解、trace为每一代最好的适应度和平均适应度   
% 遗传优化结果对比
    figure('name','每一代的平均误差平方和比较')
    plot(trace(:,1),1./trace(:,2)/popNum,'-','lineWidth',2,'Color',[1 0 0]);hold on;
    plot(trace(:,1),1./trace(:,3)/popNum,'-.','lineWidth',2,'Color',[0 0.447058826684952 0.74117648601532]);
    xlabel ('迭代次数');ylabel ('误差平方和');
    title('每一代的平均误差平方和比较');
    legend('Best Sum-Squared Error' , 'Avg Sum-Squared Error');
    grid on;
% BP开始预测
   % 生成BP网络
    net = newff(minmax(input_train),[BP.hiddenmun,BP.outputnum],{'tansig' 'logsig'},'trainlm');
    %{
    % TODO:newff中训练函数
        (1) traingd：基本梯度下降法，收敛速度比较慢。
        (2) traingda：自适应学习率的梯度下降法
        (3) traingdm：带有动量项的梯度下降法, 通常要比traingd 速度快。
        (4) traingdx: 带有动量项的自适应学习算法, 速度要比traingdm 快。
        (5) trainrp: 弹性BP 算法, 具有收敛速度快和占用内存小的优点。
        (6) traincgf: Fletcher-Reeves 共轭梯度法,为共轭梯度法中存储量要求最小的算法。
        (7) traincgp: Polak-Ribiers共轭梯度算法, 存储量比traincgf稍大,但对某些问题收敛更快。
        (8) traincgb: Powell-Beale共轭梯度算法,存储量比traincgp稍大,但一般收敛更快，以上三种共轭梯度法,都需要进行线性搜索。
        (9) trainscg: 归一化共轭梯度法,是唯一一种不需要线性搜索的共轭梯度法。
        (10) trainbfg: BFGS- 拟牛顿法, 其需要的存储空间比共轭梯度法要大,每次迭代的时间也要多,但通常在其收敛时所需的迭代次数要比共轭梯度法少,比较适合小型网络。
        (11) traino ss: 一步分割法,为共轭梯度法和拟牛顿法的一种折衷方法。
        (12) trainlm: Levenberg-Marquardt算法,对中等规模的网络来说, 是速度最快的一种训练算法, 其缺点是占用内存较大。对于大型网络, 可以通过置参数mem-reduc 为1, 2, 3,?,将Jacobian 矩阵分为几个子矩阵。但这样也有弊端, 系统开销将与计算Jacobian的各子矩阵有很大关系。
        (13) trainbr: 贝叶斯规则法,对Levenberg-Marquardt算法进行修改, 以使网络的泛化能力更好。同时降低了确定最优网络结构的难度。
    %}
   % 提取遗传算法的结果为BP网络所对应的权值、阈值
    [W1,B1,W2,B2,input_train,output_train,~,~,~,~] = gadecod(x);
    net.iw {1,1} = W1;
    net.lw {2,1} = W2;
    net.b{1} = B1;
    net.b{2} = B2;
    % 设置网络参数
    net.trainParam.epochs = 5000; % 训练次数
    net.trainParam.lr = 0.01; % 学习速率
    net.trainParam.goal = 0.00001; % 训练目标最小误差
    % net.trainParam.min_grad = 1e-6; % 最小性能梯度
    % net.trainParam.min_fail = 5; % 最大确认失败次数
    % net.trainParam.show = 20; % 显示频率，这里设置为没训练20次显示一次
    % net.trainParam.mc = 0.95;% 附加动量因子
    % 开始训练神经网络
    net = train(net,input_train,output_train);

% 预测
    predict_21 = sim(net,input_train);% predict_21为预测的结果-归一化后的结果
    output_predict = mapminmax('reverse',predict_21,ts);% 已经反归一化后
    output_train = mapminmax('reverse',output_train,ts);
    % 绘图
    figure('name','训练集的预测与实际的均方误差')
    for i = 1 : BP.outputnum
        subplot(3,2,i);
        y = 1:BP.testnum;
        plot(y,output_predict(i,:),'rp','lineWidth',2);hold on;
        plot(y,output_train(i,:),'b*','lineWidth',2);
        xlabel('实验批次');ylabel(['指标',num2str(i),' - ',BP.output_name{i}]);
        legend('预测','期望');
        title(['训练集的','指标',num2str(i),' - ',BP.output_name{i}]);
        % xlim([0,BP.testnum+1]);
        grid on;
        error(i) = sumsqr(output_train(i,:) - output_predict(i,:))/BP.data_num;
        fprintf(['训练集的','指标',num2str(i),' - ',BP.output_name{i},':预测与实际的均方误差',num2str(error(i)),'\n']);
    end

% 用剩余几组数据进行预测对比
    fprintf(['\n']);% 创造分割线
    input_test = data(BP.testnum+1:size(data,1),1:BP.inputnum);
    output_test = data(BP.testnum+1:size(data,1),BP.inputnum+1:BP.data_num);
    input_test = input_test';
    output_test = output_test';
    %归一化数据
    [input_test,tps] = mapminmax(input_test,0,1);
    [output_test,tts] = mapminmax(output_test,0,1);
    predict_21 = sim(net,input_test);
    output_predict = mapminmax('reverse',predict_21,tts);
    output_test = mapminmax('reverse',output_test,tts);
    % 绘图
    figure('name','最终预测与实际的均方误差')
    for i = 1 : BP.outputnum
        subplot(3,2,i);
        y = 1:size(data,1)-BP.testnum;
        plot(y,output_predict(i,:),'rp','lineWidth',2);hold on;
        plot(y,output_test(i,:),'b*','lineWidth',2);
        xlabel('实验批次');ylabel(['指标',num2str(i),' - ',BP.output_name{i}]);
        title(['最终预测：','指标',num2str(i),' - ',BP.output_name{i}]);
        legend('预测','期望');
        grid on;
        error_real(i) = sumsqr(output_predict(i,:) - output_test(i,:))/BP.data_num;
        % error_real(i) = var(output_predict(i,:) - output_test(i,:));
        fprintf(['最终预测：','指标',num2str(i),' - ',BP.output_name{i},':预测与实际的均方误差',num2str(error_real(i)),'\n']);
    end
    clear i and genNum and popNum and x and y and tps and ps and bound;% 清除无关变量
    
    figure('name','训练的误差与预测的误差图');
    plot(error,'o-.','LineWidth',1.5,'Color',[0.3 0.75 0.93]);hold on;
    plot(error_real,'o-.','LineWidth',1.5,'Color',[1 0 0]);
    xlabel('指标');ylabel('误差');
    set(gca,'XTickLabel',{'指标1','指标2','指标3','指标3','指标4','指标5'}); % 将x轴设定为字母或者文字
    legend('训练误差','预测误差');grid on;
toc