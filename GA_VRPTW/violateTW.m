function [w]=violateTW(curr_vc,a,b,s,L,dist)
%% *���㵱ǰ��Υ����ʱ�䴰Լ��
%����curr_vc                  ÿ�����������Ĺ˿�
%����a,b                      �˿�ʱ�䴰����ʱ��[a[i],b[i]]
%����s                        ��ÿ���˿͵ķ���ʱ��
%����L                        �ֿ�ʱ�䴰����ʱ��
%����dist                     �������
%���w                        ��ǰ��Υ����ʱ�䴰Լ��֮��
NV=size(curr_vc,1);                         %���ó�������
w=0;
bsv=begin_s_v(curr_vc,a,s,dist);            %����ÿ��������·�����ڸ����㿪ʼ�����ʱ�䣬�����㷵�زֿ�ʱ��
for i=1:NV
    route=curr_vc{i};
    bs=bsv{i};
    l_bs=length(bsv{i});
    for j=1:l_bs-1
        if bs(j)>b(route(j))
            w=w+bs(j)-b(route(j));
        end
    end
    if bs(end)>L
        w=w+bs(end)-L;
    end
end
end

