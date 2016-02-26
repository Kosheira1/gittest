%% Import data from text file.
% Script for importing data from the following text file:
%
%    /home/dleonard/Documents/Semesterthesis/Matlab Codes/complex_ep.csv
%
% To extend the code to different selected data or a different text file,
% generate a function instead of a script.

% Auto-generated by MATLAB on 2015/12/01 09:11:03

%% Initialize variables.
filename = '/home/dleonard/Documents/Semesterthesis/Matlab Codes/complex_ep.csv';
delimiter = {',',';'};

%% Read columns of data as strings:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%*s%*s%s%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric strings to numbers.
% Replace non-numeric strings with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2]
    % Converts strings in the input cell array to numbers. Replaced non-numeric
    % strings with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(thousandsRegExp, ',', 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric strings to numbers.
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end


%% Split data into numeric and cell columns.
rawNumericColumns = raw(:, [1,2]);
rawCellColumns = raw(:, 3);


%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells

%% Allocate imported array to column variable names
e_hartz_phase = cell2mat(rawNumericColumns(:, 1));
e_hartz_abs = cell2mat(rawNumericColumns(:, 2));
Capacitance = rawCellColumns(:, 1);
for i=1:36
C(i)=str2double(cell2mat(Capacitance(i+1)));
end
e_hartz_phase(14:19)
e_hartz_abs(5:6:37)
%C0=0.58357 pF

figure
subplot(2,2,1)
%constant parameters: e_hartz_phase=0.0251, e_hartz_abs=2.8
plot(e_hartz_phase(5:6:37),angle(-1*C(4:6:length(C))), 'Color','r');
ylabel('Phase: Capacitance')
xlabel('Phase: Permittivity, Abs(eps)=2.8')
subplot(2,2,2)
plot(e_hartz_phase(5:6:37),abs(C(4:6:length(C))));
ylabel('Magnitude: Capacitance')
xlabel('Phase: Permittivity,Abs(eps)=2.8')
subplot(2,2,3)
plot(e_hartz_abs(14:19),angle(-1*C(13:18)));
ylabel('Phase: Capacitance')
xlabel('Magnitude: Permittivity, Phase(eps)=0.0251')
subplot(2,2,4)
plot(e_hartz_abs(14:19),abs(-1*C(13:18)), 'Color', 'r');
ylabel('Magnitude: Capacitance')
xlabel('Magnitude: Permittivity, Phase(eps)=0.0251')

%% Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me rawNumericColumns rawCellColumns R;