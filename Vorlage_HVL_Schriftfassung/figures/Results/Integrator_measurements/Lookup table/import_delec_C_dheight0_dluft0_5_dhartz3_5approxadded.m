%% Import data from text file.
% Script for importing data from the following text file:
%
%    /home/philipar/Semesterarbeit/COMSOL Simulation/d_elec_C_dluft0_5_dhartz3.5_dheight0.csv
%
% To extend the code to different selected data or a different text file,
% generate a function instead of a script.

% Auto-generated by MATLAB on 2015/12/10 13:07:33

%% Initialize variables.
filename = '/home/dleonard/OneDrive/Semesterarbeit_CurrentTransformer/Matlab files/import_delec_C_dluft0_5_dhartz3.5_dheight0.csv';
delimiter = ';';

%% Read columns of data as strings:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%s%[^\n\r]';

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


%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells

%% Allocate imported array to column variable names
Capacitance21componentF1 = cell2mat(raw(:, 1));
d_electrode = cell2mat(raw(:, 2));


%% Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me R;



%% Make graph
%approximately calculating capacity assuming a model of two equal spheres
%using the charge image method
a=8e-3;
d=(16+d_electrode)*1e-3;
d2=d/(2*a)
eps=3.5*8.85e-12;

Capprox=4*pi*eps*((8e-3)^2./((16+d_electrode)*1e-3)).*(1+a^2./(d.^2-2*a^2)+a^4./(d.^4-4*d.^2*a^2+3*a^4));
approx1=2*pi*eps*a*(1+1./(2*d2)+1./(4*d2.^2)+1./(8*d2.^3)+1./(8*d2.^4)+1./(32*d2.^5));
approx2=2*pi*eps*a*(log(2)+0.57721-0.5*log(2*d2-2))


plot(-Capacitance21componentF1, d_electrode);
hold on
plot(approx2, d_electrode)
legend('real','approx')

ylabel('Electrode distance in mm')
xlabel('Capacitance in F')



%% Calculation of Electrode distance 








