function [VC,NV,TD,violate_num,violate_cus,route_V] = decode(chrom,cusnum,cap,demands,et,lt,L,service_t,dist)
    %%  *���뺯��
    % ���룺chrom               ����
    % ���룺cusnum              �˿���Ŀ
    % ���룺cap                 ���������
    % ���룺demands             ������
    % ���룺a                   �˿�ʱ�䴰��ʼʱ��[a[i],b[i]]
    % ���룺b                   �˿�ʱ�䴰����ʱ��[a[i],b[i]]
    % ���룺L                   ��������ʱ�䴰����ʱ��
    % ���룺s                   �ͻ���ķ���ʱ��
    % ���룺dist                ��������������ǹ�ϵ�����þ����ʾ����c[i][j] = dist[i][j]
    % �����VC                  ÿ�����������Ĺ˿ͣ���һ��cell����
    % �����NV                  ����ʹ����Ŀ
    % �����TD                  ������ʻ�ܾ���
    % �����violate_num         Υ��Լ��·����Ŀ
    % �����violate_cus         Υ��Լ���˿���Ŀ
    % �����route_V             Υ��Լ����·��
    violate_num = 0;                                      % Υ��Լ��·����Ŀ
    violate_cus = 0;                                      % Υ��Լ���˿���Ŀ
    VC = cell(cusnum,1);                                  % ÿ�����������Ĺ˿�
    count = 1;                                            % ��������������ʾ��ǰ����ʹ����Ŀ
    location0 = find(chrom>cusnum);                       % �ҳ��������������ĵ�λ��
    for i = 1:length(location0)
        if i == 1                                         % ��1���������ĵ�λ��
            route = chrom(1:location0(i));                % ��ȡ������������֮���·��
            route(route == chrom(location0(i))) = [];       % ɾ��·���������������
        else
            route = chrom(location0(i-1):location0(i));   % ��ȡ������������֮���·��
            route(route == chrom(location0(i-1))) = [];     % ɾ��·���������������
            route(route == chrom(location0(i))) = [];       % ɾ��·���������������
        end
        VC{count} = route;                                % �������ͷ���
        count = count + 1;                                  % ����ʹ����Ŀ
    end
    route = chrom(location0(end):end);                    % ���һ��·��       
    route(route == chrom(location0(end))) = [];             % ɾ��·���������������
    VC{count} = route;                                    % �������ͷ���
    [VC,NV] = deal_vehicles_customer(VC);                 % ��VC�пյ������Ƴ�
    route_V = {};
    for j = 1 : NV
        route = cell(1,1);                                % ������ʱԪ���������route���洢preroute
        route{1} = VC{j};
        flag = Judge(route,cap,demands,et,lt,L,service_t,dist);     % �жϵ�ǰ�����Ƿ�����ʱ�䴰Լ����������Լ����0��ʾΥ��Լ����1��ʾ����ȫ��Լ��
        if flag == 0
            violate_num = violate_num + 1;                  % �������·��������Լ������Υ��Լ��·����Ŀ��1
            violate_cus = violate_cus + length(route{1});   % �������·��������Լ������Υ��Լ���˿���Ŀ�Ӹ���·���˿���Ŀ
            route_V{length(route_V)+1} = VC{j};
        end
    end
    TD = travel_distance(VC,dist); % �÷���������ʻ�ܾ���
end