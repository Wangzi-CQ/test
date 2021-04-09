%% �����±�Ƶ���˲�����1
% ���潨���������źţ���������������±�Ƶ�������˲�����
clear;clc;
close all;

%% ��������
tw = 5e-6;          % ������
fs = 80e6;          % ����Ƶ��
fc = 20e6;          % ����Ƶ��

%% ������������
SampleNumber=fix(fs*tw);        %����һ���������ڵĲ�������

% ����һ�����峤�ȷ�Χ�ڵ�ʱ��������
t = (1:SampleNumber)/fs;

% ���ɼ򵥵�Ƶ���������ź�
s=cos(2*pi*fc*(t-1.23e-6)); 

figure(1);
subplot(2,1,1);
plot(t.*1e6,s); 
xlabel('ʱ��/us');title('ʱ���ź�');
subplot(2,1,2);
plot(linspace(-fs/2, fs/2, SampleNumber)/1e6, abs(fft(s)));
xlabel('Ƶ��/MHz');title('Ƶ���ź�');

%% �±�Ƶ
y_ddc_I = s .* cos(2*pi*fc*t);
y_ddc_Q = s .* sin(2*pi*fc*t);

%% �˲�
% �������ֵ�ͨ�˲���
Nf=60;
Fpass = 10e6;
Fstop = 20e6; 
Wpass = 1;    % Passband Weight
Wstop = 1;    % Stopband Weight
dens  = 20;   % Density Factor
b  = firpm(Nf, [0 Fpass Fstop fs/2]/(fs/2), [1 1 0 0], [Wpass Wstop], ...
           {dens});

% �����˲�����
fft_N = SampleNumber + Nf;
data2_filter_I = ifft(fft(y_ddc_I,fft_N).*fft(b,fft_N));
data2_filter_Q = ifft(fft(y_ddc_Q,fft_N).*fft(b,fft_N));
data2_ddc_pulse_I = data2_filter_I (1:SampleNumber);
data2_ddc_pulse_Q = data2_filter_Q (1:SampleNumber);
data_ddc = data2_ddc_pulse_I + 1j*data2_ddc_pulse_Q;

% ���ֵ�ͨ�˲���������ͼ
figure;
subplot(2,2,1);
plot(linspace(-40,40,fft_N), abs(fftshift(fft(y_ddc_I,fft_N))));
axis([-50,50,0,1000]);
xlabel('Ƶ��/MHz');title('Iͨ��Ƶ���ź�');
subplot(2,2,2);
plot(linspace(-40,40,fft_N), abs(fftshift(fft(y_ddc_Q,fft_N))));
axis([-50,50,0,1000]);
xlabel('Ƶ��/MHz');title('Qͨ��Ƶ���ź�');
subplot(2,2,3);
plot(linspace(-40,40,fft_N), abs(fftshift(fft(b,fft_N)))); 
xlabel('Ƶ��/MHz');title('�˲���Ƶ���ź�');
subplot(2,2,4);
plot(linspace(-40,40,fft_N), abs(fftshift(fft(data_ddc,fft_N))));
xlabel('Ƶ��/MHz');title('�˲����Ƶ���ź�');