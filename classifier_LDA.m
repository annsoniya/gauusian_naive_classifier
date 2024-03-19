% Assuming ldaClass1 and ldaClass2 are already defined one dimensioanal 
X = [ldaClass1; ldaClass2]; % Combine features into a single dataset
Y = [ones(size(ldaClass1, 1), 1); 2*ones(size(ldaClass2, 1), 1)]; % Labels: 1 for class 1, 2 for class 2

% Optionally, shuffle the data
randOrder = randperm(size(X, 1));
X = X(randOrder, :);
Y = Y(randOrder, :);


%% 
% Assuming ldaClass1 and ldaClass2 are already defined
X = [ldaClass1; ldaClass2]; % Combine features into a single dataset
Y = [ones(size(ldaClass1, 1), 1); 2*ones(size(ldaClass2, 1), 1)]; % Labels: 1 for class 1, 2 for class 2

% Optionally, shuffle the data
randOrder = randperm(size(X, 1));
X = X(randOrder, :);
Y = Y(randOrder, :);


%% 
% Train the SVM Classifier
svmModel = fitcsvm(X, Y, 'KernelFunction', 'linear', 'Standardize', true);

% Split the data into training and testing sets (optional)
cv = cvpartition(size(X, 1), 'HoldOut', 0.2);
idx = cv.test;

% Separate to training and test sets
XTrain = X(~idx, :);
YTrain = Y(~idx, :);
XTest = X(idx, :);
YTest = Y(idx, :);

% Train the SVM Classifier on the training set
svmModel = fitcsvm(XTrain, YTrain, 'KernelFunction', 'linear', 'Standardize', true);

% Predict using the SVM model on the test set
YPredSVM = predict(svmModel, XTest);

% Calculate the accuracy
accuracySVM = sum(YPredSVM == YTest) / length(YTest);
fprintf('SVM Accuracy: %.2f%%\n', accuracySVM * 100);


%%
% Convert labels for logistic regression (0 and 1)
YLogistic = Y - 1;

% Split the data into training and testing sets for logistic regression
YTrainLogistic = YLogistic(~idx, :);
YTestLogistic = YLogistic(idx, :);

% Train a logistic regression model
logisticModel = fitglm(XTrain, YTrainLogistic, 'Distribution', 'binomial', 'Link', 'logit');

% Predict on the test set
YPredLogisticProb = predict(logisticModel, XTest); % Gives probabilities
YPredLogistic = double(YPredLogisticProb >= 0.5); % Convert probabilities to class labels

% Calculate the accuracy
accuracyLogistic = sum(YPredLogistic == YTestLogistic) / length(YTestLogistic);
fprintf('Logistic Regression Accuracy: %.2f%%\n', accuracyLogistic * 100);

