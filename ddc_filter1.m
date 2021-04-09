%% 数字下变频和滤波仿真1
% 仿真建立连续波信号，并对其进行数字下变频和数字滤波处理
clear;clc;
close all;

%% 参数设置
tw = 5e-6;          % 脉冲宽度
fs = 80e6;          % 采样频率
fc = 20e6;          % 中心频率

%% 生成脉冲数据
SampleNumber=fix(fs*tw);        %计算一个脉冲周期的采样点数

% 生成一个脉冲长度范围内的时间坐标轴
t = (1:SampleNumber)/fs;

% 生成简单单频点连续波信号
s=cos(2*pi*fc*(t-1.23e-6)); 

figure(1);
subplot(2,1,1);
plot(t.*1e6,s); 
xlabel('时间/us');title('时域信号');
subplot(2,1,2);
plot(linspace(-fs/2, fs/2, SampleNumber)/1e6, abs(fft(s)));
xlabel('频率/MHz');title('频域信号');

%% 下变频
y_ddc_I = s .* cos(2*pi*fc*t);
y_ddc_Q = s .* sin(2*pi*fc*t);

%% 滤波
% 生成数字低通滤波器
Nf=60;
Fpass = 10e6;
Fstop = 20e6; 
Wpass = 1;    % Passband Weight
Wstop = 1;    % Stopband Weight
dens  = 20;   % Density Factor
b  = firpm(Nf, [0 Fpass Fstop fs/2]/(fs/2), [1 1 0 0], [Wpass Wstop], ...
           {dens});

% 进行滤波处理
fft_N = SampleNumber + Nf;
data2_filter_I = ifft(fft(y_ddc_I,fft_N).*fft(b,fft_N));
data2_filter_Q = ifft(fft(y_ddc_Q,fft_N).*fft(b,fft_N));
data2_ddc_pulse_I = data2_filter_I (1:SampleNumber);
data2_ddc_pulse_Q = data2_filter_Q (1:SampleNumber);
data_ddc = data2_ddc_pulse_I + 1j*data2_ddc_pulse_Q;

% 数字低通滤波处理结果作图
figure;
subplot(2,2,1);
plot(linspace(-40,40,fft_N), abs(fftshift(fft(y_ddc_I,fft_N))));
axis([-50,50,0,1000]);
xlabel('频率/MHz');title('I通道频域信号');
subplot(2,2,2);
plot(linspace(-40,40,fft_N), abs(fftshift(fft(y_ddc_Q,fft_N))));
axis([-50,50,0,1000]);
xlabel('频率/MHz');title('Q通道频域信号');
subplot(2,2,3);
plot(linspace(-40,40,fft_N), abs(fftshift(fft(b,fft_N)))); 
xlabel('频率/MHz');title('滤波器频域信号');
subplot(2,2,4);
plot(linspace(-40,40,fft_N), abs(fftshift(fft(data_ddc,fft_N))));
xlabel('频率/MHz');title('滤波结果频域信号');