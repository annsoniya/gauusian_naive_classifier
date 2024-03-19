% a function to write SVM classifier in matlab for the periodic and
% aperiodic data
%having periodicities 3 nd 4
%divide teh entire dataset into 50:50 ratio


% SVMModel = fitcsvm(X,Y,'KernelFunction','rbf',...
 %   'Standardize',true,'ClassNames',{'negClass','posClass'});
 % 
 function [accuracy] = svmClassifier(periodicData, aperiodicData)

    % shuffle periodic and apriodic data from teh dataset 
    periodicData = periodicData(randperm(size(periodicData,1)),:);
    
trainData = [periodicData(1:80,:); aperiodicData(1:80,:)];
trainLabels = [ones(80,1); -ones(80,1)];
testData = [periodicData(81:end,:); aperiodicData(81:end,:)];
testLabels = [ones(20,1); -ones(20,1)];

% Train the linear classifier
model = fitcsvm(trainData, trainLabels, 'KernelFunction', 'linear');

% Predict the labels of the test data
predictedLabels = predict(model, testData);

% Calculate the accuracy of the classifier
accuracy = sum(predictedLabels == testLabels) / length(testLabels);

% Display the accuracy
disp(['Accuracy: ' num2str(accuracy)]);