clear; 
close all; 
clc;

%% RYTHMISEIS
audioFolder = fullfile(pwd, 'audio');
resultsFolder = fullfile(pwd, 'results');

files = { ...
    'male_a.m4a'; 'male_e.m4a'; 'male_i.m4a'; 'male_o.m4a'; 'male_u.m4a'; ...
    'female_a.m4a'; 'female_e.m4a'; 'female_i.m4a'; 'female_o.m4a'; 'female_u.m4a'};
sex = [repmat({'Male'},5,1); repmat({'Female'},5,1)];
vowel = repmat({'a';'e';'i';'o';'u'},2,1);

maleF0Range = [70 220];
femaleF0Range = [130 350];
useHOSA = true;

if ~exist(resultsFolder,'dir'), mkdir(resultsFolder); end
if ~exist(audioFolder,'dir'), error('Den vrethike o fakelos audio.'); end

for k = 1:numel(files)
    if ~exist(fullfile(audioFolder,files{k}),'file')
        error('Leipei to arxeio: %s',files{k});
    end
end

if useHOSA && exist('bispecd','file') ~= 2
    warning('Den vrethike to HOSA bispecd. I ypoloipi analysi tha ginei kanonika.');
end

%% ANALYSI
R = repmat(struct(),numel(files),1);

for k = 1:numel(files)
    [x,fs] = audioread(fullfile(audioFolder,files{k}));
    if size(x,2)>1, x = mean(x,2); end
    x = x(:)-mean(x(:));
    x = x/(max(abs(x))+eps);

    if strcmp(sex{k},'Male')
        f0Range = maleF0Range;
    else
        f0Range = femaleF0Range;
    end

    % Dynato voiced frame 3 periodon.
    [frameRaw,frameStart] = voicedFrame(x,fs,f0Range);
    N = numel(frameRaw);
    frame = frameRaw.*hamming(N);
    nfft = 2^nextpow2(max(2048,4*N));
    framePadded = [frame; zeros(nfft-N,1)];

    % Real kai complex cepstrum.
    cReal = rceps(framePadded);
    [cComplex,phaseDelay] = cceps(framePadded);
    f0 = cepstralPitch(cReal,fs,f0Range);
    T0 = 1/f0;

    % Low/high-quefrency liftering.
    lifterSec = min(max(0.45*T0,0.0015),0.0035);
    L = round(lifterSec*fs);
    lowLifter = zeros(nfft,1);
    lowLifter(1:L+1) = 1;
    lowLifter(end-L+1:end) = 1;

    % Minimum-phase vocal-tract filter kai deconvolved excitation.
    cFilter = cComplex.*lowLifter;
    cMinimum = zeros(nfft,1);
    cMinimum(1:L+1) = cFilter(1:L+1);
    h = real(icceps(cMinimum,0));
    h = h(1:min(round(0.03*fs),numel(h)));
    h = h/(sqrt(sum(h.^2))+eps);

    excitation = real(icceps(cComplex.*(1-lowLifter),phaseDelay));
    excitation = excitation(1:N);
    excitation = excitation/(max(abs(excitation))+eps);

    % To cepstrum thelei short frame, alla oi formants theloun perissotera
    % dedomena. Gia to akoustiko LPC xrisimopoioume stathero tmima 150 ms.
    frameCenter = frameStart+floor((N-1)/2);
    lpcN = min(round(0.150*fs),numel(x));
    lpcFrame = takeFrame(x,frameCenter,lpcN).*hamming(lpcN);
    lpcOrder = min([40, max(12,round(fs/1000)+2), lpcN-2]);
    [a,lpcError] = lpc(lpcFrame,lpcOrder);
    a = real(a).*(0.996.^(0:lpcOrder));

    [Hlpc,fLpc] = freqz(1,a,4096,fs);
    formants = findFormants(fLpc,20*log10(abs(Hlpc)+eps));

    % Akoustiki synthesi me time-varying LPC: diatirei tis metavaseis
    % /eI/, /aI/, /oU/ ton agglikon onomaton A, I kai O.
    outputN = min(numel(x),round(5*fs));
    source = glottalSource(f0,fs,outputN,k);
    synth = finishAudio(timeVaryingLpc(x(1:outputN),source,fs,lpcOrder),fs);
    synthCepstral = finishAudio(filter(h,1,source),fs);

    [~,name] = fileparts(files{k});
    audiowrite(fullfile(resultsFolder,['synth_' name '.wav']),synth,fs);
    audiowrite(fullfile(resultsFolder,['synth_cepstral_' name '.wav']), ...
        synthCepstral,fs);

    % Aples posotikes metriseis.
    qMax = min(round(0.020*fs)+1,floor(nfft/2));
    region = cReal(2:qMax);
    [peaks,~] = findpeaks(region);
    peakLimit = median(region)+0.10*(max(region)-min(region));
    cepstralPeakCount = sum(peaks>peakLimit);
    flatness = spectralFlatness(synth,fs);

    hosaPeak = NaN;
    if useHOSA && exist('bispecd','file')==2
        try
            B = bispecd(frameRaw,64,1,min(64,N),0);
            hosaPeak = max(abs(B(:)));
        catch ME
            warning('HOSA error sto %s: %s',files{k},ME.message);
        end
    end

    % Ena sxhma ana ixografisi.
    f = (0:nfft/2)'*fs/nfft;
    X = fft(framePadded);
    H = fft(h,nfft);
    q = (0:qMax-1)'/fs;
    sourceFrame = source(1:N);
    modelFrame = filter(h,1,sourceFrame);

    fig = figure('Visible','off','Color','w','Position',[50 50 1200 800]);
    subplot(3,2,1);
    plot((0:numel(x)-1)/fs,x); hold on;
    plot(([frameStart frameStart+N-1]-1)/fs,[0 0],'or');
    grid on; xlabel('Time (s)'); title('Original signal and selected frame');

    subplot(3,2,2);
    plot((0:N-1)*1000/fs,frameRaw);
    grid on; xlabel('Time (ms)');
    title(sprintf('Frame, F0 = %.1f Hz',f0));

    subplot(3,2,3);
    plot(q*1000,cReal(1:qMax)); hold on;
    plot(1000/f0,interp1(q*1000,cReal(1:qMax),1000/f0),'or');
    grid on; xlabel('Quefrency (ms)'); title('Real cepstrum');

    subplot(3,2,4);
    plot(f,20*log10(abs(X(1:numel(f)))+eps),'Color',[.65 .65 .65]); hold on;
    plot(f,20*log10(abs(H(1:numel(f)))+eps),'r','LineWidth',1.2);
    xlim([0 min(5000,fs/2)]); grid on;
    xlabel('Frequency (Hz)'); legend('Original','Cepstral envelope');

    subplot(3,2,5);
    plot((0:N-1)*1000/fs,excitation);
    grid on; xlabel('Time (ms)'); title('Deconvolved excitation');

    subplot(3,2,6);
    plot((0:N-1)*1000/fs,frame/(max(abs(frame))+eps)); hold on;
    plot((0:N-1)*1000/fs,modelFrame/(max(abs(modelFrame))+eps));
    grid on; xlabel('Time (ms)'); legend('Original','Synthesized');
    title('Cepstral synthesis');

    sgtitle(sprintf('%s voice, vowel /%s/',sex{k},vowel{k}));
    saveas(fig,fullfile(resultsFolder,sprintf('%02d_%s_analysis.png',k,name)));
    close(fig);

    R(k).File = files{k};
    R(k).Sex = sex{k};
    R(k).Vowel = vowel{k};
    R(k).Fs_Hz = fs;
    R(k).F0_Hz = f0;
    R(k).Frame_ms = 1000*N/fs;
    R(k).Lifter_ms = 1000*lifterSec;
    R(k).CepstralPeaks = cepstralPeakCount;
    R(k).F1_Hz = formants(1);
    R(k).F2_Hz = formants(2);
    R(k).F3_Hz = formants(3);
    R(k).LPC_Error = lpcError;
    R(k).SynthFlatness = flatness;
    R(k).HOSA_Peak = hosaPeak;

    fprintf('%2d/10  %-14s  F0=%6.1f Hz  F1=%4.0f  F2=%4.0f\n', ...
        k,files{k},f0,formants(1),formants(2));
