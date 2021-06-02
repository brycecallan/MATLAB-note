function [ReIfvc,RTD] = Re_inserting(removed,rfvc,L,a,b,s,dist,demands,cap)
%% *�����Ƴ��Ĺ˿����²�����õ����µĳ����˿ͷ��䷽��
%% ����removed                         ���Ƴ��Ĺ˿ͼ���
% ����rfvc                             �Ƴ�removed�еĹ˿ͺ��final_vehicles_customer
% ����L                                ��������ʱ�䴰
% ����a                                �˿�ʱ�䴰
% ����b                                �˿�ʱ�䴰
% ����s                                ����ÿ���˿͵�ʱ��
% ����dist                             �������
% ����demands                          ������
% ����cap                              ���������
% ���ReIfvc                           �����Ƴ��Ĺ˿����²�����õ����µĳ����˿ͷ��䷽��
% ���RTD                              �·��䷽�����ܾ���
    while ~isempty(removed)
        [fv,fviv,fvip,fvC] = farthestINS(removed,rfvc,L,a,b,s,dist,demands,cap );% ��Զ��������ʽ������С����Ŀ�������������Ԫ���ҳ���
        removed(removed == fv) = [];
        [rfvc,iTD] = insert(fv,fviv,fvip,fvC,rfvc,dist); % ���ݲ���㽫Ԫ�ز�ص�ԭʼ����
    end
    [rfvc,~] = deal_vehicles_customer(rfvc);
    ReIfvc = rfvc;
    RTD = travel_distance(ReIfvc,dist);
end

