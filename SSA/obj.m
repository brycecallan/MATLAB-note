function obj_fun = obj(pop)
% *Ŀ�꺯�����㺯��
% pop       input    ��Ⱥ
% obj_fun   output   Ŀ�꺯��ֵ
    global net;
    global outputps;
    [pop_init,~] = mapminmax(pop',0,1); % ��һ��
    obj_temp_1 = sim(net,pop_init);     % ��ʼ���
    obj_fun = mapminmax('reverse',obj_temp_1,outputps)'; % ����һ��
end