function [bs,back] = begin_s(route,a,s,dist)
%% *����һ��·���ϳ����Թ˿͵Ŀ�ʼ����ʱ�䣬�����㳵�����ؼ������ĵ�ʱ��
% ����route��       һ������·��
% ����a��           ���翪ʼ�����ʱ�䴰
% ����s��           ��ÿ����ķ���ʱ��
% ����dist��        �������
% ���bs��          �����Թ˿͵Ŀ�ʼ����ʱ��
% ���back��        �������ؼ������ĵ�ʱ��
    n = length(route); % ����·���Ͼ����˿͵�������
    bs = zeros(1,n);   % �����Թ˿͵Ŀ�ʼ����ʱ��
    bs(1) = max(a(route(1)),dist(1,route(1)+1));
    for i = 1:n
        if i ~= 1
            bs(i) = max(a(route(i)),bs(i-1)+s(route(i-1))+dist(route(i-1)+1,route(i)+1));
        end
    end
    back = bs(end)+s(route(end))+dist(route(end)+1,1);
end

