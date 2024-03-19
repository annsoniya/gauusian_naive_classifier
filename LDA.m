% preparation of dataset for training
% load the dataset
clear all;
clc;
close all;
data=load('dataSignificant_perrand_old.mat');
data=data.dataSignificant_perrand_old;

% seperate the dataset into per and aper 

periodic_stimset_4=[1,2,9,10];
aperiodic_stimset_4=[11,12];
periodic_stimset_3=[3,4,5,6,7,8];
aperiodic_stimset_3=[13,14,15,16];
per_set=[1,2,3,4,5,6,7,8,9,10];
aper_set=[11,12,13,14,15,16];
% plan 
%split into stimwise  and periodicity wise
%find cumulatve for 3 frames=600ms
%apply ttest and find significant cases amon=g periodic an d aperiodic
% class1 = [];
% for r = 1:127
%    indiv_col = [];
%    for p = periodic_stimset_3
%         indiv_col = [indiv_col mean(data{r,p},2)' ];
%    end
%    class1 = [class1; indiv_col];
% end
% 
% class2 = [];
% for r = 1:127
%    indiv_col = [];
%    for p = aperiodic_stimset_3
%         indiv_col = [indiv_col mean(data{r,p},2)' ];
%    end
%    class2 = [class2; indiv_col];
% end
% 
% return % TEMP
%split into stimwise  and periodicity wise
data_per_3=data(:,periodic_stimset_3);
data_per_4=data(:,periodic_stimset_4);
data_aper_3=data(:,aperiodic_stimset_3);
data_aper_4=data(:,aperiodic_stimset_4);
data_per=data(:,per_set);
data_aper=data(:,aper_set);
xx=[];
per_3=[];
aper_3=[];
per_4=[];
aper_4=[];
per=[];
aper=[];


for i=size(data_per_3,1)
    xx=[];
    xx=cat(1,data_per_3{i,:});
    per_3(i,:)=mean(xx(:,501:4100),2)';

    xx=[];
    xx=cat(1,data_aper_3{i,:});
    aper_3(i,:)=mean(xx(:,501:4100),2)';

    xx=[];
    xx=cat(1,data_per_4{i,:});
    per_4(i,:)=mean(xx(:,501:4100),2)';

    xx=[];
    xx=cat(1,data_aper_4{i,:});
    aper_4(i,:)=mean(xx(:,501:4100),2)';

    xx=[];
    xx=cat(1,data_per{i,:});
    per(i,:)=mean(xx(:,501:4100),2)';

    xx=[];
    xx=cat(1,data_aper{i,:});
    aper(i,:)=mean(xx(:,501:4100),2)';
end

%% choose teh datasets to be used for training
%per vs aper 
class1=per;
class2=aper;
%%make it into feature- [20 (trials), n (neurons)].

% now ist in teh format of trials * neurons

%% these are cells 

% []=binaryLDA(class1,class2);
