function WordAssociation()
global propComplete V Ngroups Words ptsEarned Nwords threshold
subject = input('What is your name?');
threshold = 1;
    try 
        Ngroups = [];
        V = struct();
        Words = {};
        load(strcat('VocabData',subject,'.mat'))
        Nwords = length(Words);
    catch
        Ngroups = [];
        V = struct();
        Words = {};
        load('VocabData.mat')
        Nwords = length(Words);
        save(strcat('VocabData',subject,'.mat'))
    end
        

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
        global Word Group otherGroups iW c
        % Pick a random Word:
        s = threshold;
        c = 1;
        while s>= threshold
            iW = ceil(rand(1)*Nwords);
            s = sum(Words{iW,4});
            c = c+1;
            if c == 2000
                figure(99)
                clf
                Congrats = uicontrol('Style','text',...
                    'String', 'Congratulations! You are moving up to the definition matching round.',...
                    'Position', [300 0 500 300]);
                    set (Congrats, 'FontWeight', 'Bold', 'FontSize', 30)
                break
            else
            end
        end
        % End of training (When we can't find a word randomly that doesn't
        % have a positive score after 2000 iterations of looking)
        if c == 2000
            figure(100)
                set(gcf,'Name', 'Performance Diagnostic', 'Position', [440 378 560 420])
                sortrows(Words, [5,7], 'descend')
                TestWord = Words(:,1);
                nClicks = [Words{:,5}]';
                TimeOnWord = [Words{:,7}]';
                tmp=table2cell(table(TestWord,nClicks,TimeOnWord));
                t=uitable('Parent', 100, 'Units', 'Normalized', 'Position', [0 0 1 1]);
                t.Data = tmp;
            return
        else
        end
                    
        Word = Words(iW,1);
        Group = Words(iW,3);
        % Some words are in two groups so we want to exclude them from the possible incorrect options.
        % Thus generate a term called potentialGroups
        potentialGroups= Words((strcmp(Words(:,1),Word)),3); 
            % And 4 other random groups:
            otherGroups = {};
            while numel(otherGroups) < 4
                ioG = ceil(rand(1)*Ngroups);
                otherGroup = {V(ioG).Group};
                if any(strcmp(otherGroup,[potentialGroups;otherGroups]))
                else
                    otherGroups = [otherGroups; V(ioG).Group];
                end
            end
    end

    function incorrect(source, event)
        global iW newTrialTimer checkDef 
        RL=toc(newTrialTimer);
        beep
        ptsEarned = -2+checkDef;
        checkDef = 0;
        %Note: The word can appear more than once on the list, but we are
        %keeping a separate tally of scores for each one
        Words{iW,4} = [Words{iW,4},-1];
            propComplete = sum(cellfun(@sum,[Words{:,4}]))/(Nwords*threshold);
        Words{iW,5} = numel(Words{iW,4});
        Words{iW,6} = [Words{iW,6},RL];
        Words{iW,7} = sum(Words{iW,6});
        assignin('base','Words', Words)
        save(strcat('VocabData',subject,'.mat'))
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
        Words{iW,5} = numel(Words{iW,4});
        Words{iW,6} = [Words{iW,6},RL];
        Words{iW,7} = sum(Words{iW,6});
        assignin('base','Words', Words)
        save(strcat('VocabData',subject,'.mat'))
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
        save(strcat('VocabData',subject,'.mat'))
    end

    function openLink(source,event)
        global iW
        tmp = char(Words(iW,1));
        web(strcat('https://en.oxforddictionaries.com/definition/',tmp))
    end
end
