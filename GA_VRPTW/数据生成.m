tic
   %% ��ձ���
    clc;clear all;close all;
    % �˿�����
    coord = round(1+49*rand(25,2)); % �ͻ������꣬��Ϊ��������Ϊ��λ��[0.50]
    center = [25,25];
    figure('name','����')
    plot(coord(:,1),coord(:,2),'bo');hold on;
    plot(center(:,1),center(:,2),'ro');
    xlabel('X');ylabel('Y');
    grid on;

    % �˿�����
    demands = round(200+799*rand(25,1))*10; % �ͻ�����������λ��[0.2,1]��
    disp(demands);
    disp(sum(demands)/25);

    % �˿͵ķ���ʱ��
    service_t = round(20+19*rand(25,1)); % ÿ���ͻ��ķ���ʱ�䣬[20,40]min
    disp(service_t);                     % ÿ���ͻ��ķ���ʱ��
    disp(sum(service_t)/25);             % ÿ���˿͵�ƽ������ʱ��

    % time Windows
    ET = 730 + 15*round((16*rand(25,1)+1));  % ��ʱ�䴰
    for i = 1 : size(ET,1)
        num_low1 = mod(ET(i),100);
        num_high1 = floor(ET(i)/100);
        if num_low1 >= 60
            num_high1 = num_high1 + 1;
            num_low1 = mod(num_low1,60);
        end
        ET(i) = num_high1*100 + num_low1;

        temp = 30 + 15*round(3*rand+1);
        LT(i) = ET(i) + temp;                 % ��ʱ�䴰
        num_low2 = mod(LT(i),100);
        num_high2 = floor(LT(i)/100);
        if num_low2 >= 60
            num_high2 = num_high2 + 1;
            num_low2 = mod(num_low2,60);
        end
        LT(i) = num_high2*100 + num_low2;
        if LT(i) - ET(i) < 30

        end
    end
toc