end

%% SYGKRISEIS
T = struct2table(R);
writetable(T,fullfile(resultsFolder,'quantitative_results.csv'));

isMale = strcmp(T.Sex,'Male');
meanF0 = [mean(T.F0_Hz(isMale)),mean(T.F0_Hz(~isMale))];
vowels = {'a','e','i','o','u'};
F1 = zeros(5,1); F2 = zeros(5,1);
for k=1:5
    idx = strcmp(T.Vowel,vowels{k});
    F1(k) = mean(T.F1_Hz(idx),'omitnan');
    F2(k) = mean(T.F2_Hz(idx),'omitnan');
end

fig = figure('Visible','off','Color','w','Position',[100 100 900 400]);
subplot(1,2,1); bar(meanF0); grid on;
set(gca,'XTickLabel',{'Male','Female'}); ylabel('Mean F0 (Hz)');
subplot(1,2,2); bar([F1 F2]); grid on;
set(gca,'XTickLabel',vowels); ylabel('Frequency (Hz)');
legend('F1','F2'); xlabel('Vowel');
saveas(fig,fullfile(resultsFolder,'00_summary_comparison.png'));
close(fig);

fprintf('\nOloklirothike. Apotelesmata: %s\n',resultsFolder);

%% TOPIKES SYNARTISEIS
function [frame,startIndex] = voicedFrame(x,fs,f0Range)
    roughN = min(numel(x),round(0.050*fs));
    energy = movmean(x.^2,max(3,round(0.020*fs)));
    [~,center] = max(energy);
    rough = takeFrame(x,center,roughN);
    nfft = 2^nextpow2(max(2048,4*roughN));
    c = rceps([rough.*hamming(roughN); zeros(nfft-roughN,1)]);
    f0 = cepstralPitch(c,fs,f0Range);

    N = round(3*fs/f0);
    N = min(max(N,round(0.012*fs)),round(0.050*fs));
    N = min(N,numel(x));
    startIndex = min(max(1,center-floor(N/2)),numel(x)-N+1);
    frame = x(startIndex:startIndex+N-1);
    frame = frame-mean(frame);
