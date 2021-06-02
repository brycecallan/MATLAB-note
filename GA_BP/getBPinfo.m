function [input_train,ps,output_train,ts] = getBPinfo
% *通过研究对象初始化BP网络
% input_train               影响因素参量
% output_target             目标输出
% inputnum                  输入层数
% hiddenmun                 隐层数
% outputnum                 输出层数
% data_num                  数据组数（影响因素-目标输出）
% lenchrom                  染色体长度
global data;
global BP;
global lenchrom;
preData = data;
% 用BP.testnum组数据训练网络
input_train  = preData(1:BP.testnum,1:BP.inputnum);
output_train = preData(1:BP.testnum,BP.inputnum+1:BP.data_num);
input_train = input_train';
output_train = output_train';

% 数据归一化
[input_train,ps] = mapminmax(input_train,0,1);
[output_train,ts] = mapminmax(output_train,0,1);
