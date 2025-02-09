%Name: TEMITAYO ADEROUNMU
%ID: 1001568524
%COURSE: CSE 3313-001
%Due Date: 12/12/2022
%% Description
%In this project, I will be designing a filter to remove unwanted noise
%from an audio file. I will accomplish this with a Butterworth lowpass
%filter, which will be designed using MATLAB.


%% Start up Clean up
close all
clear
clc
%% Audio Frequency Analysis using DFT
%Using the DFT technique to determine wanted and unwanterd frequency ranges
%from the audio sample.

%Read the audio file
[y,Fs] = audioread("noisyconversation.wav");

Na = length(y);
pow = abs(fft(y));
f = (Fs/Na)*(0:Na-1);

%Calculating frequency axis for DFT
faxis = linspace(-(Fs/2),(Fs/2),Na);

figure(1);

%Plotting DFT magnitude by calcultated frequency
%subplot(2,2,1);

plot(faxis,fftshift(pow));
xlabel('Frequency(Hz)')
ylabel('DFT Magnitude')
title('DFT Magnitude vs Frequency')
%xlim([-1.2 1.2])

%Plotting normalized log plot of DFT by frequency
figure(2);

gain = 20.*log10(pow/max(pow));
%subplot(2,2,2);

plot(faxis,fftshift(gain));
xlabel('Frequency(Hz)')
ylabel('DFT Magnitude')
title('Log Plot of DFT')
%xlim([-1.2 1.2])

%Plotting Power spectral Density estimate
figure(3);

%subplot(2,2,3:4);

plot(f,pow)
grid on
xlabel('Frequency(Hz)')
ylabel('Power Frequency(dB/Hz)')
title('Power Spectral Density Estimate')
axis([600 1500 0 100])

[val,ind]=findpeaks(pow, f,'SortStr','descend','Npeaks',4);
hold on
plot(ind,val,'o','MarkerFaceColor','r','MarkerSize',15)

%%Audio Frequency analysis using spectrogram
%[S,F,T] = spectrogram(y(:,1),256,256/4,[],Fs);
%pcolor(T,F,log10(abs(S))),shading, flat,colorbar
figure; spectrogram(y,1000,500,1000,Fs);
%% Filter Design
%Using MATLAB filter design commands to design digital filter that will
%reduce noise from the audio sample.

wp = 1700;
ws = 2300;
Dp = 1;
Ds = 40;
Atten = 0.5;

%Find N
vlu = (10.^(Ds/10)-1)/(10.^(Dp/10)-1);
N = (log10(vlu))/(2*log10(ws/wp));
Nnxt = round(double(N))+1;
FC1 = wp/(10.^(Dp/10)-1)^(1/(2*Nnxt));
FC2 = ws/(10.^(Ds/10)-1)^(1/(2*Nnxt));

%Find H(s)
Hs = 20*log10(sqrt(1./(1+(faxis/FC1).^(2*Nnxt))));

%Bandpass Filter Log Plog
figure(4);

%subplot(2,2,1:2);
plot(faxis,Hs);
xlabel('Frequency(Hz)')
ylabel('DFT Magnitude [dB]')
title('Log Gain Plot vs DFT')
%xlim([-1.2 1.2])

%% Filter Implementation
%Using MATLAB filtering commands to apply designed filter to audio sample.
On = FC1/(Fs/2);
[b,a] = butter(Nnxt,On);
filteredAudio = filter(b,a,y);
nwPow = fft(filteredAudio);
newPow = abs(fft(filteredAudio));

%Plotting filtered signal
figure(5);

%subplot(2,2,3:4);
plot(faxis,fftshift(newPow));
xlabel('Frequency(Hz)')
ylabel('DFT Magnitude')
title('NEW DFT Magnitude vs Frequency')
%xlim([-1.2 1.2])

%audio playback
sound(filteredAudio,Fs);
%p = audioplayer(filteredAudio,Fs);
%play(p);

%plot filtered audio with time
figure(6);
plot(filteredAudio)
xlabel('Time(s)')
ylabel('Amplitude')
title('Filtered Audio vs Time')
%xlim([-1.2 1.2])

%Plot of frequency response of designed filter
figure(7);
freqz(b,a)
title('Frequency Response Magnitude for Designed Filter')
%% Creating and loading filtered audio to new file
%load handel.mat

%filename = 'filteredConversation.wav';
%audiowrite(filename,filteredAudio,Fs);
%clear filteredAudio Fs
