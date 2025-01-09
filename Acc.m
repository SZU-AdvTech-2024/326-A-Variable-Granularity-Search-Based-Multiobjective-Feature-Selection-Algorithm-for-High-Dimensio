clc;
clear;
close all;

% Specify the data name and number of folds
dataNames = {'TOX_171.mat'};  % Add other data names if necessary
k = 5;  % Number of folds

% Loop over each data set
for dataName = dataNames
    disp(['Processing data: ', dataName{1}]);

    accTrValues = [];  % Array to store accuracy values

    % Loop over each fold (1 to k)
    for i = 1:k
        % Load the result file for this fold
        resultFile = strcat('result-', dataName{1}, '-', num2str(i), '.mat');
        
        if exist(resultFile, 'file')  % Check if the file exists
            load(resultFile, 'accTr');  % Load accuracy value from the result file
            accTrValues = [accTrValues; accTr];  % Store the accuracy value
        else
            warning(['Result file not found: ', resultFile]);
        end
    end

    % Calculate the mean accuracy
    if ~isempty(accTrValues)
        meanAccTr = mean(accTrValues);  % Compute average accuracy
        disp(['Mean accuracy for ', dataName{1}, ' is: ', num2str(meanAccTr)]);
    else
        disp(['No accuracy values found for ', dataName{1}]);
    end
end