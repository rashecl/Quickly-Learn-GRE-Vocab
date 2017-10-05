function definition = getDefinition(Word)
    import matlab.net.*
    import matlab.net.http.*
    request = RequestMessage;

    %Word = 'chicanery'
    request = matlab.net.http.RequestMessage;
    if numel(strsplit(Word,'/'))>1
        Word=strsplit(Word,'/');
        Word=char(Word(1));
        uri = matlab.net.URI(strcat('https://en.oxforddictionaries.com/definition/',Word));
    else
        uri = matlab.net.URI(strcat('https://en.oxforddictionaries.com/definition/',Word));
    end
    % uri = matlab.net.URI(strcat('https://en.oxforddictionaries.com/definition/', Word));
    
    response = send(request,uri);
    rawText = response.Body.Data;
    exceptions = {'fledgling','perplexing','unstinting','scathing','loathing','undulating'};
    % keyboard
    if numel(Word) > 3
        if strcmp(Word(end-3:end),'sing') && ~any(strcmp(Word,exceptions))
            Word=Word(1:end-3);
            Word=strcat(Word,'e');
        elseif strcmp(Word(end-2:end),'ing') && ~any(strcmp(Word,exceptions))
            Word=Word(1:end-3);
        else        
        end
    else
    end
    
    [~, remain] = strtok(rawText, strcat("Definition of ", Word," -"));
    definition = strsplit(remain, strcat("Definition of ", Word," -"));
    definition = strsplit(definition(2), 'name');
    definition = char(definition(1));
    definition = definition(2:end-2);
    if numel(definition) == 130
        definition = [definition, '...'];
    elseif numel(definition) == 0
        s=strsplit(rawText, '<span class="ind">');
        s = s(2);
        s=strsplit(s,'</span>');
        definition = char(s(1));
    else
    end
end
