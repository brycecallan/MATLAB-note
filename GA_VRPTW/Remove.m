function [removed,rfvc] = Remove(cusnum,toRemove,D,dist,final_vehicles_customer)
%%  *Remove�������ȴ�ԭ�й˿ͼ��������ѡ��һ���˿ͣ�Ȼ�����������������Ƴ���Ҫ�����Ĺ˿�
% ����cusnum               �˿�����
% ����toRemove             ��Ҫ�Ƴ��˿͵�����
% ����D                    ���Ԫ��
% ����dist                 �������
% final_vehicles_customer  ÿ�����������Ĺ˿�
% removed                  ���Ƴ��Ĺ˿ͼ���
% rfvc                     �Ƴ�removed�еĹ˿ͺ��final_vehicles_customer

%%  Remove
inplan = 1:cusnum;            % ���й˿͵ļ���
visit = ceil(rand*cusnum);    % ��������й˿������ѡ��һ���˿�
inplan(inplan == visit) = [];   % �����Ƴ��Ĺ˿ʹ�ԭ�й˿ͼ������Ƴ�
removed = [visit];            % ���Ƴ��Ĺ˿ͼ���
while length(removed) < toRemove
    nr = length(removed);             % ��ǰ���Ƴ��Ĺ˿�����
    vr = ceil(rand*nr);               % �ӱ��Ƴ��Ĺ˿ͼ��������ѡ��һ���˿�
    nip = length(inplan);             % ԭ���˿ͼ����й˿͵�����
    R = zeros(1,nip);                 % �洢removed(vr)��inplan��ÿ��Ԫ�ص�����Ե�����
    for i = 1:nip
        R(i) = Relatedness( removed(vr),inplan(i),dist,final_vehicles_customer);   % ����removed(vr)��inplan��ÿ��Ԫ�ص������
    end
    [SRV,SRI] = sort(R,'descend');
    lst = inplan(SRI);                % ��inplan�е����鰴removed(vr)���������ԴӸߵ�������
    vc = lst(ceil(rand^D*nip));       % ��lst������ѡ��һ���ͻ�
    removed = [removed vc];           % ���Ƴ��Ĺ˿ͼ�������ӱ��Ƴ��Ĺ˿�
    inplan(inplan == vc) = [];          % �����Ƴ��Ĺ˿ʹ�ԭ�й˿ͼ������Ƴ�
end
rfvc = final_vehicles_customer;               % �Ƴ�removed�еĹ˿ͺ��final_vehicles_customer
nre = length(removed);                        % ���ձ��Ƴ��˿͵�������
NV = size(final_vehicles_customer,1);         % ���ó�����
for i = 1:NV
    route = final_vehicles_customer{i};
    for j = 1:nre
        findri = find(route == removed(j),1,'first');
        if ~isempty(findri)
            route(route == removed(j)) = [];
        end
    end
    rfvc{i} = route;
end
[rfvc,~] = deal_vehicles_customer(rfvc);
end