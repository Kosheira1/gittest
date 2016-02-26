
function MeasureCapacitanceGainCallback(cObjHandle,~)
% MeasureCapacitanceGainCallback(cObjHandle,~)
% When "Capacitance" is selected from the popup menu the unknown
% capacitance value will be determined via an impedance measurement and
% given gain of the I/U converter. The capacitance value is displayed and
% also automatically used to calculate C0 on the simulation tab by using
% the values of permittivity on the same tab (if "sample" signal path is 
% selected). It is directly transferred to the Cref field if "reference"
% signal path is selected.
% (Note: the C0 and Cref values are subsequently used in the signal processing).
% When "Gain" is is selected from the popup menu the current nominal gain
% value of the I/U converter is determined from an impedance measurement on
% a reference air capacitor (known C0). The gain value is displayed, and if the "save"
% checkbox is selected it is inserted into the calibration matrix.
i=0;
% access guidata
data=guidata(cObjHandle);

if isfield(data,'objFG')
    % FG output off
    FGoutput(cObjHandle,'off');
else % nothing to measure in simulation mode
    return
end

% Capacitance or Gain measurement?
AnalysisModeList=get(data.hPopupCapacitanceGain,'String');
AnalysisModeValue=get(data.hPopupCapacitanceGain,'Value');
AnalysisMode=AnalysisModeList{AnalysisModeValue}; % string

% sampling rate [Hz]
% fs=ReturnSamplingRate(cObjHandle); => read it from panel after adjustment
% within the function SnapshotCallback (which calls ReturnSamplingRate).

% save waveform
WaveformValue=get(data.hPopupWaveform,'Value');
ArbWaveformValue=get(data.hPopupArbWaveform,'Value');
Par1=get(data.hTextWaveformPar1,'Value');
Par2=get(data.hTextWaveformPar2,'Value');

% save FEMTO configuration
GainValue=get(data.hPopupAmplificationFEMTO,'Value');
InputConfig=get(data.hPopupInputConfigFEMTO,'Value');
InputCoupling=get(data.hPopupInputCouplingFEMTO,'Value');

% voltage waveform must be sinusoidal
if get(data.hPopupWaveform,'Value')~=1
    % set sin
    set(data.hPopupWaveform,'Value',1);
    WaveformChoicePopup(cObjHandle,0); % adjust appearance of popups
end

% FG output on
FGoutput(cObjHandle,'on')

% set gain
SetAmplifierGain(cObjHandle,0);

% data generation
[voltages,~]=SnapshotCallback(cObjHandle,0);
% indices: (Np,signal,Nphase)

% FG output off
FGoutput(cObjHandle,'off')

% sampling rate [Hz]
fs=str2num(strtrim(get(data.hTextSamplingRate,'String')));

% sampling interval [s]
deltat=1/fs;

% FFT of input and output voltage [V]
[c_Vin_FFTpos,faxis]=FFTposM(deltat,squeeze(voltages(:,1,:)));
[c_Vout_FFTpos,~]=FFTposM(deltat,squeeze(voltages(:,2,:)));
% note: FFTs have Nphase columns

% sine frequency index (all other frequencies are discarded)
[~,ind]=max(abs(c_Vin_FFTpos(:,1))); % from first run (Nphase=1)

% discard other frequencies (1xNphase vector remains)
c_Vin_FFTpos=c_Vin_FFTpos(ind,:);
c_Vout_FFTpos=c_Vout_FFTpos(ind,:);

