% Combine the features for class 1 and class 2
featuresClass1 = [ldaClass1, ldaClass1_dim2];
featuresClass2 = [ldaClass2, ldaClass2_dim2];

% Create labels
labelsClass1 = ones(size(featuresClass1, 1), 1); % Class 1
labelsClass2 = 2 * ones(size(featuresClass2, 1), 1); % Class 2

% Combine into a single dataset
X = [featuresClass1; featuresClass2];
Y = [labelsClass1; labelsClass2];

% Shuffle the dataset
randOrder = randperm(length(Y));
X = X(randOrder, :);
Y = Y(randOrder);



% Split the data into training and testing sets
cv = cvpartition(size(X, 1), 'HoldOut', 0.3);
idxTrain = cv.training;
idxTest = cv.test;

% Train the SVM Classifier
svmModel = fitcsvm(X(idxTrain,:), Y(idxTrain), 'KernelFunction', 'linear', 'Standardize', true);

% Predict using the SVM model
YPredSVM = predict(svmModel, X(idxTest,:));

% Calculate the accuracy
accuracySVM = sum(YPredSVM == Y(idxTest)) / length(Y(idxTest));
fprintf('SVM Accuracy: %.2f%%\n', accuracySVM * 100);



% Train a logistic regression model
% Logistic regression model in MATLAB expects binary outcomes, so adjust classes to 0 and 1
YLogistic = Y - 1;

logisticModel = fitglm(X(idxTrain,:), YLogistic(idxTrain), 'Distribution', 'binomial', 'Link', 'logit');

% Predict on the test set
YPredLogisticProb = predict(logisticModel, X(idxTest,:)); % Gives probabilities
YPredLogistic = double(YPredLogisticProb >= 0.5); % Convert probabilities to class labels

% Calculate the accuracy
accuracyLogistic = sum(YPredLogistic == YLogistic(idxTest)) / length(YLogistic(idxTest));
fprintf('Logistic Regression Accuracy: %.2f%%\n', accuracyLogistic * 100);
