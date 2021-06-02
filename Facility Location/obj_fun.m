function [cost_all,index] = obj_fun(pop)
% *Ŀ�꺯������
% pop       input    ��ʼ��Ⱥ
% cost_all  output   ÿ����Ⱥ��Ӧ���ܳɱ�
% index     output   ÿ����Ⱥ�ĸ����������ķ���������
    global data; % ȫ�ֻ�data���ݣ�����Ϊ�ṹ�����ʽ
    cost_c = data.cost_construct * size(pop,2); % ���ַ���
    cost_c = ones(1,size(pop,1)) * cost_c;
    cost_m = zeros(1,size(pop,1)); % �������
    cost_t = zeros(1,size(pop,1)); % �������
    % �ҳ�������͵�
    index = cell(size(pop,1),size(pop,2)); % �洢�����������ķ���������
    for i = 1 : size(pop,1)
        for j = 1 : 25
            distance(j,:) = dist(data.city_coordinate(j,:),data.city_coordinate(pop(i,:),:)'); % ������������������������ĵľ���
        end
        [~,b] = min(distance'); % �ҳ������������ľ����ĸ��������ĽϽ�
        for j = 1 : size(pop,2)
            %����������͵�ĵ�ַ
            % pop(i,j)��index{i,j}(k)
            index{i,j} = find(b == j);
            for k = 1 : length(index{i,j})
                cost_m(i) = cost_m(i) + data.cost_manage(pop(i,j)) .* data.demand(index{i,j}(k)); % ������� 
                cost_t(i) = cost_t(i) + data.demand(index{i,j}(k)) .* dist(data.city_coordinate(index{i,j}(k),:),data.city_coordinate(pop(i,j),:)') .* data.cost_trans(pop(i,j),index{i,j}(k)); % �������
            end
        end
    end
    cost_all = cost_c + cost_m + cost_t;
end