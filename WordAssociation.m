function WordAssociation()
global propComplete V Ngroups Words ptsEarned Nwords threshold
threshold = 1;
subject = input('What is your name?');
    try 
        keyboard
        tmp=load(strcat('VocabData',subject,'.mat'));
        V = tmp.V;
        Words = tmp.Words;
        Ngroups = tmp.Ngroups;
        Nwords = length(Words);
    catch
        Ngroups = [];
        V = struct();
        Words = {};
        load('VocabData.mat')
        Nwords = length(Words);
        save(strcat('VocabData',subject,'.mat'),'Words','V','Ngroups')
    end
e
propComplete = 0;
ptsEarned = 0;
newTrialData
plotUIpanels
    function plotUIpanels()
        global  Word Group otherGroups graphAxis newTrialTimer c
        persistent f
        if c == 2000
            return
        else
        end
        f = figure (99);
        clf
        set(f, 'Name', 'LearnVocabFast', 'Position', [250 125 1140 600])
        cPos = floor(rand(1)*5);
        otherPos = 0:4; otherPos(cPos == otherPos) = [];
        Directions = uicontrol('Style','text',...
                                'String','Pick the category associated with the word',...
                                'Position', [-100 530 640 50]);

        WordButton = uicontrol('Style','pushbutton',...
                                'String', Word,...
                                'Position', [30 175 560 400],...
                                'Callback',@defineWord);

        CorrectButton = uicontrol('Style','pushbutton',...
                                'String',Group,...
                                'Position', [cPos*220+30 75 200 50],...
                                'Callback',@correct);
        IncorrectButton1 = uicontrol('Style','pushbutton',...
                                'String',otherGroups(1),...
                                'Position', [otherPos(1)*220+30 75 200 50],...
                                'Callback',@incorrect);
        IncorrectButton2 = uicontrol('Style','pushbutton',...
                                'String',otherGroups(2),...
                                'Position', [otherPos(2)*220+30 75 200 50],...
                                'Callback',@incorrect);
        IncorrectButton3 = uicontrol('Style','pushbutton',...
                                'String',otherGroups(3),...
                                'Position', [otherPos(3)*220+30 75 200 50],...
                                'Callback',@incorrect);
        IncorrectButton4 = uicontrol('Style','pushbutton',...
                                'String',otherGroups(4),...
                                'Position', [otherPos(4)*220+30 75 200 50],...
                                'Callback',@incorrect);
        %% Format buttons:
            set (Directions, 'FontWeight', 'Bold', 'FontSize', 18)
            set (WordButton, 'FontWeight', 'Bold', 'FontSize', 50)
            set (CorrectButton, 'FontWeight', 'Bold', 'FontSize', 12)
            set (IncorrectButton1, 'FontWeight', 'Bold', 'FontSize', 12)
            set (IncorrectButton2, 'FontWeight', 'Bold', 'FontSize', 12)
            set (IncorrectButton3, 'FontWeight', 'Bold', 'FontSize', 12)
            set (IncorrectButton4, 'FontWeight', 'Bold', 'FontSize', 12)
        % UI panel for the current score
            graphPanel = uipanel('Parent',99);
                set(graphPanel,'Position',[.6 .25 .38 .66]);
                graphAxis = gca;
                set(graphAxis,'Parent',graphPanel);
                cla;
                bar(propComplete);
                title('% of training complete')
                ylim([0,100]);
                xticklabels({})
                xlabel('Proportion Complete')
                text(.95, -8, strcat(num2str(propComplete),'%'),'FontSize', 12, 'FontWeight', 'Bold', 'Color', 'k')
                try
                    if ptsEarned <0
                        text(1, propComplete + 10, num2str(ptsEarned), 'FontSize', 18, 'FontWeight', 'Bold', 'Color', 'r')
                    else
                        text(1, propComplete + 10, num2str(ptsEarned), 'FontSize', 18, 'FontWeight', 'Bold', 'Color', 'g')
                    end
                catch
                end
                newTrialTimer = tic;
    end

    function newTrialData()
        global Word Group otherGroups iW Def
        % Pick a random Word that doesn't meet the threshold:
        s = threshold;
        while s>= threshold
            iW = ceil(rand(1)*Nwords);
            s = sum(Words{iW,4});
        end
        Word = Words(iW,1);
        Def = Words(iW,2);
        Group = Words(iW,3);
        % Pick 4 other incorrect options. Some words have more than one
        % group (i.e. potentialCorrectAnswers), so we have to exclude those 
        % options from the possible incorrect options:
        potentialCorrectAnswers= Words((strcmp(Words(:,1),Word)),3); 
            otherGroups = {};
            while numel(otherGroups) < 4
                ioG = ceil(rand(1)*Ngroups);
                otherGroup = {V(ioG).Group};
                if any(strcmp(otherGroup,[potentialCorrectAnswers;otherGroups]))
                else
                    otherGroups = [otherGroups; V(ioG).Group];
                end
            end
    end

    function incorrect(source, event)
        global iW newTrialTimer checkDef Group Word Def
        RL=toc(newTrialTimer);
        beep
        figure (99)
            clf
            str=[char(Word), ' : ', char(Group), newline, char(Def)];
            PreviousAnswer = uicontrol('Style','text',...
                    'String', str,...
                    'Position', [50 300 1000 150]);
            set (PreviousAnswer, 'FontWeight', 'Bold', 'FontSize', 24, 'BackGroundColor', 'r')
            pause (numel(str)/20 + 1)
        ptsEarned = -2+checkDef;
        checkDef = 0;
        % Note: The word can belong to more than 1 group, but we are
        % keeping a separate tally of scores for each. 
        Words{iW,4} = [Words{iW,4},-1];
            propComplete = sum(cellfun(@sum,[Words{:,4}]))/(Nwords*threshold);
        Words{iW,5} = numel(Words{iW,4});
        Words{iW,6} = [Words{iW,6},RL];
        Words{iW,7} = sum(Words{iW,6});
        assignin('base','Words', Words)
        save(strcat('VocabData',subject,'.mat'),'Words','V','Ngroups')
        newTrialData
        plotUIpanels
    end
    
    function correct(source, event)
        global iW newTrialTimer checkDef 
        RL=toc(newTrialTimer);
        ptsEarned = 1+checkDef;
        checkDef = 0;
        Words{iW,4} = [Words{iW,4},1];
            propComplete = sum(cellfun(@sum,[Words{:,4}]))/(Nwords*threshold);
            if propComplete == 100 % Criteria for completetion
                completeTraining
            else
            end
            
        Words{iW,5} = numel(Words{iW,4});
        Words{iW,6} = [Words{iW,6},RL];
        
        Words{iW,7} = sum(Words{iW,6});
        assignin('base','Words', Words)
        save(strcat('VocabData',subject,'.mat'),'Words','V','Ngroups')
        newTrialData
        plotUIpanels
    end

    function defineWord(source, event)
        global iW checkDef 
        checkDef = -1;
        Definition = uicontrol('Style','pushbutton',...
                    'String', Words(iW,2),...
                    'Position', [30 125 640 50],...
                    'Callback', @openLink);
        set (Definition, 'FontWeight', 'Bold', 'FontSize', 12)
        Words{iW,4} = [Words{iW,4},-1];
        Words{iW,5} = numel(Words{iW,4});
        assignin('base','Words', Words)
        save(strcat('VocabData',subject,'.mat'),'Words','V','Ngroups')
    end

    function openLink(source,event)
        global iW
        tmp = char(Words(iW,1));
        web(strcat('https://en.oxforddictionaries.com/definition/',tmp))
    end
    
    function completeTraining
        figure(99)
            clf
            Congrats = uicontrol('Style','text',...
                'String', strcat('Congratulations! Your time per word was: ', num2str(mean(sum([Words{:,7}])/length(Words))),'s'),...
                'Position', [300 0 500 300]);
                set (Congrats, 'FontWeight', 'Bold', 'FontSize', 20)
        figure(100)
            set(gcf,'Name', 'Performance Diagnostic', 'Position', [440 378 560 420])
            Words = sortrows(Words, [5,7], 'descend');
            TestWord = Words(:,1);
            nClicks = [Words{:,5}]';
            TimeOnWord = [Words{:,7}]';
            tmp=table2cell(table(TestWord,nClicks,TimeOnWord));
            t=uitable('Parent', 100, 'Units', 'Normalized', 'Position', [0 0 1 1]);
            t.Data = tmp;
        return
    end     
end
