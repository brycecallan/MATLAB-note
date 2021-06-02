function [a,b]=OX(a,b)
% *交叉操作 
%输入：
%a和b为两个待交叉的个体
%输出：
%a和b为交叉后得到的两个个体
L=length(a);
while 1
    r1=randsrc(1,1,[1:L]);
    r2=randsrc(1,1,[1:L]);
    if r1~=r2
        s=min([r1,r2]);
        e=max([r1,r2]);
        a0=[b(s:e),a];
        b0=[a(s:e),b];
        for i=1:length(a0)
            aindex=find(a0==a0(i));
            bindex=find(b0==b0(i));
            if length(aindex)>1
                a0(aindex(2))=[];
            end
            if length(bindex)>1
                b0(bindex(2))=[];
            end
            if i==length(a)
                break
            end
        end
        a=a0;
        b=b0;
        break
    end
end