Load the data sets
periodic_data = load('path/to/periodic/data');
aperiodic_data = load('path/to/aperiodic/data');

% Split the data sets into training and testing sets
train_periodic = periodic_data(1:100,:);
test_periodic = periodic_data(101:end,:);
train_aperiodic = aperiodic_data(1:100,:);
test_aperiodic = aperiodic_data(101:end,:);

% Calculate the mean and standard deviation of the training sets
mean_periodic = mean(train_periodic);
std_periodic = std(train_periodic);
mean_aperiodic = mean(train_aperiodic);
std_aperiodic = std(train_aperiodic);

% Define the Gaussian Naive Classifier function
function [class] = gaussian_naive_classifier(data, mean_periodic, std_periodic, mean_aperiodic, std_aperiodic)
    % Calculate the probability of the data belonging to the periodic class
    p_periodic = prod(normpdf(data, mean_periodic, std_periodic));
    
    % Calculate the probability of the data belonging to the aperiodic class
    p_aperiodic = prod(normpdf(data, mean_aperiodic, std_aperiodic));
    
    % Classify the data based on the class with the highest probability
    if p_periodic > p_aperiodic
        class = 'periodic';
    else
        class = 'aperiodic';
    end
end

% Test the classifier on the testing sets
correct_periodic = 0;
correct_aperiodic = 0;
for i = 1:size(test_periodic,1)
    if strcmp(gaussian_naive_classifier(test_periodic(i,:), mean_periodic, std_periodic, mean_aperiodic, std_aperiodic), 'periodic')
        correct_periodic = correct_periodic + 1;
    end
end
for i = 1:size(test_aperiodic,1)
    if strcmp(gaussian_naive_classifier(test_aperiodic(i,:), mean_periodic, std_periodic, mean_aperiodic, std_aperiodic), 'aperiodic')
        correct_aperiodic = correct_aperiodic + 1;
    end
end

% Calculate the accuracy of the classifier
accuracy = (correct_periodic + correct_aperiodic) / (size(test_periodic,1) + size(test_aperiodic,1));
disp(['Accuracy: ' num2str(accuracy)]);