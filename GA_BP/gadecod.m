function [W1,B1,W2,B2,input_train,output_train,A1,A2,SE,fitval] = gadecod(x)
%  *BP��������Ӧ��Ȩֵ����ֵ����ͨ���Ŵ��㷨ʵ������
% x                                    input������
% W1                                   output������㵽�����Ȩֵ
% B1                                   output��������Ԫ��ֵ
% W2                                   output�����㵽�����Ȩֵ
% B2                                   output���������Ԫ��ֵ
% input_train                          output����һ��������ѵ������
% output_train                         output����һ����Ŀ�����ѵ������
% A1                                   output��
% A2                                   output��
% SE                                   output��������
% fitval                               output����Ӧ��
global data;
global BP;
global lenchrom;
[input_train,ps,output_train,ts] = getBPinfo;
% ǰinputnum*hiddenmun������ΪW1
for i = 1 : BP.hiddenmun
    for k = 1 : BP.inputnum
        W1(i, k) = x(BP.inputnum*(i-1) + k);
    end
end

% ���ŵ�hiddenmun*outputnum������(����inputnum*hiddenmun����ı���)ΪW2
for i = 1 : BP.outputnum
    for k = 1 : BP.hiddenmun
        W2(i,k) = x(BP.hiddenmun*(i-1) + k + BP.inputnum * BP.hiddenmun);
    end
end

% ���ŵ�hiddenmun������(����inputnum*hiddenmun+hiddenmun*outputnum����ı���)ΪB1
for i = 1:BP.hiddenmun
    B1(i,1) =x((BP.inputnum * BP.hiddenmun + BP.hiddenmun * BP.outputnum) + i);
end

% ���ŵ�outputnum������(����inputnum*hiddenmun+hiddenmun*outputnum+hiddenmun����ı���)ΪB2
for i = 1 : BP.outputnum
    B2(i,1) =x((BP.inputnum * BP.hiddenmun + BP.hiddenmun * BP.outputnum + BP.hiddenmun) + i);
end

B11 = [];
B22 = [];
for i = 1:BP.testnum
    B11 = [B11 B1];
    B22 = [B22 B2];
end
% ����hiddenmun��outputnum������
A1 = tansig(W1*input_train - B11);
A2 = logsig(W2*A1 - B22);
% �������ƽ����
SE = sumsqr(output_train - A2);
% fitval = SE;% �����ƽ����Ϊ��Ӧ�Ⱥ���
fitval = 1/SE;% �����ƽ���͵ĵ���Ϊ��Ӧ�Ⱥ���
