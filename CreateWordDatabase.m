% This will create the necessary database for the word association
% training. It uses Group-Word Associations that are copied from: 
% https://quizlet.com/5821214/kaplan-gre-word-groups-flash-cards/
% Note: It isn't necessary to run this code as the required output is
% already saved in this folder. 

%% Import groups
textdata = importdata('VocabList.txt');
clear V
for i = 1:size(textdata,1)/2
    V(i)= struct('Group', char(textdata((i-1)*2+1)),...
        'Words', {strsplit(char(textdata((i-1)*2+2)),', ')});
end
Ngroups=size(V,2);
Words = [V.Words]';

%% Put groupNames into 'Words' cell
groupNames = {};
for g = 1:Ngroups
    for w = 1:numel(V(g).Words)
        groupNames=[groupNames, V(g).Group];
    end
end
Words(:,3)= groupNames';
Words(1:end,5)={0};
Words(1:end,7)={0};

%% Obtain definitions

for i=1:length(Words)
    Words(i,2)={getDefinition(char(Words(i,1)))};
    if mod(i,10)==0
        disp(strcat(num2str(i/length(Words)*100),'% of definitions'))
    else
    end
end
%% Save VocabData for running WordAssociation.m
    % This will overide the default VocabData list.
    save('VocabData.mat')