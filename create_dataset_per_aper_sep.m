% %%comparision has to be done between
% % 1) 3,6,8(sum=5) vs 13,14
% % 2) 4,5,7(sum=4) Vs 15,16
% % perstimset=[4,5,7];
% % aperstimset=[15,16];
% %%for periodicity =4
%   perstimset=[1,2,9,10];
%  aperstimset=[11,12];
% 
% % perstimset=[3,6,8];
% % aperstimset=[13,14];
% dataset for periodicity 3 without high or low fre set.. all periodic data with periodicity 3
clc;
clear pack;
clear all;
close all;

load('rate_sig_1ms.mat');
 perstimset_3=[3,4,5,6,7,8];
 perstimset_4=[1,2,9,10];
 aperstimset_4=[11,12];
 aperstimset_3=[13,14,15,16];

for u=1:length(psth_sig)
    
    for stim = 1:16
     
        if ismember(stim,perstimset_3)
            perdata_3=mean(psth_sig{u,stim});
        end
        perdata_3=[perdata_3;perdata_3];
         if ismember(stim,aperstimset_3)
            aperdata_3=mean(psth_sig{u,stim});
        end
        aperdata_3=[aperdata_3;aperdata_3];
            
        if ismember(stim,perstimset_4)
            perdata_4=mean(psth_sig{u,stim});
        end
        perdata_4=[perdata_4;perdata_4];
        if stim==11 || stim==12
            aperdata_4=mean(psth_sig{u,stim});
                end
        aperdata_4=[aperdata_4;aperdata_4];
    
    end
    
end
% call to SVM classifier
% making the data set for SVM classifier
%make the first row of perdata_3 and aperdata_3 into a single column element
%and make the first row of perdata_4 and aperdata_4 into a single column element
for u=1:size(perdata_3)
for s=1:size(perdata_3,2) 
 
     a=mean(perdata_3{u,s});
    a=[a,mean(aperdata_3{u,s})];
%     aperdata_3{u,1}=aperdata_3{u,1}(:);
%     perdata_4{u,1}=perdata_4{u,1}(:);
%     aperdata_4{u,1}=aperdata_4{u,1}(:);
% end

 [perdata_3,aperdata_3,perdata_4,aperdata_4]=svm_classifier(perdata_3,aperdata_3,perdata_4,aperdata_4);
            