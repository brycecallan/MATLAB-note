function [input_train,ps,output_train,ts] = getBPinfo
% *ͨ���о������ʼ��BP����
% input_train               Ӱ�����ز���
% output_target             Ŀ�����
% inputnum                  �������
% hiddenmun                 ������
% outputnum                 �������
% data_num                  ����������Ӱ������-Ŀ�������
% lenchrom                  Ⱦɫ�峤��
global data;
global BP;
global lenchrom;
preData = data;
% ��BP.testnum������ѵ������
input_train  = preData(1:BP.testnum,1:BP.inputnum);
output_train = preData(1:BP.testnum,BP.inputnum+1:BP.data_num);
input_train = input_train';
output_train = output_train';

% ���ݹ�һ��
[input_train,ps] = mapminmax(input_train,0,1);
[output_train,ts] = mapminmax(output_train,0,1);
