tic
% *�����֤����
    clc;clear all
    % a = qiongju(6);
    % combntns(set,subset) %�ڼ���set��ȡsubset��Ԫ�ص��������,�൱��Cmn
    % perms(vector) ��������vector����������,���
    a = perms(1:6);
    a = a + 1;
    num = size(a,1);
    pop = [ones(num,1),a,8*ones(num,1)];
    load data; % Ԥ����룬dic��ʾ���ڵ��ľ���
    global dic;
    fitness = obj(pop);
    [min_fit,index1] = min(fitness);
    fprintf(['�����֤�Ľ��Ϊ\n']);
    fprintf(['Ŀ�꺯��ֵ�� ',num2str(min_fit),'\n']);
    fprintf(['·�ߣ� ',num2str(pop(index1,:)),'\n']);
toc