function errorDocCallback(topic, fileName, lineNumber)
    % --------------------------------------------------------------------------------
    % --- Determining whether we should use the original function or the tweaked one
    % --------------------------------------------------------------------------------
    bTweak=false; 
    mlr=matlabroot; % matlab install path

    if length(fileName)<length(mlr)
        % most likely this is a user file
        bTweak=true; 
    else
        if isequal(fileName(1:length(mlr)),mlr)
            bTweak=false; 
        else
            bTweak=true; 
        end
    end

    if bTweak
        % --------------------------------------------------------------------------------
        % --- TWEAKED DOC CALLBACK to call editor
        % --------------------------------------------------------------------------------

        editor = system_dependent('getpref', 'EditorOtherEditor');
        editor = editor(2:end);
        file=fileName;
        if nargin==3
            linecol = sprintf('+%d',lineNumber); % tehre is something about -c "normal column|" but it didn't work
        else
            linecol = '';
        end

        if ispc
            % On Windows, we need to wrap the editor command in double quotes
            % in case it contains spaces
            command=['"' editor '" "' linecol '" "' file '"&'];
        else
            % On UNIX, we don't want to use quotes in case the user's editor
            % command contains arguments (like "xterm -e vi")
            %         disp('proiu');
            command=[editor ' "' linecol '" "' file '" &'];
        end
        disp('This is the tweaked version errorDocCallBack.')
        system(command);

    else


        if ~isempty(help(topic))
            helpPopup(topic);
        else
            functionName = topic;
            split = regexp(functionName, filemarker, 'split', 'once');
            hasFileMarker = numel(split) > 1;
            if hasFileMarker
                functionName = split{1};
                if ~isempty(help(functionName))
                    helpPopup(functionName);
                    return;
                end
            end
            className = regexp(functionName, '.*?(?=/[\w.]*$|\.\w+$)', 'match', 'once');
            if ~isempty(meta.class.fromName(className)) && ~isempty(help(className))
                helpPopup(className);
            else
                editTopic = topic;
                if ~hasFileMarker && isempty(className)
                    editTopic = [topic, filemarker, topic];
                end
                if ~edit(editTopic)
                    if nargin == 3 && ~isempty(fileName)
                        opentoline(fileName, lineNumber, 0);
                    else
                        helpdlg(getString(message('MATLAB:helpUtils:errorDocCallback:Undocumented', topic)), getString(message('MATLAB:helpUtils:errorDocCallback:UndocumentedTitle')));
                    end
                end
            end
        end
    end
    % 
    % %   Copyright 2010 The MathWorks, Inc.
    % %   $Revision: 1.1.6.5 $ $Date: 2011/10/22 22:03:55 $
end
