function [Q,std, grad, c,rase]=key_analysefusion(imf,immul,imy)
%���׼ƫ��ݶȣ����ϵ��������Ť���ȣ�ƫ��ָ��
%����Ϊ�ںϺ��ͼ�񣬶ನ��ͼ��
%��ÿ�����ν��д���:RGB
%imf=imread(f);�ںϺ��ͼ��f:fusion
%impan=imread(pan);
%immul=imread(mul);
%imy��ԭ�ο�ͼ�����������ϵ��
df=double(imf);
dmul=double(immul);
dy=double(imy);
men=mean2(df);

%���׼ƫ���׼��Խ��Ҷȼ��ֲ�Խ��ɢ��Ŀ��Ч��Խ��
std=std2(df(:));
[mf,nf]=size(dy);
%���ں�Ӱ���ƽ���ݶȣ�Խ��Խ����
q=0;
for i=1:1:mf-1
    for j=1:1:nf-1
        q=q+(sqrt(((df(i,j)-df(i+1,j))^2+(df(i,j)-df(i,j+1))^2)/2));
    end
end
grad=q/((mf-1)*(nf-1));

%�����ϵ������ӳ�ں�Ӱ��ͬԭ�����Ӱ���������Ƴ̶ȣ������ױ�������
%imresize()���ص�ͼ��B�ĳ�����ͼ��A�ĳ����m����������ͼ��
%bicubic����˫���β�ֵ�㷨
%c=corr2(rmul(:),df(:));
c=corr2(dy(:),df(:));

%--��Ť���̶ȣ�Ӱ�����Ť���̶�ֱ�ӷ�ӳ�˶����Ӱ��Ĺ���ʧ���
q1=0;
for i=1:1:mf
    for j=1:1:nf
        q1=q1+abs(df(i,j)-dmul(i,j));
    end
end
warp=q1/(mf*nf);%--��Ť���̶�(warping degree )
%--��ƫ��ָ��--��ʾ�ں�Ӱ��͵ͷֱ��ʶ����Ӱ���ƫ��̶�
q2=0;
a=mean2(dmul(:,:));
for i=1:1:mf
    for j=1:1:nf
        if(dmul(i,j)~=0)
        q2=q2+abs(df(i,j)-dmul(i,j))/dmul(i,j);
        else q2=q2+abs(df(i,j)-dmul(i,j))/a;
        end
    end
end
bias_index = q2 / (mf*nf);%--��ƫ��ָ��(bias index)
%{
%�����ϵ��,����������ȷ��
q5=0;
q6=0;
q7=0;
mean_df = mean2(df(:));
mean_dmul = mean2(dmul(:));
for i=1:1:mf
    for j=1:1:nf
        q5 = q5 + (df(i, j)-mean_df)*(dmul(i, j)-mean_dmul);
        q6 = q6 + (df(i, j)-mean_df)^2;
        q7 = q7 + (dmul(i, j)-mean_dmul)^2;
    end
end
c = q5/sqrt(q6*q7);
%}


rase=sqrt(sum(sum((imf-imy).^2)/(mf*nf)));



ss=cov(df,dy);
s3=ss(1,2);
s1=ss(1,1);
s2=ss(2,2);
m1=mean2(df);m2=mean2(dy);
Q=s3*2/(s1+s2)*2*m1*m2/(m1^2+m2^2);



