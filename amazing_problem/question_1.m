tic
clc;clear all;close all;
% ���⣺0-1000���Ƿ����һ��ֱ�������κ�һ�����������Σ����߾�����ͬ���ܳ�����������ܳ��������Ϊ����
% �𰸣����ڣ�(135,352,377), (366,366,132)
% ֱ�������ε�3���ߵ�a��b��c�����������ε�3����Ϊd��d��e
for a = 1:1000
    for b = 1:a
        c = (a^2 + b^2)^0.5;
        % �ж�c�Ƿ�Ϊ����
        if mod(c,1) == 0
            for d = 1 : floor(a+b+c/2)
                e = a+b+c-d-d; % �������ߵ�����
                h = (d^2 - e^2/4)^0.5;
                % �ж�h�Ƿ�Ϊ����,��ֹ���Ϊ����
                % ��֤e�Ƿ�������������ε�Լ������
                if h > 0 & mod(h,1) == 0 & 0 < e < 2*d
                    % �������Ƿ����
                    if a*b == e*h
                        fprintf(['a = ',num2str(a),'\n']);
                        fprintf(['b = ',num2str(b),'\n']);
                        fprintf(['c = ',num2str(c),'\n']);
                        fprintf(['d = ',num2str(d),'\n']);
                        fprintf(['e = ',num2str(e),'\n']);
                        fprintf(['\n']);
                        break;
                    end
                end
            end
        end
    end
end
toc