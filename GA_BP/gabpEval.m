function [sol,fitval] = gabpEval(sol,options)
% *��Ӧֵ���㺯��
% �Ŵ��㷨����Ӧֵ����
% fitval-the fittness of this individual
% sol-the individual, returned to allow for Lamarckian  evolution
% options-[current generation]
global data;
global BP;
global lenchrom;
[input_train,ps,output_train,ts] = getBPinfo;
for i = 1 : lenchrom
    x(i) = sol(i);
end
[W1,B1,W2,B2,input_train,output_train,A1,A2,SE,fitval] = gadecod(x);