function binaryLDA(class1, class2)
    
    
    % write a function to accept two inputs class1 and class2 and return the
% 
%data set 
% Calculate the mean vectors for each class
%class1 is of size neurons * trials 
%class2 is of size neurons * trials
%teh mean value will make teh data into a single rate for every neuron.
class1 = class1.*1000;
class2 = class2.*1000;
mean1 = mean(class1,2); 
mean2 = mean(class2,2);
%% for cumulative ones 
%The within-class scatter matrix is the sum of the covariance matrices of the individual classes.
%The covariance matrix is calculated by multiplying the transpose of the data matrix with the data matrix itself.
% Calculate the within-class scatter matrices
% where each class's scatter matrix is the sum of the outer product of the difference between each sample and the class mean, across all samples in that class.
S1 = zeros(size(class1,1), size(class1,1));
for i = 1:size(class1, 2)
    d = (class1(:,i) - mean1);
    S1 = S1 + d*d' ;
end
S2 = zeros(size(class1,1), size(class1,1));
for i = 1:size(class2, 2)
    d = (class2(:,i) - mean2);
    S2 = S2 + d*d';
end
SW = S1 + S2;

mu_diff = mean1 - mean2;
SB = mu_diff * mu_diff';
SW_reg = SW + 1e-4 * eye(size(SW, 1));
S_mat = inv(SW_reg)*SB; 

[V,D] = eig(S_mat);
[eigenvalues, ind] = sort(diag(D), 'descend');
eigenvectors = V(:, ind);

% Project the data onto the LDA component

W = eigenvectors(:,1); 
%capture variance
 % Calculate the "importance" of the first component
 importance = eigenvalues(1) / sum(eigenvalues);
importance2= eigenvalues(2) / sum(eigenvalues);
 fprintf('First LDA Component Importance: %.4f\n', importance);
    fprintf('Second LDA Component Importance: %.4f\n', importance2);


% Selecting the first eigenvector( max of eigen values ) 
% 127 * 1 is teh eigen vector
ldaClass1= class1' * W;% (127*30 trials ) * eigen vector a
ldaClass2 = class2' * W;
% now al teh data is projected into teh LDA component
%% %%%% % Visualize the original data and the projected data

% ---- GPT code for variance ---


% second dir
% Second eigen direction corresponding to the second highest eigenvalue
secondEigenVector = eigenvectors(:, 2);

ldaClass1_dim2 = class1' * secondEigenVector;
ldaClass2_dim2 = class2' * secondEigenVector;



bar([ldaClass1; ldaClass2])

% -----
% scatter(ldaClass1, zeros(size(ldaClass1, 1), 1), 'r'); hold on;
% scatter(ldaClass2, zeros(size(ldaClass2, 1), 1), 'b');
% title('Data Projected onto LDA Component');
% xlabel('LDA Component');
% ylabel('Zero Axis');
% legend('Class 1', 'Class 2');
end 





