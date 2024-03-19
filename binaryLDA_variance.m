
% Assuming class1 and class2 are your data matrices (rows are observations, columns are features)

% Compute means
mean1 = mean(class1);
mean2 = mean(class2);

% Compute overall mean
meanOverall = mean([class1; class2]);

% Subtract mean from each class to center the data
class1_centered = class1 - mean1;
class2_centered = class2 - mean2;

% Compute within-class scatter matrix SW
SW = cov(class1_centered) * (size(class1, 1) - 1) + cov(class2_centered) * (size(class2, 1) - 1);

% Compute between-class scatter matrix SB
SB1 = size(class1, 1) * (mean1 - meanOverall)' * (mean1 - meanOverall);
SB2 = size(class2, 1) * (mean2 - meanOverall)' * (mean2 - meanOverall);
SB = SB1 + SB2;

% Solve the generalized eigenvalue problem for SW^-1 * SB
[V, D] = eig(SB, SW);

% Sort eigenvalues and eigenvectors
[~, order] = sort(diag(D), 'descend');
eigvals = diag(D);
sortedEigvals = eigvals(order);
V = V(:, order);

% Calculate the percentage of variance captured by the first two eigenvectors
varianceCaptured1 = sortedEigvals(1) / sum(sortedEigvals) * 100;
varianceCaptured2 = sortedEigvals(2) / sum(sortedEigvals) * 100;

fprintf('Variance captured by the first eigenvector: %.2f%%\n', varianceCaptured1);
fprintf('Variance captured by the second eigenvector: %.2f%%\n', varianceCaptured2);
% ---
%% 
% figure ;