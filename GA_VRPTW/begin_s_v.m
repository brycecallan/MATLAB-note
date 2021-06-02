function bsv = begin_s_v(vehicles_customer,a,s,dist)
%% *����ÿ��������·�����ڸ����㿪ʼ�����ʱ�䣬�����㷵�ؼ�������ʱ��
%����vehicles_customer��       ÿ�����������Ĺ˿�
%����a��                       ���翪ʼ�����ʱ�䴰
%����s��                       ��ÿ����ķ���ʱ��
%����dist��                    �������
%���bsv��                     ÿ��������·�����ڸ����㿪ʼ�����ʱ�䣬�����㷵�ؼ�������ʱ��
    m = size(vehicles_customer,1);
    bsv = cell(m,1);
    for ii = 1:m
        route = vehicles_customer{ii};
        %% *����һ��·���ϳ����Թ˿͵Ŀ�ʼ����ʱ�䣬�����㳵�����ؼ������ĵ�ʱ��
        % ����route��       һ������·��
        % ����a��           ���翪ʼ�����ʱ�䴰
        % ����s��           ��ÿ����ķ���ʱ��
        % ����dist��        �������
        % ���bs��          �����Թ˿͵Ŀ�ʼ����ʱ��
        % ���back��        �������ؼ������ĵ�ʱ��
            n1 = length(route); % ����·���Ͼ����˿͵�������
            bs = zeros(1,n1);   % �����Թ˿͵Ŀ�ʼ����ʱ��
            bs(1) = max(a(route(1)),dist(1,route(1)+1));
            for i = 1 : n1
                if i ~= 1
                    bs(i) = max(a(route(i)),bs(i-1)+s(route(i-1))+dist(route(i-1)+1,route(i)+1));
                end
            end
            back = bs(end) + s(route(end)) + dist(route(end)+1,1);

        bsv{ii} = [bs,back];
    end
end
