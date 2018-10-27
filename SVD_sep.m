close all;
clear all;
clc;

%----------Mixing the 2 signals-----------------
t=0:1/44100:3;
s1=sin(2*pi*(400)*t);
s2=sin(2*pi*(800)*t);
mix_matrix=randn(2,2);
x1=mix_matrix(1,1)*s1+mix_matrix(1,2)*s2;
x2=mix_matrix(2,1)*s1+mix_matrix(2,2)*s2;
audiowrite('mix1.wav',x1,44100);
audiowrite('mix2.wav',x2,44100);

%------------Extracting the mixed signals--------------
[x1, Fs1] = audioread('mix1.wav');
[x2, Fs2] = audioread('mix2.wav');

xx = [x1, x2]';
yy = sqrtm(inv(cov(xx')))*(xx-repmat(mean(xx,2),1,size(xx,2)));
[W,s,v] = svd((repmat(sum(yy.*yy,1),size(yy,1),1).*yy)*yy');

a = W*xx; %W is unmixing matrix
subplot(2,2,1); plot(x1); title('mixed audio - mic 1');
subplot(2,2,2); plot(x2); title('mixed audio - mic 2');
subplot(2,2,3); plot(a(1,:), 'g'); title('unmixed wave 1');
subplot(2,2,4); plot(a(2,:),'r'); title('unmixed wave 2');
k=1:1:256;
iota=(2*pi*k)/256;
f=(iota*Fs1)/(2*pi);
figure(2);plot(f,abs(fft(a(1,:),256)));
figure(3);plot(f,abs(fft(a(2,:),256)));

audiowrite('unmixed1.wav', a(1,:), Fs1);
audiowrite('unmixed2.wav', a(2,:), Fs1);