end

function y = takeFrame(x,center,N)
    first = min(max(1,center-floor(N/2)),numel(x)-N+1);
    y = x(first:first+N-1);
end

function f0 = cepstralPitch(c,fs,f0Range)
    first = round(fs/f0Range(2))+1;
    last = min(round(fs/f0Range(1))+1,floor(numel(c)/2));
    region = c(first:last);
    [peaks,locations] = findpeaks(region);
    if isempty(peaks)
        [~,location] = max(region);
    else
        [~,best] = max(peaks);
        location = locations(best);
    end
    period = first+location-2;
    f0 = fs/period;
end

function formants = findFormants(f,envelopeDb)
    idx = find(f>=150 & f<=min(4000,max(f)));
    df = f(2)-f(1);
    [~,locations] = findpeaks(envelopeDb(idx), ...
        'MinPeakDistance',max(1,round(200/df)), ...
        'MinPeakProminence',2);
    values = f(idx(locations));
    formants = NaN(1,3);
    formants(1:min(3,numel(values))) = values(1:min(3,numel(values)));
end

function source = glottalSource(f0,fs,N,seed)
    P = max(2,round(fs/f0));
    t = (0:P-1)'/P;
    flow = zeros(P,1);
    opening = t<0.45;
    closing = t>=0.45 & t<0.75;
    flow(opening) = 0.5*(1-cos(pi*t(opening)/0.45));
    flow(closing) = cos(0.5*pi*(t(closing)-0.45)/0.30);
    cycle = [flow(1);diff(flow)];
    cycle = cycle/(sqrt(sum(cycle.^2))+eps);

    oldState = rng; rng(seed,'twister');
    source = zeros(N,1); position = 1;
    while position<=N
        last = min(N,position+P-1);
        source(position:last) = source(position:last)+ ...
            (1+0.02*randn)*cycle(1:last-position+1);
        position = position+round(P*(1+0.003*randn));
    end
    source = source+0.002*sqrt(mean(source.^2))*randn(N,1);
    rng(oldState);
end

function y = timeVaryingLpc(x,source,fs,order)
    % LPC ana 60 ms me 50% overlap. Etsi i spectral envelope akolouthei
    % tin arxiki profora anti na epanalamvanei ena mono stathero fonien.
    N = min(numel(x),numel(source));
    frameN = min(round(0.060*fs),N);
    hop = max(1,floor(frameN/2));
    starts = unique([1:hop:N-frameN+1, N-frameN+1]);
    window = hamming(frameN);
    referenceRms = sqrt(max(movmean(x(1:N).^2,frameN)));

    y = zeros(N,1);
    weight = zeros(N,1);
    for first = starts
        idx = first:first+frameN-1;
        originalFrame = x(idx);
        frameRms = sqrt(mean(originalFrame.^2));
        if frameRms < 0.01*referenceRms
            continue;
        end

        currentOrder = min(order,frameN-2);
        a = lpc(originalFrame.*window,currentOrder);
        a = real(a).*(0.996.^(0:currentOrder));
        frameOut = filter(1,a,source(idx));
        frameOut = frameOut*frameRms/(sqrt(mean(frameOut.^2))+eps);

        y(idx) = y(idx)+frameOut.*window;
        weight(idx) = weight(idx)+window;
    end
    y = y./(weight+eps);
end

function y = finishAudio(y,fs)
    y = y(:)-mean(y(:));
    fadeN = min(round(0.03*fs),floor(numel(y)/2));
    if fadeN>1
        fade = 0.5-0.5*cos(pi*(0:fadeN-1)'/(fadeN-1));
        y(1:fadeN) = y(1:fadeN).*fade;
        y(end-fadeN+1:end) = y(end-fadeN+1:end).*flipud(fade);
    end
    y = 0.95*y/(max(abs(y))+eps);
end

function value = spectralFlatness(x,fs)
    N = min(numel(x),round(0.5*fs));
    x = x(1:N).*hamming(N);
    P = abs(fft(x,2^nextpow2(N))).^2;
    f = (0:numel(P)-1)'*fs/numel(P);
    P = P(f>=60 & f<=min(5000,0.48*fs))+eps;
    value = exp(mean(log(P)))/mean(P);
end
