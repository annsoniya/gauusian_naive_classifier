% Load the data
data=load('rate_sig_1ms.mat'); % Replace with the correct path to your file
data=data.psth_sig;
% Assuming data is in a variable 'spikeRates' of size [numCells x numTimeBins x numStimuli x numIterations]
% Reshape the data
numCells = 127;
numStimuli = 16;
numIterations = 5;
numTimeBins = 3600;


% Initialize the matrix for reshaped data
reshapedData = zeros(numStimuli * numIterations, numCells * numTimeBins);

for j = 1:numStimuli
    for k = 1:numIterations
        tempRow = [];
        for i = 1:numCells
            tempRow = [tempRow, reshape(data{i, j}(k, :), 1, [])];
        end
        reshapedData((j-1) * numIterations + k, :) = tempRow;
    end
end
% 80*457200 is teh matrix now 
dataStandardized = (reshapedData - mean(reshapedData)) ./ std(reshapedData);
%% thsi snippet may also work 
% Standardize the data
dataStandardized = bsxfun(@minus, reshapedData, mean(reshapedData));
dataStandardized = bsxfun(@rdivide, dataStandardized, std(reshapedData));


%Let `X` be the reshaped data, and `Y` be the stimulus labels.
%The linear model can be represented as `Y = X * B + ε`, where `B` is the coefficient matrix, and `ε` is the error term.
%% Create stimulus labels
labels = repmat(1:numStimuli, [numIterations, 1]);
labels = labels(:);

% Split data into training and testing (for simplicity, let's do a 70-30 split)
cv = cvpartition(labels, 'HoldOut', 0.3);% 30 percent data hold out for testing  and its random partition 
trainIdx = training(cv);
testIdx = test(cv);

trainData = dataStandardized(trainIdx, :);
trainLabels = labels(trainIdx);
testData = dataStandardized(testIdx, :);
testLabels = labels(testIdx);

% Train the linear model (logistic regression)
% Train the multiclass model (linear SVM)
decoder = fitcecoc(trainData, trainLabels, 'Learners', 'linear');
decoder = fitcecoc(trainData, trainLabels, 'Learner', 'logistic');
decoder = fitclinear(trainData, trainLabels, 'Learner', 'logistic');


%Step 3: Model Testing and Validation
% Predict labels for test data
predictedLabels = predict(decoder, testData);

predictedLabels = predict(decoder, testData);

% Calculate accuracy
accuracy = sum(predictedLabels == testLabels) / length(testLabels);
fprintf('Accuracy: %.2f%%\\n', accuracy * 100);







% Standardize the data
dataStandardized = (data - mean(data)) ./ std(data);


% Prepare labels for the dataset
labels = repmat(1:numStimuli, [1, numIterations]);

% Split data into training and testing sets
cv = cvpartition(labels, 'KFold', 5); % 5-fold cross-validation
trainIdx = cv.training(1); % Using the first fold for demonstration
testIdx = cv.test(1);

% Training data
trainData = dataStandardized(trainIdx, :);
trainLabels = labels(trainIdx);

% Train the linear decoder
%decoder = fitclinear(trainData, trainLabels, 'Learner', 'logistic');
decoder = fitcecoc(trainData, trainLabels, 'Learners', 'linear');


% Test data
testData = dataStandardized(testIdx, :);
testLabels = labels(testIdx);

% Predict labels for test data
predictedLabels = predict(decoder, testData);

% Calculate accuracy
accuracy = sum(predictedLabels == testLabels) / length(testLabels);
fprintf('Accuracy: %.2f%%\n', accuracy * 100);

%% visualisation of data
% Confusion matrix
confMat = confusionmat(testLabels, predictedLabels);

% Plot confusion matrix
figure; 
heatmap(confMat);
title('Confusion Matrix');
xlabel('Predicted Labels');
ylabel('True Labels');


% Weights Visualization:
% Visualize weights
weights = decoder.Beta;
reshapedWeights = reshape(weights, [numCells, numTimeBins]);

% Plot weights
figure;
% Visualize weights
weights = decoder.Beta;
reshapedWeights = reshape(weights, [numCells, numTimeBins]);

% Plot weights
figure;
imagesc(reshapedWeights);
colorbar;
title('Decoder Weights');
xlabel('Time Bin');
ylabel('Cell');
