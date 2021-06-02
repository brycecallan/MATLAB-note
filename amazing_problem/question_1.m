tic
clc;clear all;close all;
% 问题：0-1000内是否存在一个直角三角形和一个等腰三角形，二者具有相同的周长和面积、且周长和面积均为整数
% 答案：存在，(135,352,377), (366,366,132)
% 直角三角形的3条边的a、b、c；等腰三角形的3条边为d、d、e
for a = 1:1000
    for b = 1:a
        c = (a^2 + b^2)^0.5;
        % 判断c是否为整数
        if mod(c,1) == 0
            for d = 1 : floor(a+b+c/2)
                e = a+b+c-d-d; % 第三条边的限制
                h = (d^2 - e^2/4)^0.5;
                % 判断h是否为整数,防止其变为复数
                % 验证e是否满足等腰三角形的约束限制
                if h > 0 & mod(h,1) == 0 & 0 < e < 2*d
                    % 面积相等是否存在
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