if strcmp(AnalysisMode,'Capacitance')
    % here we use the I/U gain value to calculate the current, the
    % impedance Z and finally the capacitance via C=(j*2*pi*f*Z)^-1
    % (note: only the amplitude of the generally complex capacitance is
    % retained here).
    
    % I/U gain [V/A]
    if isfield(data,'objFG') % take gain from data acquisition tab
        Gain=str2num(strtrim(get(data.hTextEditCalibratedGain,'String')));
    else % take gain from simulation tab
        Gain=str2num(strtrim(get(data.hTextEditSimulationGain,'String')));
    end
    
    % FFT current amplitude [A]
    %c_I_FFTpos=c_Vout_FFTpos/Gain;
    
    % complex capacitance [F]
    C=(1j*2*pi*faxis(ind)*Gain*c_Vin_FFTpos./c_Vout_FFTpos).^(-1);
    
    %% Statistical Analysis of System Variance, Semesterthesis 2016 Aron and Leo
    %In this part, the file systemvariance.mat was created, which includes
    %the average Capacitance, it's standard deviation, mean and 95%
    %confidence interval for the mean value.
    
    %{
    Nphase=str2num(strtrim(get(data.hTextPhaseAverages,'String')));
    
    test_C=abs(C); %[F]
    
    test_Cmag=1e12*mean(test_C); %[pF]
    test_CmagSD=1e12*std(abs(test_C)); %[pF]
    
    test_interval=tinv(1-(1-0.95)/2,Nphase);
    error_margin=test_interval*test_CmagSD/(sqrt(Nphase));
    
    save('systemvariance2.mat','test_C','test_Cmag','test_CmagSD','error_margin');
    disp(test_Cmag);
    disp('+/-');
    disp(error_margin);
    
    %}
    
    %% Statistical Analysis of setup-Variance
    
    %{
    load('samplevariance2.mat');
    
    test_C=abs(C); %[F]
    test_Cmag=1e12*mean(test_C); %[pF]
    
   
    
    sample_Cmag(i)=test_Cmag
    
    i=i+1
    
  
    save('samplevariance2.mat','sample_Cmag','i');
    
    %}
    
    %%
    % average of magnitude of complex capacitance [pF] over runs (1:Nphase)
    Cmag=1e12*mean(abs(C)); % [pF]
    Cmag_SD=1e12*std(abs(C)); % [pF]
    
    % insert C in text field
    set(data.hTextEditMeasuredCapacitance,'String',sprintf('%.5f',Cmag));
    
    % was the sample or air capacitor measured?
    if get(data.hRBSample,'Value') % sample measured
        
        % extract dielectric paramters (modulus of permittivity) and use them
        % to calculate the corresponding vacuum capacitance C0 sample (this
        % value is then inserted into the corresponding field on the simulation
        % tab).
        
        % eps' [-]
        eps_r=str2num(strtrim(get(data.hTextEditDielectricP3,'String')));
        
        % tan delta [-]
        tandelta=str2num(strtrim(get(data.hTextEditDielectricP2,'String')));
        
        % eps''
        eps_c=eps_r*tandelta;
        
        % |eps|
        eps_magn=sqrt(eps_r^2+eps_c^2);
        
        % corresponding vacuum capacitance [pF]
        C0=Cmag/eps_magn;
        C0_SD=Cmag_SD/eps_magn;
        
        % set (measured) C0 on simulation tab [pF]
        set(data.hTextEditDielectricP1,'String',sprintf('%.5f',C0));
        
        % insert into C0 gap and calculate associated gap separation
        % (with confidence interval)
        set(data.hTextEditC0Gap,'String',sprintf('%.3f',C0));
        
        % read number of phase averages
        Nphase=str2num(strtrim(get(data.hTextPhaseAverages,'String')));
        
        % confidence level for confidence intervals
        alpha=str2num(strtrim(get(data.hTextEditCI,'String')));
        
        % Student's coefficient for confidence level alpha
        cStudent=tinv(1-(1-alpha)/2,Nphase-1);
        
        % insert "error" [pF]
        set(data.hTextEditC0GapError,'String',sprintf('%.3f',cStudent*C0_SD/sqrt(Nphase)));
        
        % calculate gap separation
        ConvertC0d(cObjHandle,0,1);
        
    else % air capacitor measured
        % here epsr=1 and epsc=0 (air values) so the measured capacitance
        % is directly equal to C0 air and inserted into the corresponding 
        % field on the simulation tab).
        set(data.hTextEditCair,'String',sprintf('%.5f',Cmag));
    end
    
