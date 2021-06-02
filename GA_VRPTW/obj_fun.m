    function ObjV = obj_fun(Chrom,cusnum,cap,demands,ET,LT,L,service_t,dist,Iij)
    %% *������Ⱥ��Ŀ�꺯��ֵ
    % ���룺Chrom               ��Ⱥ
    % ���룺cusnum              �˿���Ŀ
    % ���룺cap                 ���������
    % ���룺demands             ������
    % ���룺ET                  �˿Ϳɽ��ܵ�ʱ�䴰��ʼʱ��
    % ���룺IT                  �˿Ϳɽ��ܵ�ʱ�䴰����ʱ��
    % ���룺L                   ��������ʱ�䴰����ʱ��
    % ���룺service_t           �ͻ���ķ���ʱ��
    % ���룺dist                ��������������ǹ�ϵ�����þ����ʾ����c[i][j] = dist[i][j]
    % ���룺Iij                �����ɹ˿�iʻ��˿�jʱ��λ���������ѵķ���
    % �����ObjV                ÿ�������Ŀ�꺯��ֵ
    % Chrom = [22	8	4	1	21	23	24	2	6	25	7	5	3	26	10	9	11	17	13	16	14	12	15	27	19	18	20	28	29	30	31	32];
        c_k = 500;                  % ÿ�����Ĺ̶�����
        C0 = 0.125;                 % ���ͳ�����λ����ȼ��������
        eta = 2.32;                 % ��λȼ�Ͳ�����̼�ŷ��� ��
        c_p = 2.1;                  % ̼˰�۸� Ԫ/kg
        alpha = 50;                 % ���������ĵ�λ�ͷ��ɱ� ��
        w_1 = 100;                  % ���絽��ĵ�λ�ͷ��ɱ� w_1
        w_2 = 200;                  % �ӳٵ���ĵ�λ�ͷ��ɱ� w_2
        v = 60/60;                  % ��ʻ�ٶ�

        NIND = size(Chrom,1);       % ��Ⱥ��Ŀ
        ObjV = zeros(NIND,1);       % ����ÿ�����庯��ֵ
        for ii = 1 : NIND
            [VC,NV,TD,violate_num,violate_cus,route_V] = decode(Chrom(ii,:),cusnum,cap,demands,ET,LT,L,service_t,dist);
            car_num = length(VC);   % ʹ��С������
            c_1 = c_k * car_num;    % �̶��ɱ�
            c_2 = 0;                % ��ʻ�ɱ�
            c_31 = 0;               % ̼�ŷ����ɱ�-MEETģ��
            c_32 = 0;               % ̼�ŷ����ɱ�-��ͳ
            c_4 = 0;                % ���������ĳͷ��ɱ�
            c_5 = 0;                % ��ʱ�䴰�ɱ�
            for i = 1 : car_num
                route = cell2mat(VC(i)); % ����·��
                dis_all = 0;             % ����·���ܾ���
                goods_a = sum(demands(route));

                % c_2-��������ʻ�ɱ�����
                for j = 1 : length(route) + 1
                    if j == 1 | j == length(route) + 1
                        if j == length(route) + 1
                            c_2 = c_2 + dist(1,route(j-1)+1) * Iij(route(j-1)+1,1); %  ���һ���ͻ�->��������
                            dis_all = dis_all + dist(1,route(j-1)+1);
                        else
                            c_2 = c_2 + dist(1,route(j)+1) * Iij(route(j)+1,1); % ��������->��һ���ͻ�
                            dis_all = dis_all + dist(1,route(j)+1);
                        end
                    else
                        c_2 = c_2 + dist(route(j-1)+1,route(j)+1) * Iij(route(j-1)+1,route(j)+1);
                        dis_all = dis_all + dist(route(j-1)+1,route(j)+1);
                    end
                end

                % c_31-̼�ŷ����ɱ�-MEETģ���뵽��ʱ��
                time = zeros(length(route),3); % 1 ����ʱ�䣬2 �뿪ʱ�䣬3 ·��ʱ��
                e = 0.000375*60*v^3 + 8750/(60*v) + 110;
                % G = exp(0.005*(0.0059*(60*v)^2 - 0.0775*60*v + 11.936)); % ƽԭ�����¶�0-0.5�� 
                G = exp(0.3153*(0.0059*(60*v)^2 - 0.0775*60*v + 11.936)); % ��������¶�15-25�� 
                for j = 1 : length(route)
                    r = (goods_a - sum(demands(route(1:j))))/cap;
                    lambda = 0.27*r + 0.0614*r - 0.0011*r - 0.00235*r*v-1.33*r/v + 1;
                    co_2 = G * e * lambda/1000; % ̼�ŷ���
                    if j == 1
                        c_31 = c_31 + c_p * co_2 * dist(1,route(j)+1);
                    else
                        c_31 = c_31 + c_p * co_2 * dist(route(j-1)+1,route(j)+1);
                    end

                    % ���㵽��ʱ��
                    if j == 1
                        time(j,1) = ET(route(j)); % �������������͵��ʱ��
                    elseif j == length(route)
                        time(j,1) = time(j-1,2) + round(dist(route(j)+1 ,1)/v); % ������������ʱ��
                    else
                        time(j,1) = time(j-1,2) + round(dist(route(j)+1 ,route(j+1)+1)/v);
                    end
                    time(j,2) = time(j,1) + service_t(route(j));
                end
                time(:,3) = [time(1,1);time(2:end,1)-time(1:end-1,2)];

                % c_32-̼�ŷ����ɱ�-��ͳ
                c_32  = c_32 + c_p * C0 * dis_all * eta;

                % c_4-���������ĳͷ��ɱ�
                if goods_a > cap
                    c_4 = c_4 + alpha * (goods_a-cap);
                end

                % c_5-��ʱ�䴰�ɱ�����
                for j = 1 : length(route)
                    price_h = [w_1,0,w_2];
                    temp_t = zeros(3,1); % ����ʱ����ڵ�ʱ��
                    if time(j,1) < ET(route(j))
                        temp_t(1) = ET(route(j)) - time(j,1); % [0,ETi]
                    elseif time(j,1) > LT(route(j))
                        temp_t(3) = time(j,1) - LT(route(j)); % [0,ETi]
                    end
                    c_5 = c_5 + price_h * temp_t;
                end
            end
            ObjV(ii) = c_1 + c_2 + c_31 + c_4 + c_5;
        end
    end