elseif strcmp(AnalysisMode,'Gain')
    % here we use the value of the capacitance (magnitude) C entered the
    % corresponding field on the data acquisition tab by the user (using
    % e.g. a reference air capacitor) to calculate the U/I gain value.
    
    
    % read enterd capacitance value [pF]
    C=str2num(strtrim(get(data.hTextEditMeasuredCapacitance,'String')));
    C=C*1e-12; % [F]
    
    % check if user entered value
    if isempty(C)&&get(data.hCheckboxSaveData,'Value') % simply save the entered gain value in the gain matrix
        Gain=str2num(strtrim(get(data.hTextEditCalibratedGain,'String')));
        % nominal gain index
        GainIndex=get(data.hPopupAmplificationFEMTO,'Value');
        % coupling index
        CouplingIndex=get(data.hPopupInputCouplingFEMTO,'Value');
        % configuration index
        ConfigIndex=get(data.hPopupInputConfigFEMTO,'Value');
        % gain matrix
        GainMatrix=data.GainMatrix;
        % save measured gain
        GainMatrix(CouplingIndex,ConfigIndex,GainIndex)=Gain;
        data.GainMatrix=GainMatrix;
        % resave calibration file
        save(data.CalibrationFullFileName,'GainMatrix');

    else
        % measured gain [-]
        MeasuredGain=((1j*2*pi*faxis(ind)*C*c_Vin_FFTpos./c_Vout_FFTpos).^(-1));

        % average over runs
        MeasuredGain_SD=std(abs(MeasuredGain));
        MeasuredGain=mean(MeasuredGain);
        
        % gain magnitude
        MeasuredGain=abs(MeasuredGain);
        
        % display measured gain
        set(data.hTextEditCalibratedGain,'String',sprintf('%.5e',MeasuredGain));
        
        % save gain value in GainMatrix (if user selected checkbox)
        if get(data.hCheckboxSaveData,'Value')
            % nominal gain index
            GainIndex=get(data.hPopupAmplificationFEMTO,'Value');
            % coupling index
            CouplingIndex=get(data.hPopupInputCouplingFEMTO,'Value');
            % configuration index
            ConfigIndex=get(data.hPopupInputConfigFEMTO,'Value');
            % gain matrix
            GainMatrix=data.GainMatrix;
            % save measured gain
            GainMatrix(CouplingIndex,ConfigIndex,GainIndex)=MeasuredGain;
            data.GainMatrix=GainMatrix;
            % resave calibration file
            save(data.CalibrationFullFileName,'GainMatrix');
        end
  
    end
    
end

CalculateCFromC0(cObjHandle,0); % insert |C| on simulation tab

% reset original waveform parameters
set(data.hPopupWaveform,'Value',WaveformValue);
WaveformChoicePopup(cObjHandle,0); % adjust appearance of popups
set(data.hPopupArbWaveform,'Value',ArbWaveformValue);
WaveformChoicePopup(cObjHandle,0); % adjust appearance of popups
set(data.hTextWaveformPar1,'Value',Par1);
set(data.hTextWaveformPar2,'Value',Par2);

% reset FEMTO parameters
set(data.hPopupAmplificationFEMTO,'Value',GainValue);
SetCalibratedGainCallback(cObjHandle,0); % set calibrated gain
set(data.hPopupInputConfigFEMTO,'Value',InputConfig);
set(data.hPopupInputCouplingFEMTO,'Value',InputCoupling);
ApplySettingsFEMTOCallback(cObjHandle,0);

% FG output on
FGoutput(cObjHandle,'on')

% write guidata
guidata(cObjHandle,data);

end